import { CustomEditor, type ExtensionAPI, type ExtensionContext, type Theme } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";
import { basename } from "node:path";

class MessageStyleEditor extends CustomEditor {
	private chromeTheme: Theme;

	constructor(tui: any, editorTheme: any, keybindings: any, chromeTheme: Theme) {
		super(tui, editorTheme, keybindings, { paddingX: 1 });
		this.chromeTheme = chromeTheme;
	}

	private stripAnsi(text: string): string {
		return text.replace(/\x1b\[[0-9;]*m/g, "").replace(/\x1b\].*?\x07/g, "").replace(/\x1b_.*?\x1b\\/g, "");
	}

	private padVisible(text: string, width: number): string {
		const truncated = truncateToWidth(text, width, "");
		return truncated + " ".repeat(Math.max(0, width - visibleWidth(truncated)));
	}

	private isEditorBorderLine(text: string): boolean {
		return /^─+$/.test(text) || /^─── [↑↓] \d+ more ─*$/.test(text);
	}

	private panelPaint(text: string, fg: "userMessageText" | "muted" = "userMessageText"): string {
		const marker = "__PI_PANEL_MARKER__";
		const sample = this.chromeTheme.bg("userMessageBg", this.chromeTheme.fg(fg, marker));
		const [prefix] = sample.split(marker);
		return prefix + text.replace(/\x1b\[0m/g, `\x1b[0m${prefix}`) + "\x1b[0m";
	}

	render(width: number): string[] {
		const innerWidth = Math.max(1, width - 2);
		const bgWidth = Math.max(1, width - 1);
		const rawLines = super.render(innerWidth);
		const accentBar = this.chromeTheme.fg("accent", "▎");

		return rawLines.map((line) => {
			const plain = this.stripAnsi(line);
			if (this.isEditorBorderLine(plain)) {
				if (plain.includes(" more ")) {
					return accentBar + this.panelPaint(this.padVisible(` ${plain.replace(/^─+/, "").replace(/─+$/, "").trim()} `, bgWidth), "muted");
				}
				return accentBar + this.panelPaint(" ".repeat(bgWidth));
			}
			return accentBar + this.panelPaint(" " + this.padVisible(line, innerWidth));
		});
	}
}

type RuntimeState = "idle" | "thinking" | "tooling" | "waiting" | "done" | "error";

type GitInfo = {
	repoName: string;
	branch: string;
	staged: number;
	unstaged: number;
	untracked: number;
	ahead: number;
	behind: number;
};

type FooterState = {
	runtime: RuntimeState;
	toolDetails: Map<string, string>;
	lastError?: string;
	git?: GitInfo | null;
	modelId?: string;
	providerId?: string;
	thinkingLevel?: string;
	contextPercent?: number | null;
	contextTokens?: number | null;
	contextWindow?: number | null;
	inputTokens: number;
	outputTokens: number;
};

const DONE_MS = 1400;
const ERROR_MS = 2200;
const GIT_REFRESH_MS = 2500;

export default function (pi: ExtensionAPI) {
	const state: FooterState = {
		runtime: "idle",
		toolDetails: new Map(),
		git: undefined,
		modelId: undefined,
		providerId: undefined,
		thinkingLevel: undefined,
		contextPercent: null,
		contextTokens: null,
		contextWindow: null,
		inputTokens: 0,
		outputTokens: 0,
	};

	let requestRender: (() => void) | undefined;
	let lastGitRefresh = 0;
	let resetTimer: ReturnType<typeof setTimeout> | undefined;
	let currentCwd = "";

	const rerender = () => requestRender?.();

	const clearResetTimer = () => {
		if (resetTimer) {
			clearTimeout(resetTimer);
			resetTimer = undefined;
		}
	};

	const setTransientState = (next: RuntimeState, ms: number) => {
		state.runtime = next;
		renderSync();
		clearResetTimer();
		resetTimer = setTimeout(() => {
			if (state.toolDetails.size > 0) {
				state.runtime = "tooling";
			} else {
				state.runtime = "idle";
			}
			renderSync();
		}, ms);
	};

	const renderSync = () => {
		rerender();
	};

	const shortenHome = (path: string) => path.replace(/^\/home\/mohi/, "~");

	const fmtK = (n: number) => (n < 1000 ? `${n}` : `${(n / 1000).toFixed(n >= 10_000 ? 0 : 1)}k`);

	const cleanWhitespace = (text: string) => text.replace(/\s+/g, " ").trim();

	const shortenCommand = (command: string, max = 28) => {
		const cleaned = cleanWhitespace(command).replace(/^!+/, "");
		return cleaned.length > max ? `${cleaned.slice(0, Math.max(0, max - 1))}…` : cleaned;
	};

	const summarizePath = (path?: string) => {
		if (!path) return "path";
		const normalized = path.replace(/^@/, "");
		return basename(normalized) || normalized;
	};

	const summarizeUrl = (value?: string) => {
		if (!value) return "web";
		try {
			return new URL(value).hostname.replace(/^www\./, "");
		} catch {
			return value;
		}
	};

	const summarizeTool = (toolName: string, args: any): string => {
		switch (toolName) {
			case "bash":
				return `bash: ${shortenCommand(args?.command ?? "bash")}`;
			case "read":
				return `read: ${summarizePath(args?.path)}`;
			case "edit":
				return `edit: ${summarizePath(args?.path)}`;
			case "write":
				return `write: ${summarizePath(args?.path)}`;
			case "web_fetch":
				return `web: ${summarizeUrl(args?.url)}`;
			case "batch_web_fetch":
				return `web: ${Array.isArray(args?.requests) ? `${args.requests.length} urls` : "batch"}`;
			case "ask_user_question":
				return "form";
			default:
				return toolName.replace(/_/g, " ");
		}
	};

	const updateUsage = (ctx: ExtensionContext, recomputeTotals = false) => {
		state.modelId = ctx.model?.id;
		state.providerId = (ctx.model as any)?.provider;
		state.thinkingLevel = pi.getThinkingLevel();
		const contextUsage = ctx.getContextUsage();
		state.contextPercent = contextUsage?.percent ?? null;
		state.contextTokens = contextUsage?.tokens ?? null;
		state.contextWindow = contextUsage?.contextWindow ?? null;

		if (!recomputeTotals) return;

		let input = 0;
		let output = 0;
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type !== "message" || entry.message.role !== "assistant") continue;
			const usage = (entry.message as any).usage;
			input += usage?.input ?? 0;
			output += usage?.output ?? 0;
		}
		state.inputTokens = input;
		state.outputTokens = output;
	};

	const parseGitStatus = async (cwd: string): Promise<GitInfo | null> => {
		try {
			const root = await pi.exec("git", ["-C", cwd, "rev-parse", "--show-toplevel"]);
			if (root.code !== 0) return null;
			const toplevel = root.stdout.trim();
			if (!toplevel) return null;

			const status = await pi.exec("git", ["-C", cwd, "status", "--porcelain=v1", "--branch"]);
			if (status.code !== 0) return null;

			const lines = status.stdout.split(/\r?\n/).filter(Boolean);
			const branchLine = lines.find((line) => line.startsWith("## "))?.slice(3) ?? "";
			const branchName = branchLine.split("...")[0]?.trim() || "HEAD";
			const ahead = Number(/ahead (\d+)/.exec(branchLine)?.[1] ?? 0);
			const behind = Number(/behind (\d+)/.exec(branchLine)?.[1] ?? 0);

			let staged = 0;
			let unstaged = 0;
			let untracked = 0;

			for (const line of lines) {
				if (line.startsWith("## ")) continue;
				if (line.startsWith("??")) {
					untracked++;
					continue;
				}
				const x = line[0] ?? " ";
				const y = line[1] ?? " ";
				if (x !== " ") staged++;
				if (y !== " ") unstaged++;
			}

			return {
				repoName: basename(toplevel) || shortenHome(toplevel),
				branch: branchName,
				staged,
				unstaged,
				untracked,
				ahead,
				behind,
			};
		} catch {
			return null;
		}
	};

	const refreshGit = async (ctx: ExtensionContext, force = false) => {
		const now = Date.now();
		if (!force && now - lastGitRefresh < GIT_REFRESH_MS) return;
		lastGitRefresh = now;
		state.git = await parseGitStatus(ctx.cwd);
		renderSync();
	};

	const syncAll = async (ctx: ExtensionContext, forceGit = false) => {
		currentCwd = ctx.cwd;
		updateUsage(ctx, true);
		await refreshGit(ctx, forceGit);
		renderSync();
	};

	const footerLines = (theme: any, width: number, footerData: any): string[] => {
		const outerPad = " ".repeat(2);
		const availableWidth = Math.max(1, width - 4);
		const dim = (s: string) => theme.fg("dim", s);
		const text = (s: string) => theme.fg("text", s);
		const accent = (s: string) => theme.fg("accent", s);
		const success = (s: string) => theme.fg("success", s);
		const warning = (s: string) => theme.fg("warning", s);
		const error = (s: string) => theme.fg("error", s);
		const muted = (s: string) => theme.fg("muted", s);
		const sep = dim(" · ");

		const git = state.git;
		const repoBranch = git ? `${text(git.repoName)}${accent(`:${git.branch}`)}` : text(shortenHome(currentCwd || "~"));
		const gitCounts = git
			? [
				git.staged ? success(`+${git.staged}`) : "",
				git.unstaged ? warning(`~${git.unstaged}`) : "",
				git.untracked ? accent(`?${git.untracked}`) : "",
				git.ahead ? accent(`↑${git.ahead}`) : "",
				git.behind ? muted(`↓${git.behind}`) : "",
			]
				.filter(Boolean)
				.join(" ")
			: "";

		const toolDetail = state.toolDetails.size > 1
			? muted(`${state.toolDetails.size} tools`)
			: muted(Array.from(state.toolDetails.values())[0] ?? "");
		const extensionStatuses = footerData.getExtensionStatuses();
		const extensionStatusText = Array.from(extensionStatuses.entries())
			.sort(([a], [b]) => a.localeCompare(b))
			.map(([, text]) => text)
			.join(" ");
		const extensionDetail = extensionStatusText ? muted(extensionStatusText) : "";
		const errorDetail = state.lastError ? muted(state.lastError) : "";
		const activeDetail = state.runtime === "tooling"
			? [toolDetail, extensionDetail].filter(Boolean).join(sep)
			: state.runtime === "error"
				? errorDetail
				: extensionDetail;
		const middleRich = activeDetail;
		const middleTerse = activeDetail ? truncateToWidth(activeDetail, Math.max(1, Math.floor(availableWidth * 0.35)), dim("...")) : "";

		const provider = state.providerId ? muted(state.providerId) : "";
		const model = state.modelId ? text(state.modelId) : muted("no-model");
		const modelWithThinking = state.modelId && state.thinkingLevel
			? text(state.modelId) + muted(`:${state.thinkingLevel}`)
			: model;
		const ctxSection = state.contextTokens == null
			? ""
			: muted(
				[
					state.contextWindow ? `${fmtK(state.contextTokens)}/${fmtK(state.contextWindow)}` : `${fmtK(state.contextTokens)}`,
					state.contextPercent == null ? "" : `${Math.round(state.contextPercent)}%`,
				]
					.filter(Boolean)
					.join(" "),
			);
		const tokens = muted(`↑${fmtK(state.inputTokens)} ↓${fmtK(state.outputTokens)}`);
		const leftRich = [middleRich, provider, modelWithThinking].filter(Boolean).join(sep);
		const leftMedium = [middleTerse, provider, modelWithThinking].filter(Boolean).join(sep);
		const leftTerse = [middleTerse, modelWithThinking].filter(Boolean).join(sep);
		const rightRich = [tokens, ctxSection, repoBranch, gitCounts].filter(Boolean).join(sep);
		const rightMedium = [tokens, ctxSection, repoBranch].filter(Boolean).join(sep);
		const rightTerse = [tokens, repoBranch].filter(Boolean).join(sep);

		const candidates: Array<[string, string]> = [
			[leftRich, rightRich],
			[leftMedium, rightRich],
			[leftMedium, rightMedium],
			[leftTerse, rightMedium],
			[leftTerse, rightTerse],
		];

		let mainLine = outerPad + truncateToWidth([middleTerse, rightTerse].filter(Boolean).join("  "), availableWidth);
		for (const [left, right] of candidates) {
			if (!left) {
				if (visibleWidth(right) <= availableWidth) {
					mainLine = outerPad + truncateToWidth(right, availableWidth);
					break;
				}
				continue;
			}
			if (!right) {
				if (visibleWidth(left) <= availableWidth) {
					mainLine = outerPad + truncateToWidth(left, availableWidth);
					break;
				}
				continue;
			}

			const leftWidth = visibleWidth(left);
			const rightWidth = visibleWidth(right);
			if (leftWidth + 2 + rightWidth <= availableWidth) {
				const gap = " ".repeat(Math.max(2, availableWidth - leftWidth - rightWidth));
				mainLine = outerPad + left + gap + right;
				break;
			}
		}

		return [mainLine];
	};

	const installFooter = (ctx: ExtensionContext) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			requestRender = () => tui.requestRender();
			const unsub = footerData.onBranchChange(() => {
				refreshGit(ctx, true).catch(() => undefined);
				tui.requestRender();
			});

			return {
				dispose: () => {
					requestRender = undefined;
					unsub();
				},
				invalidate() {},
				render(width: number): string[] {
					return footerLines(theme, width, footerData);
				},
			};
		});
	};

	pi.on("session_start", async (_event, ctx) => {
		clearResetTimer();
		state.runtime = "idle";
		state.toolDetails.clear();
		state.lastError = undefined;
		ctx.ui.setEditorComponent((tui, theme, keybindings) => new MessageStyleEditor(tui, theme, keybindings, ctx.ui.theme));
		installFooter(ctx);
		await syncAll(ctx, true);
	});

	pi.on("model_select", async (event, ctx) => {
		state.modelId = event.model.id;
		updateUsage(ctx, true);
		renderSync();
	});

	pi.on("agent_start", async (_event, ctx) => {
		clearResetTimer();
		state.runtime = ctx.hasPendingMessages() ? "waiting" : "thinking";
		updateUsage(ctx);
		renderSync();
	});

	pi.on("message_update", async (_event, ctx) => {
		if (state.toolDetails.size === 0 && state.runtime !== "error") {
			state.runtime = "thinking";
		}
		updateUsage(ctx);
		renderSync();
	});

	pi.on("tool_execution_start", async (event, ctx) => {
		clearResetTimer();
		state.runtime = "tooling";
		state.toolDetails.set(event.toolCallId, summarizeTool(event.toolName, (event as any).args));
		updateUsage(ctx);
		renderSync();
	});

	pi.on("tool_execution_end", async (event, ctx) => {
		state.toolDetails.delete(event.toolCallId);
		updateUsage(ctx, true);
		await refreshGit(ctx);
		if (event.isError) {
			state.lastError = `${event.toolName} failed`;
			setTransientState("error", ERROR_MS);
			return;
		}
		state.runtime = state.toolDetails.size > 0 ? "tooling" : "thinking";
		renderSync();
	});

	pi.on("turn_end", async (_event, ctx) => {
		state.toolDetails.clear();
		await syncAll(ctx, true);
		if (ctx.hasPendingMessages()) {
			state.runtime = "waiting";
			renderSync();
			return;
		}
		setTransientState("done", DONE_MS);
	});

	pi.on("session_shutdown", async () => {
		clearResetTimer();
		requestRender = undefined;
	});
}
