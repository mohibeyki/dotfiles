{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.gnome-themes-extra;
    name = "Adwaita";
    size = 16;
  };

  # GTK theme configuration
  gtk = {
    enable = true;

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    cursorTheme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    font = {
      name = "Noto Sans";
      size = 12;
    };
  };
}
