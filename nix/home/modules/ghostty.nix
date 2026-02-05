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
      quit-after-last-window-closed = true;
      theme = "Rose Pine";
      window-padding-balance = true;
      keybind = [
        "shift+enter=text:\\x1b\\r"
      ];
      macos-option-as-alt = true;
    };
  };
}
