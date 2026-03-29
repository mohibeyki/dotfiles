{ config, lib, ... }:
let
  cfg = config.mohi.desktop;
in
lib.mkIf (cfg.mode == "gnome") {
  services = {
    desktopManager.gnome.enable = true;

    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = true;
      core-os-services.enable = true;
      core-shell.enable = true;
    };

    xserver.enable = false;
  };

  programs.dconf.enable = true;
}
