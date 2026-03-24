{ pkgs, ... }:
{
  # Enable GDM display manager (Wayland)
  services.displayManager.gdm.enable = true;

  # Enable GNOME desktop environment
  services.desktopManager.gnome.enable = true;

  # Enable GNOME Keyring for credential management
  security.pam.services.login.enableGnomeKeyring = true;

  # Common GNOME packages and utilities
  environment.systemPackages = with pkgs; [
    # Core GNOME apps
    gnome-console
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell

    # GNOME integration
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk

    # File management
    nautilus

    # System utilities
    gnome-system-monitor
    gnome-disk-utility
    gnome-calculator
    gnome-calendar
    gnome-clocks

    # Media
    totem
    evince

    # Theming
    adwaita-icon-theme
    gnome-themes-extra
  ];

  # Remove some default GNOME packages that you might not want
  services.gnome.core-apps.enable = true;
}
