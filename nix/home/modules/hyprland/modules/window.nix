{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    windowrule = [
      # Browser types
      "tag +chromium-based-browser, class:([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, class:([fF]irefox|zen|librewolf)"

      # Force chromium-based browsers into a tile to deal with --app bug
      "tile, tag:chromium-based-browser"

      "float, title:^(pavucontrol)$"
      "float, title:^(blueman-manager)$"
      "float, title:^(nm-connection-editor)$"
      "float, title:^(Calculator)$"

      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "move 69.5% 4%, title:^(Picture-in-Picture)$"

      "idleinhibit fullscreen,class:([window])"

      # Floating windows
      "float, tag:floating-window"
      "center, tag:floating-window"
      "size 800 600, tag:floating-window"

      "tag +floating-window, class:(blueberry.py|Impala|com.github.tsowell.wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)"
      "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), title:^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"

      # Fullscreen screensaver
      "fullscreen, class:Screensaver"

      # No transparency on media windows
      "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"

      # Terminal tag
      "tag +terminal, class:(Alacritty|kitty|com.mitchellh.ghostty)"
    ];
  };
}
