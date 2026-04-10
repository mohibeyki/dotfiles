{
  pkgs,
  ...
}:
let
  gtkTheme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };

  iconTheme = {
    name = "Tela-dark";
    package = pkgs.tela-icon-theme;
  };
in
{
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = "Vimix-cursors";
    font-name = "Noto Sans 12";
    gtk-theme = gtkTheme.name;
    icon-theme = iconTheme.name;
    cursor-size = 16;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      inherit (gtkTheme) name package;
    };

    iconTheme = {
      inherit (iconTheme) name package;
    };

    gtk4.enable = true;

    font = {
      name = "Noto Sans";
      size = 12;
    };
  };
}
