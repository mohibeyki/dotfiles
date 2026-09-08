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

    colorScheme = "dark";

    theme = {
      inherit (gtkTheme) name package;
    };

    iconTheme = {
      inherit (iconTheme) name package;
    };

    gtk4 = {
      enable = true;
      # stateVersion 26.05 no longer copies gtk.theme onto GTK 4.
      theme = {
        inherit (gtkTheme) name package;
      };
    };

    font = {
      name = "Noto Sans";
      size = 12;
    };
  };

  home = {
    packages = [ hyprcursorTheme.package ];

    pointerCursor = {
      enable = true;
      inherit (cursorTheme) name size package;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  # Without this, Qt apps running outside a full Plasma session (Hyprland)
  # initialize with a default light palette. This breaks xdg-desktop-portal-kde
  # (reports prefer-light) and KDE apps like Dolphin (mismatched alternating
  # row colors).
  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

  home.sessionVariables.BROWSER = "brave-origin";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-origin.desktop";
      "application/xhtml+xml" = "brave-origin.desktop";
      "x-scheme-handler/http" = "brave-origin.desktop";
      "x-scheme-handler/https" = "brave-origin.desktop";
      "x-scheme-handler/about" = "brave-origin.desktop";
      "x-scheme-handler/unknown" = "brave-origin.desktop";
    };
  };

  programs.plasma = {
    enable = true;
    workspace.colorScheme = "BreezeDark";
    configFile.kdeglobals.General.BrowserApplication = "brave-origin.desktop";
  };
}
