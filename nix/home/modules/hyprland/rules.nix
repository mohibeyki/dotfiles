{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # Layer rules
    layerrule = [
      "blur on, match:namespace wofi"
      "blur on, match:namespace logout_dialog"
      "no_anim on, match:namespace ^(selection)$"
    ];

    # Window rules
    windowrule = [
      "tag +chromium-based-browser, match:class ([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)"
      "tag +terminal, match:class (Alacritty|kitty|com.mitchellh.ghostty)"
      "tag +floating-window, match:class (blueberry.py|Impala|com.github.tsowell.wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)"
      "tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"

      "tile on, match:tag chromium-based-browser"
      "float on, match:title ^(pavucontrol)$"
      "float on, match:title ^(blueman-manager)$"
      "float on, match:title ^(nm-connection-editor)$"
      "float on, match:title ^(Calculator)$"

      "float on, match:title ^(Picture-in-Picture)$"
      "pin on, match:title ^(Picture-in-Picture)$"
      "move 69.5% 4%, match:title ^(Picture-in-Picture)$"

      "idle_inhibit fullscreen, match:class ([window])"

      "float on, match:tag floating-window"
      "center on, match:tag floating-window"
      "size 800 600, match:tag floating-window"

      "fullscreen on, match:class Screensaver"
      "opacity 1 1, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
    ];
  };
}
