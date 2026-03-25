{ ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = true;
      core-os-services.enable = true;
      core-shell.enable = true;

      gnome-keyring.enable = true;
    };

    xserver.enable = false;
  };

  programs.dconf.enable = true;
}
