_:
let
  globalAgentRules.source = ./AGENTS.md;
in
{
  home.file = {
    ".claude/CLAUDE.md" = globalAgentRules;
    ".pi/agent/AGENTS.md" = globalAgentRules;
  };
}
