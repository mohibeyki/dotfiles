{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode
    pi
    grok
    claude-code
    codex
    herdr
  ];
}
