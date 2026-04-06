{ ... }:
{
  services = {
    desktopManager.gnome.enable = true;
    gnome.gnome-software.enable = true;

    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = true;
      core-os-services.enable = true;
      core-shell.enable = true;
    };
  };

  programs.dconf.enable = true;
}
