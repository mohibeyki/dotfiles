{
  pkgs,
  ...
}:
{
  home.packages = with pkgs.llm-agents; [
    opencode
    grok
  ];
}

