{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    # Ghostty for macOS is distributed via DMG, not nix
    # Set package to null to only manage config without installing
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

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
      window-decoration = false;
      window-padding-balance = true;
    };
  };
}
