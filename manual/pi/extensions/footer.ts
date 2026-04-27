import { homedir } from "node:os";
import { basename } from "node:path";
import {
	CustomEditor,
	type ExtensionAPI,
	type ExtensionContext,
	type Theme,
} from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

// Augment the upstream type to include the provider field that exists at runtime
// but is not yet declared in the public ExtensionContext type.
declare module "@mariozechner/pi-coding-agent" {
	interface ModelInfo {
		provider?: string;
	}
}

// ── Editor ────────────────────────────────────────────────────────────────────

class MessageStyleEditor extends CustomEditor {
	constructor(
		tui: unknown,
		editorTheme: unknown,
		keybindings: unknown,
		private chromeTheme: Theme,
	) {
		super(tui, editorTheme, keybindings, { paddingX: 1 });
	}

	private stripAnsi(text: string): string {
		return text
			.replace(/\x1b\[[0-9;]*m/g, "")
			.replace(/\x1b\].*?\x07/g, "")
			.replace(/\x1b_.*?\x1b\\/g, "");
	}

	private padVisible(text: string, width: number): string {
		const truncated = truncateToWidth(text, width, "");
		return truncated + " ".repeat(Math.max(0, width - visibleWidth(truncated)));
	}

	private isBorderLine(text: string): boolean {
		// Matches a plain border line or a "N more" overflow indicator line
		return /^─+$/.test(text) || /^─── (?:↑|↓) \d+ more ─*$/.test(text);
	}

	private panelPaint(
		text: string,
		fg: "userMessageText" | "muted" = "userMessageText",
	): string {
		const marker = "__PI_PANEL_MARKER__";
		const sample = this.chromeTheme.bg(
			"userMessageBg",
			this.chromeTheme.fg(fg, marker),
		);
		const [prefix] = sample.split(marker);
		if (!prefix) return text;
		return prefix + text.replace(/\x1b\[0m/g, `\x1b[0m${prefix}`) + "\x1b[0m";
	}

	render(width: number): string[] {
		const innerWidth = Math.max(1, width - 2);
		const bgWidth = Math.max(1, width - 1);
		const rawLines = super.render(innerWidth);
		const accentBar = this.chromeTheme.fg("accent", "▎");

		return rawLines.map((line) => {
			const plain = this.stripAnsi(line);
			if (this.isBorderLine(plain)) {
				if (plain.includes(" more ")) {
					return (
						accentBar +
						this.panelPaint(
							this.padVisible(
								` ${plain.replace(/^─+/, "").replace(/─+$/, "").trim()} `,
								bgWidth,
							),
							"muted",
						)
					);
				}
				return accentBar + this.panelPaint(" ".repeat(bgWidth));
			}
			return (
				accentBar + this.panelPaint(" " + this.padVisible(line, innerWidth))
			);
		});
	}
}

// ── Types ─────────────────────────────────────────────────────────────────────

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

// ── Constants ─────────────────────────────────────────────────────────────────

const GIT_REFRESH_MS = 2500;
const GIT_COUNTER_DIGITS = 2; // caps display at 99, intentional for layout stability
const HOME_DIR = homedir();

// ── Extension ─────────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
	const state: FooterState = {
		inputTokens: 0,
		outputTokens: 0,
	};

	let render: (() => void) | undefined;
	let lastGitRefresh = 0;
	let currentCwd = "";

	// ── Helpers ───────────────────────────────────────────────────────────────

	const requestRender = () => render?.();

	const shortenHome = (path: string) =>
		path.startsWith(HOME_DIR) ? `~${path.slice(HOME_DIR.length)}` : path;

	const fmtK = (n: number) =>
		n < 1000 ? `${n}` : `${(n / 1000).toFixed(n >= 10_000 ? 0 : 1)}k`;

	// ── State updaters ────────────────────────────────────────────────────────

