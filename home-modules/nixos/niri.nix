{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.dotfiles) host;

  quote = builtins.toJSON;

  stripDesc = output: lib.removePrefix "desc:" output;

  mainOutput = stripDesc (builtins.elemAt host.monitors 0).output;
  sideOutput = stripDesc (builtins.elemAt host.monitors 1).output;
  kdlDir = ./niri;

  # Niri wants the exact refresh with three decimals if specified. Omitting the
  # refresh makes it pick the highest mode for that resolution. This keeps the
  # main monitor at 4K/240Hz without depending on EDID rounding variants.
  niriMode = monitor: builtins.head (lib.splitString "@" monitor.mode);

  monitorBlock =
    monitor:
    let
      output = stripDesc monitor.output;
      position = lib.splitString "x" monitor.position;
      x = builtins.elemAt position 0;
      y = builtins.elemAt position 1;
      vrrLine = lib.optionalString ((monitor.vrr or 0) != 0) ''
        // Keep VRR on-demand to avoid OLED desktop flicker; matching windows enable it below.
        variable-refresh-rate on-demand=true
      '';
      focusLine = lib.optionalString (output == mainOutput) ''
        focus-at-startup
      '';
    in
    ''
      output ${quote output} {
          mode ${quote (niriMode monitor)}
          scale ${toString monitor.scale}
          position x=${x} y=${y}
      ${vrrLine}${focusLine}    }
    '';

  workspaceBlock = name: output: ''
    workspace ${quote name} {
        open-on-output ${quote output}
    }
  '';

  workspaceBlocks = lib.concatStrings [
    # Odd workspaces on the side monitor, even workspaces on the main monitor.
    (workspaceBlock "1" sideOutput)
    (workspaceBlock "3" sideOutput)
    (workspaceBlock "5" sideOutput)
    (workspaceBlock "7" sideOutput)
    (workspaceBlock "9" sideOutput)
    (workspaceBlock "2" mainOutput)
    (workspaceBlock "4" mainOutput)
    (workspaceBlock "6" mainOutput)
    (workspaceBlock "8" mainOutput)
    (workspaceBlock "10" mainOutput)
  ];

  nvidiaEnvironment = lib.optionalString host.isNvidia ''
    LIBVA_DRIVER_NAME "nvidia"
    __GLX_VENDOR_LIBRARY_NAME "nvidia"
    NVD_BACKEND "direct"
  '';

  inputLayoutKdl = builtins.readFile (kdlDir + "/10-input-layout.kdl");
  rulesKdl = builtins.readFile (kdlDir + "/30-rules.kdl");
  baseBindsKdl = builtins.readFile (kdlDir + "/40-binds.kdl");

  # Dispatch wrapper that routes shell actions based on DOTFILES_SHELL env var.
  shellDispatch = pkgs.writeShellScriptBin "dotfiles-shell-dispatch" ''
    action="$1"
    case "''${DOTFILES_SHELL:-caelestia}" in
      caelestia)
        case "$action" in
          start) exec caelestia shell -d ;;
          launcher) exec caelestia shell drawers toggle launcher ;;
          cmd) exec caelestia shell drawers toggle launcher ;;
          clipboard) exec caelestia clipboard ;;
          session) exec caelestia shell drawers toggle session ;;
          emoji) exec caelestia emoji -p ;;
          lock) exec caelestia shell lock lock ;;
          sidebar) exec caelestia shell drawers toggle sidebar ;;
          windows) exec true ;;
          playpause) exec caelestia shell mpris playPause ;;
          prev) exec caelestia shell mpris previous ;;
          next) exec caelestia shell mpris next ;;
          volup) exec wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ ;;
          voldown) exec wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
          volmute) exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
          *) exec true ;;
        esac ;;
      noctalia)
        case "$action" in
          start) exec env -u QT_QPA_PLATFORMTHEME noctalia ;;
          launcher) exec noctalia msg panel-toggle launcher ;;
          cmd) exec noctalia msg panel-toggle launcher /cmd ;;
          clipboard) exec noctalia msg panel-toggle clipboard ;;
          session) exec noctalia msg settings-toggle ;;
          emoji) exec noctalia msg panel-toggle launcher /emo ;;
          lock) exec noctalia msg session lock ;;
          sidebar) exec noctalia msg panel-toggle control-center ;;
          windows) exec noctalia msg window-switcher ;;
          playpause) exec noctalia msg media toggle ;;
          prev) exec noctalia msg media previous ;;
          next) exec noctalia msg media next ;;
          volup) exec noctalia msg volume-up ;;
          voldown) exec noctalia msg volume-down ;;
          volmute) exec noctalia msg volume-mute ;;
          *) exec true ;;
        esac ;;
      *)
        exec true ;;
    esac
  '';

  shellDispatchBin = "${shellDispatch}/bin/dotfiles-shell-dispatch";

  shellBindsKdl = ''
    // Shell binds unified via dotfiles-shell-dispatch (reads DOTFILES_SHELL env).
    Mod+P { spawn "${shellDispatchBin}" "launcher"; }
    Mod+Shift+P { spawn "${shellDispatchBin}" "cmd"; }
    Mod+V { spawn "${shellDispatchBin}" "clipboard"; }
    Mod+O { spawn "${shellDispatchBin}" "windows"; }
    Mod+Comma { spawn "${shellDispatchBin}" "session"; }
    Mod+Period { spawn "${shellDispatchBin}" "emoji"; }
    Mod+Ctrl+Escape { spawn "${shellDispatchBin}" "lock"; }
    Mod+Ctrl+Q { spawn "${shellDispatchBin}" "sidebar"; }
    XF86AudioPlay { spawn "${shellDispatchBin}" "playpause"; }
    XF86AudioPrev { spawn "${shellDispatchBin}" "prev"; }
    XF86AudioNext { spawn "${shellDispatchBin}" "next"; }
    XF86AudioRaiseVolume { spawn "${shellDispatchBin}" "volup"; }
    XF86AudioLowerVolume { spawn "${shellDispatchBin}" "voldown"; }
    XF86AudioMute { spawn "${shellDispatchBin}" "volmute"; }
  '';

  # Shell startup: the dispatch wrapper handles both shells; Niri starts
  # whichever DOTFILES_SHELL points to.
  shellStartup = ''
    spawn-at-startup "${shellDispatchBin}" "start"
  '';

  startupBlock = ''
    spawn-at-startup "systemctl" "--user" "start" "plasma-kwallet-pam.service"
    spawn-at-startup "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6"
    spawn-at-startup "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
    spawn-at-startup "${pkgs.blueman}/bin/blueman-applet"
    ${shellStartup}spawn-at-startup "${pkgs._1password-gui}/bin/1password" "--silent"
  '';

  bindsKdl = baseBindsKdl + "\n" + shellBindsKdl;
in
{
  xdg.configFile."niri/config.kdl".text = ''
    // Generated by Home Manager: home-modules/nixos/niri.nix
    // Niri is kept alongside Hyprland and Plasma; select it from SDDM.

    ${lib.concatMapStrings monitorBlock host.monitors}

    // Odd workspaces (1,3,5,7,9) on the side monitor; even workspaces (2,4,6,8,10) on the main monitor.
    ${workspaceBlocks}

    environment {
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        NIXOS_OZONE_WL "1"
    ${nvidiaEnvironment}    }

    ${inputLayoutKdl}

    ${startupBlock}

    ${rulesKdl}

    ${bindsKdl}
  '';

  home.packages = [ shellDispatch ];
}
