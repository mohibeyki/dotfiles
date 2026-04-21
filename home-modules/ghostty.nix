{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  programs.ghostty = {
    enable = true;
    package = lib.mkIf isDarwin null;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];

      macos-option-as-alt = true;
      quit-after-last-window-closed = true;
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";
      theme = "Rose Pine Moon";
      window-padding-balance = true;
    };
  };
}
