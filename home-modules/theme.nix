{ pkgs, ... }:
{
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = "Bibata-Modern-Classic";
    font-name = "Noto Sans 12";
    gtk-theme = "Adwaita-dark";
    icon-theme = "Adwaita";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4 = {
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    font = {
      name = "Noto Sans";
      size = 12;
    };
  };
}
