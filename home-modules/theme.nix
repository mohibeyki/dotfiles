{ pkgs, ... }:
{
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
      name = "Adwaita";
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
        name = "Adwaita";
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
