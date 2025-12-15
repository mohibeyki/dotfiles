{ ... }:
{
  programs.ghostty = {
    enable = true;
    # Ghostty for macOS is distributed via DMG, not nix
    # Set package to null to only manage config without installing
    package = null;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];
      quit-after-last-window-closed = true;
      theme = "TokyoNight";
      window-padding-balance = true;
      keybind = "shift+enter=text:\\x1b\\r";
      macos-option-as-alt = true;
    };
  };
}
