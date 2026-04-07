{
  pkgs,
  lib,
  ...
}:
let
  gtkTheme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };

  iconTheme = {
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

  dconf.settings."org/gnome/Console" = {
    custom-font = "JetBrainsMono Nerd Font 12";
    use-system-font = false;
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

    gtk4.enable = true;

    font = {
      name = "Noto Sans";
      size = 12;
    };
  };

  # Remove KDE defaults to prevent icon theme conflicts
  home.activation = {
    removeKdeDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.config/kdedefaults" ]; then
        $DRY_RUN_CMD rm -rf "$HOME/.config/kdedefaults"
        $VERBOSE_ECHO "Removed ~/.config/kdedefaults to prevent KDE icon theme override"
      fi
    '';
  };
}