	const updateUsage = (ctx: ExtensionContext) => {
		state.modelId = ctx.model?.id;
		state.providerId = ctx.model?.provider;
		state.thinkingLevel = pi.getThinkingLevel();
		const usage = ctx.getContextUsage();
		state.contextPercent = usage?.percent ?? null;
		state.contextTokens = usage?.tokens ?? null;
		state.contextWindow = usage?.contextWindow ?? null;
	};

	const recomputeTokenTotals = (ctx: ExtensionContext) => {
		let input = 0;
		let output = 0;
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type !== "message" || entry.message.role !== "assistant")
				continue;
			const usage = (entry.message as { usage?: { input?: number; output?: number } }).usage;
			input += usage?.input ?? 0;
			output += usage?.output ?? 0;
		}
		state.inputTokens = input;
		state.outputTokens = output;
	};

	const parseGitStatus = async (cwd: string): Promise<GitInfo | null> => {
		try {
			const root = await pi.exec("git", [
				"-C",
				cwd,
				"rev-parse",
				"--show-toplevel",
			]);
			if (root.code !== 0 || !root.stdout.trim()) return null;
			const toplevel = root.stdout.trim();

			const status = await pi.exec("git", [
				"-C",
				cwd,
				"status",
				"--porcelain=v1",
				"--branch",
			]);
			if (status.code !== 0) return null;

			const lines = status.stdout.split(/\r?\n/).filter(Boolean);
			const branchLine = lines.find((l) => l.startsWith("## "))?.slice(3) ?? "";
			const branch = branchLine.split("...")[0]?.trim() || "HEAD";
			const ahead = Number(/ahead (\d+)/.exec(branchLine)?.[1] ?? 0);
			const behind = Number(/behind (\d+)/.exec(branchLine)?.[1] ?? 0);

			let staged = 0,
				unstaged = 0,
				untracked = 0;
			for (const line of lines) {
				if (line.startsWith("## ")) continue;
				if (line.startsWith("??")) {
					untracked++;
					continue;
				}
				if ((line[0] ?? " ") !== " ") staged++;
				if ((line[1] ?? " ") !== " ") unstaged++;
			}

			return {
				repoName: basename(toplevel) || shortenHome(toplevel),
				branch,
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
		requestRender();
	};

	// refreshGit already calls requestRender, so no trailing call needed here
	const syncAll = async (
		ctx: ExtensionContext,
		forceGit = false,
		recomputeTotals = false,
	) => {
		currentCwd = ctx.cwd;
		updateUsage(ctx);
		if (recomputeTotals) recomputeTokenTotals(ctx);
		await refreshGit(ctx, forceGit);
	};

	// ── Footer render ─────────────────────────────────────────────────────────

	const footerLines = (theme: { fg: (color: string, text: string) => string }, width: number): string[] => {
		const outerPad = "  ";
		const availableWidth = Math.max(1, width - 4);

		const dim = (s: string) => theme.fg("dim", s);
		const text = (s: string) => theme.fg("text", s);
		const accent = (s: string) => theme.fg("accent", s);
		const success = (s: string) => theme.fg("success", s);
		const warning = (s: string) => theme.fg("warning", s);
		const muted = (s: string) => theme.fg("muted", s);
		const sep = dim(" · ");

		const fixedCount = (
			prefix: string,
			count: number,
			paint: (s: string) => string,
		) => {
			const bounded = `${Math.max(0, Math.min(99, count))}`.padStart(
				GIT_COUNTER_DIGITS,
				"0",
			);
			return paint(`${prefix}${bounded}`);
		};

		// Git
		const git = state.git;
		const repoName = git?.repoName ?? shortenHome(currentCwd || "~");
		const branchName = git?.branch ?? "-";
		const repoBranch = `${text(repoName)}${accent(`:${branchName}`)}`;
		const gitCounts = [
			fixedCount("+", git?.staged ?? 0, success),
			fixedCount("~", git?.unstaged ?? 0, warning),
			fixedCount("?", git?.untracked ?? 0, muted),
			fixedCount("↑", git?.ahead ?? 0, accent),
			fixedCount("↓", git?.behind ?? 0, muted),
		].join(" ");

		// Model / context
		const provider = state.providerId ? muted(state.providerId) : "";
		const modelBase = state.modelId ? text(state.modelId) : muted("no-model");
		const modelWithThinking =
			state.modelId && state.thinkingLevel
				? text(state.modelId) + muted(`:${state.thinkingLevel}`)
				: modelBase;
		const ctxSection =
			state.contextTokens == null
				? ""
				: muted(
						[
							state.contextWindow
								? `${fmtK(state.contextTokens)}/${fmtK(state.contextWindow)}`
								: `${fmtK(state.contextTokens)}`,
							state.contextPercent != null
								? `${Math.round(state.contextPercent)}%`
								: "",
						]
							.filter(Boolean)
							.join(" "),
					);
		const tokens = muted(
			`↑${fmtK(state.inputTokens)} ↓${fmtK(state.outputTokens)}`,
		);

		// Left/right sections at different widths
		const leftRich = [provider, modelWithThinking].filter(Boolean).join(sep);
		const leftTerse = [modelWithThinking].filter(Boolean).join(sep);
		const rightFull = [tokens, ctxSection, repoBranch, gitCounts]
			.filter(Boolean)
			.join(sep);
		const rightTerse = [tokens, repoBranch, gitCounts]
			.filter(Boolean)
			.join(sep);

		const candidates: Array<[string, string]> = [
			[leftRich, rightFull],
			[leftTerse, rightFull],
			[leftTerse, rightTerse],
		];

		let mainLine =
			outerPad +
			truncateToWidth(
				[leftTerse, rightTerse].filter(Boolean).join("  "),
				availableWidth,
			);
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
			const lw = visibleWidth(left);
			const rw = visibleWidth(right);
			if (lw + 2 + rw <= availableWidth) {
				mainLine =
					outerPad +
					left +
					" ".repeat(Math.max(2, availableWidth - lw - rw)) +
					right;
				break;
			}
		}

		return [mainLine];
	};

	// ── Footer install ────────────────────────────────────────────────────────

	const installFooter = (ctx: ExtensionContext) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			render = () => tui.requestRender();
			const unsub = footerData.onBranchChange(() => {
				currentCwd = ctx.cwd;
				updateUsage(ctx);
				recomputeTokenTotals(ctx);
				// Use requestRender() to go through the null guard, not tui.requestRender() directly
				refreshGit(ctx, true).catch(() => undefined);
				requestRender();
			});

			return {
				dispose: () => {
					render = undefined;
					unsub();
				},
				invalidate() {},
				render: (w: number) => footerLines(theme, w),
			};
		});
	};

	// ── Events ────────────────────────────────────────────────────────────────

	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.setEditorComponent(
			(tui, theme, keybindings) =>
				new MessageStyleEditor(tui, theme, keybindings, ctx.ui.theme),
		);
		installFooter(ctx);
		await syncAll(ctx, true, true);
	});

	pi.on("model_select", async (event, ctx) => {
		state.modelId = event.model.id;
		updateUsage(ctx);
		requestRender();
	});

	pi.on("agent_start", async (_event, ctx) => {
		updateUsage(ctx);
		requestRender();
	});

	pi.on("message_update", async (_event, ctx) => {
		updateUsage(ctx);
		requestRender();
	});

	pi.on("tool_execution_start", async (_event, ctx) => {
		updateUsage(ctx);
		requestRender();
	});

	pi.on("tool_execution_end", async (_event, ctx) => {
		updateUsage(ctx);
		await refreshGit(ctx);
		requestRender();
	});

	pi.on("turn_end", async (_event, ctx) => {
		await syncAll(ctx, true, true);
		requestRender();
	});

	pi.on("session_shutdown", async () => {
		render = undefined;
	});
}
