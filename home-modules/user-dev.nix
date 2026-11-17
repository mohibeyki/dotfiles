{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages =
    with agents;
    [
      opencode
      pi
      grok
      herdr
    ]
    # macOS uses the official native installer (~/.local/bin/claude) instead.
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ claude-code ];
}
