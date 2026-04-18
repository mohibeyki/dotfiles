{
  inputs,
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
    name = "Tela-dark";
    package = pkgs.tela-icon-theme;
  };

  cursorTheme = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  hyprcursorTheme = {
    name = "rose-pine-hyprcursor";
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
in
{
  gtk = {
    enable = true;

    # Override existing config files
    gtk2.force = true;

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

  home.packages = [ hyprcursorTheme.package ];

  # Without this, xdg-desktop-portal-kde starts with a default light Qt
  # palette under Hyprland (no full Plasma session), causing the Settings
  # portal to report prefer-light. Scoped to the portal service only —
  # setting it globally breaks apps like Noctalia that lack kirigami.
  home.file.".config/systemd/user/plasma-xdg-desktop-portal-kde.service.d/qt-theme.conf".text =
    lib.generators.toINI { } { Service.Environment = "QT_QPA_PLATFORMTHEME=kde"; };

  programs.plasma = {
    enable = true;
    workspace.colorScheme = "BreezeDark";
  };

  home.pointerCursor = {
    inherit (cursorTheme) name size package;
    gtk.enable = true;
    x11.enable = true;
  };
}
