{
  pkgs,
  lib,
  hostConfig,
  ...
}:
let
  desktopMode = hostConfig.desktopMode or "gnome";

  # Theme configurations based on desktop mode
  gtkTheme =
    if desktopMode == "plasma" then
      {
        name = "Breeze-Dark";
        package = pkgs.kdePackages.breeze-gtk;
      }
    else
      {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

  iconTheme =
    if desktopMode == "plasma" then
      {
        name = "breeze-dark";
        package = pkgs.kdePackages.breeze-icons;
      }
    else
      {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
in
{
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = "Bibata-Modern-Classic";
    font-name = "Noto Sans 12";
    gtk-theme = gtkTheme.name;
    icon-theme = iconTheme.name;
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
      inherit (gtkTheme) name package;
    };

    iconTheme = {
      inherit (iconTheme) name package;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4 = {
      theme = {
        inherit (gtkTheme) name package;
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

  # Remove KDE defaults when using GNOME mode to prevent icon theme conflicts
  home.activation = lib.mkIf (desktopMode == "gnome") {
    removeKdeDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.config/kdedefaults" ]; then
        $DRY_RUN_CMD rm -rf "$HOME/.config/kdedefaults"
        $VERBOSE_ECHO "Removed ~/.config/kdedefaults to prevent KDE icon theme override"
      fi
    '';
  };
}
