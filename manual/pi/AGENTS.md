# Global Agent Guidance

## Response style
- Be concise by default.
- Answer directly first, then add brief supporting detail if needed.
- State assumptions clearly when something is uncertain.
- Prefer bullets over long prose.

## Editing and implementation
- Prefer minimal, targeted diffs over broad rewrites.
- Read files before editing them.
- Preserve the existing code style, structure, and naming unless there is a clear reason to change them.
- Do not perform unrelated cleanup unless asked or unless it is directly required to complete the task safely.
- When changing files, always mention the exact file paths.
- Remove dead code when it is directly related to the change being made.

## Safety and change management
- Never commit, push, or perform destructive cleanup without explicit user approval.
- Ask before making irreversible, high-blast-radius, or architectural changes.
- Prefer dry-run, validation, or evaluation commands before applying changes when such commands exist.
- Call out risks, tradeoffs, and follow-up actions clearly.

## Tool preferences
- Use `rg`, `find`, and shell commands for discovery.
- Use the `read` tool instead of `cat` for reading files.
- Use precise edits instead of full rewrites whenever practical.
- Use background processes for long-running commands.
- Avoid noisy polling or unnecessary repeated commands.

## Configuration and dotfiles preferences
- Prefer declarative, reproducible configuration over ad-hoc fixes.
- Prefer pinned versions when practical for shared or long-lived configuration.
- Avoid introducing tools that create unexpected per-project clutter unless they provide clear value.
- This user's global pi setup is managed from dotfiles via symlinks where practical; preserve that pattern.

## Nix and dotfiles workflow
- Respect flake structure, module boundaries, and host-specific separation.
- Prefer changes that fit naturally into the existing NixOS/Home Manager/darwin layout.
- Suggest the appropriate rebuild, eval, or validation command after Nix changes.
- Do not assume Home Manager is running as a live user service unless explicitly stated.

## Decision-making
- Ask clarifying questions when requirements are ambiguous.
- For meaningful choices, briefly explain tradeoffs and recommend one option when possible.
- Use explicit confirmation for high-stakes decisions.

## Code quality
- Prefer simple, boring, maintainable solutions.
- Avoid overengineering.
- Avoid adding dependencies unless they are justified by clear value.
- Keep comments sparse and useful.

## Research and verification
- For pi-specific questions, check pi docs before guessing.
- For library or API behavior, prefer source-backed or doc-backed answers.
- Distinguish verified facts from inference.

## Change summaries
- When making a change, summarize:
  1. what changed
  2. which files were touched
  3. how to apply or verify the change
