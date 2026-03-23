{
  inputs,
  pkgs,
  hostConfig,
  lib,
  config,
  ...
}:
let
  monitorLines = builtins.concatStringsSep "\n" (
    map (monitor: ''
      monitorv2 {
          output = ${monitor.output}
          mode = ${monitor.mode}
          position = ${monitor.position}
          scale = ${toString monitor.scale}
          bitdepth = ${toString monitor.bitdepth}
          vrr = ${if monitor.vrr then "1" else "0"}
      }
    '') (hostConfig.monitors or [ ])
  );
  workspaceLines = builtins.concatStringsSep "\n" (
    map (workspace: "workspace = ${workspace}") (hostConfig.workspaces or [ ])
  );
  hyprVarsConfig = ''
    $touchpadScrollFactor = 1.0
    $blurSize = 16
    $blurPasses = 4
    $shadowRange = 16
    $workspaceGaps = 20
    $windowGapsIn = 10
    $windowGapsOut = 40
    $singleWindowGapsOut = 8
    $windowOpacity = 1.0
    $windowRounding = 8
    $windowBorderSize = 0
  '';
  hyprUserConfig =
    builtins.readFile ./caelestia/hypr-user.conf
    + (if monitorLines == "" then "" else "\n${monitorLines}\n")
    + (if workspaceLines == "" then "" else "\n${workspaceLines}\n")
    + "\nexec-once = ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent\n";
in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = true;
    package = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.override {
      app2unit = pkgs.app2unit;
    };
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

  home.activation.caelestiaThemeRosePineMoon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v caelestia >/dev/null 2>&1; then
      caelestia scheme set --name rosepine --flavour moon --mode dark >/dev/null 2>&1 || true
    fi
  '';


  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpmsoff && hyprctl dispatch dpmson";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

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
