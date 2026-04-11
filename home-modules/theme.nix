{
  inputs,
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

  cursorTheme = {
    name = "rose-pine-hyprcursor";
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
    size = 24;
  };
in
{
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    font-name = "Noto Sans 12";
    gtk-theme = gtkTheme.name;
    icon-theme = iconTheme.name;
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

  home.pointerCursor = {
    inherit (cursorTheme) name size package;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
