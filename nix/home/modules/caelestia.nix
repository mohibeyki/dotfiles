{ inputs, pkgs, hostConfig, lib, config, ... }:
let
  monitorLines = builtins.concatStringsSep "\n" (
    map (
      monitor: ''
        monitorv2 {
            output = ${monitor.output}
            mode = ${monitor.mode}
            position = ${monitor.position}
            scale = ${toString monitor.scale}
            bitdepth = ${toString monitor.bitdepth}
            vrr = ${if monitor.vrr then "1" else "0"}
        }
      ''
    ) (hostConfig.monitors or [ ])
  );
  workspaceLines = builtins.concatStringsSep "\n" (
    map (workspace: "workspace = ${workspace}") (hostConfig.workspaces or [ ])
  );
  hyprVarsConfig = ''
    $touchpadScrollFactor = 1.0
    $blurSize = 16
    $blurPasses = 4
    $shadowRange = 16
    $windowOpacity = 1.0
    $windowRounding = 8
    $windowBorderSize = 0
  '';
  hyprUserConfig = builtins.readFile ./caelestia/hypr-user.conf + ''

    general {
        border_size = 0
        gaps_in = 8
        gaps_out = 8
        layout = dwindle
    }

    input {
        kb_layout = us
        kb_options = altwin:swap_lalt_lwin
        numlock_by_default = true
        follow_mouse = 1
        mouse_refocus = false
        sensitivity = -0.2
        accel_profile = flat

        touchpad {
            natural_scroll = true
            scroll_factor = 1.0
        }
    }

    decoration {
        rounding = 8
        active_opacity = 1.0
        inactive_opacity = 0.9
        fullscreen_opacity = 1.0

        blur {
            enabled = true
            size = 16
            passes = 4
            ignore_opacity = true
            new_optimizations = true
            xray = false
        }

        shadow {
            enabled = true
            range = 16
            render_power = 3
            color = 0xee1a1a1a
        }
    }

    animations {
        enabled = true

        animation = global    , 1, 4, default
        animation = windows   , 1, 4, default, popin 60%
        animation = workspaces, 1, 4, default, slide
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        font_family = JetBrainsMono Nerd Font
        vrr = 0
    }

    dwindle {
        pseudotile = true
        preserve_split = true
    }

    layerrule = blur on, match:namespace logout_dialog
    layerrule = no_anim on, match:namespace ^(selection)$

    windowrule = tag +chromium-based-browser, match:class ([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)
    windowrule = tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)
    windowrule = tag +terminal, match:class (Alacritty|kitty|com.mitchellh.ghostty)
    windowrule = tag +floating-window, match:class (blueberry.py|Impala|com.github.tsowell.wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)
    windowrule = tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)
    windowrule = tile on, match:tag chromium-based-browser
    windowrule = float on, match:title ^(pavucontrol)$
    windowrule = float on, match:title ^(blueman-manager)$
    windowrule = float on, match:title ^(nm-connection-editor)$
    windowrule = float on, match:title ^(Calculator)$
    windowrule = float on, match:title ^(Picture-in-Picture)$
    windowrule = pin on, match:title ^(Picture-in-Picture)$
    windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
    windowrule = idle_inhibit fullscreen, match:class ([window])
    windowrule = float on, match:tag floating-window
    windowrule = center on, match:tag floating-window
    windowrule = size 800 600, match:tag floating-window
    windowrule = fullscreen on, match:class Screensaver
    windowrule = opacity 1 1, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$
  ''
  + (if monitorLines == "" then "" else "\n${monitorLines}\n")
  + (if workspaceLines == "" then "" else "\n${workspaceLines}\n");
in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = true;
    cli.enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ hostConfig.wallpaper ];
      wallpaper = {
        monitor = "";
        path = hostConfig.wallpaper;
        fit_mode = "fill";
      };
    };
  };

  # Caelestia provides the base config. Personal overrides live in ~/.config/caelestia.
  xdg.configFile = {
    "hypr/hyprland" = {
      source = "${inputs.caelestia}/hypr/hyprland";
      recursive = true;
    };
    "hypr/scheme/default.conf".source = "${inputs.caelestia}/hypr/scheme/default.conf";
    "hypr/scripts" = {
      source = "${inputs.caelestia}/hypr/scripts";
      recursive = true;
    };
    "hypr/hyprland.conf".source = "${inputs.caelestia}/hypr/hyprland.conf";
    "hypr/variables.conf".source = "${inputs.caelestia}/hypr/variables.conf";
    "foot".source = "${inputs.caelestia}/foot";
    "btop".source = "${inputs.caelestia}/btop";
    "fastfetch".source = "${inputs.caelestia}/fastfetch";
    "starship.toml".source = "${inputs.caelestia}/starship.toml";
  };

  home.file = {
    ".config/caelestia/shell.json".source = ./caelestia/shell.json;
    ".config/caelestia/hypr-user.conf".text = hyprUserConfig;
    ".config/caelestia/hypr-vars.conf".text = hyprVarsConfig;
  };

  home.activation.caelestiaHyprScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    scheme_dir="${config.home.homeDirectory}/.config/hypr/scheme"
    mkdir -p "$scheme_dir"
    install -m644 ${inputs.caelestia}/hypr/scheme/default.conf "$scheme_dir/default.conf"
    if [ ! -e "$scheme_dir/current.conf" ]; then
      cp "$scheme_dir/default.conf" "$scheme_dir/current.conf"
    fi
  '';

  # Caelestia runtime dependencies
  home.packages = with pkgs; [
    brightnessctl
    cliphist
    eza
    fastfetch
    foot
    fuzzel
    grim
    hyprpicker
    inotify-tools
    libnotify
    papirus-icon-theme
    slurp
    starship
    swappy
    trash-cli
    wl-clipboard
    zoxide
  ];
}
