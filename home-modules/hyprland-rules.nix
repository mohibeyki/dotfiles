{
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "blur on, match:namespace logout_dialog"
      "no_anim on, match:namespace ^(selection)$"
    ];

    windowrule = [
      # ── Tags ────────────────────────────────────────────────────────────────

      # Browser types (for future rules / workspace assignment)
      "tag +chromium-based-browser, match:class ([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)"
      "tag +terminal, match:class (Alacritty|kitty|com.mitchellh.ghostty)"

      # Games — most Steam games use steam_app_<appid> as their initial class
      "tag +game, match:initial_class ^(steam_app_.*)$"

      # Game launchers — Steam main window, Heroic, Lutris, Cartridges, Bottles
      "tag +game-launcher, match:class ^(steam)$"
      "tag +game-launcher, match:class ^(com.heroicgameslauncher.hgl)$"
      "tag +game-launcher, match:class ^(net.lutris.Lutris)$"
      "tag +game-launcher, match:class ^(page.kramo.Cartridges)$"
      "tag +game-launcher, match:class ^(com.usebottles.bottles)$"

      # Quick-access utilities — password manager, audio, networking, system tools
      "tag +quick-access, match:class ^(1password)$"
      "tag +quick-access, match:class ^(com.github.tsowell.wiremix)$"
      "tag +quick-access, match:class ^(org.kde.kcalc)$"
      "tag +quick-access, match:class ^(gparted)$"
      "tag +quick-access, match:class ^(transmission-gtk)$"
      "tag +quick-access, match:class ^(org.pulseaudio.pavucontrol)$"
      "tag +quick-access, match:title ^(nm-connection-editor)$"

      # Media players — need full opacity (inactive_opacity would wash out video)
      "tag +media-player, match:class ^(vlc|mpv|imv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|zoom)$"

      # Generic floating windows — dialogs, file pickers, misc popups
      "tag +floating-window, match:class (Impala|com.gabm.satty|Omarchy|About|TUI.float)"
      "tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"

      # ── Rules by tag ────────────────────────────────────────────────────────

      # Games — send to workspace 9 and fullscreen automatically
      "workspace 9 silent, match:tag game"
      "fullscreen on, match:tag game"

      # Browsers always tile (Chromium-based sometimes opens floating)
      "tile on, match:tag chromium-based-browser"

      # Game launchers: float, centered, consistent size, full opacity
      "float on, match:tag game-launcher"
      "center on, match:tag game-launcher"
      "size 1200 800, match:tag game-launcher"
      "opacity 1.0 1.0, match:tag game-launcher"

      # Quick-access: float and center at natural size
      "float on, match:tag quick-access"
      "center on, match:tag quick-access"

      # Media players: full opacity
      "opacity 1.0 1.0, match:tag media-player"

      # Generic floating windows
      "float on, match:tag floating-window"
      "center on, match:tag floating-window"
      "size 800 600, match:tag floating-window"

      # ── Specific overrides ───────────────────────────────────────────────────

      # Steam Friends List — narrower than the default game-launcher size
      "size 300 600, match:class ^(steam)$, match:title ^(Friends List)$"

      # Steam News popup
      "float on, match:class ^(steam)$, match:title ^(Steam - News)$"

      # GParted and Transmission — larger than natural quick-access default
      "size 900 700, match:class ^(gparted)$"
      "size 900 600, match:class ^(transmission-gtk)$"

      # BambuStudio — 3D slicer, always full opacity
      "opacity 1.0 1.0, match:class ^(com.bambulab.BambuStudio)$"

      # Picture-in-Picture — pinned floating in top-right corner
      "float on, match:title ^(Picture-in-Picture)$"
      "pin on, match:title ^(Picture-in-Picture)$"
      "move 69.5% 4%, match:title ^(Picture-in-Picture)$"
      "suppress_event windowclose, match:title ^(Picture-in-Picture)$"

      # Screensaver
      "fullscreen on, match:class Screensaver"

      # Prevent idle / screensaver while any window is fullscreen
      "idle_inhibit fullscreen, match:fullscreen 1"
    ];
  };
}
