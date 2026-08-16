{
  inputs,
  pkgs,
  ...
}:
{
  home.packages =
    with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    [
      opencode
      grok
      claude-code
      t3code
      t3code-desktop
    ];
}


