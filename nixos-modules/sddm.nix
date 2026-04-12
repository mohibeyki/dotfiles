{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.noctalia.sddm;

  metadataDesktop = pkgs.writeText "metadata.desktop" ''
    [SddmGreeterTheme]
    Name=Noctalia
    Description=Noctalia SDDM Theme
    Author=Noctalia Dev
    Copyright=(c) 2025 Noctalia Dev
    License=MIT
    Type=greeter
    Version=1.0
    MainScript=sddm.qml
    ConfigFile=theme.conf
    Theme-Id=noctalia
    Theme-API=2.0
    QtVersion=6
  '';

  themeConf = pkgs.writeText "theme.conf" ''
    [General]
    background=Assets/background.jpg
    blurRadius=${toString cfg.blurRadius}

    mPrimary=${cfg.colors.primary}
    mOnPrimary=${cfg.colors.onPrimary}
    mSecondary=${cfg.colors.secondary}
    mOnSecondary=${cfg.colors.onSecondary}
    mTertiary=${cfg.colors.tertiary}
    mOnTertiary=${cfg.colors.onTertiary}
    mError=${cfg.colors.error}
    mOnError=${cfg.colors.onError}
    mSurface=${cfg.colors.surface}
    mOnSurface=${cfg.colors.onSurface}
    mSurfaceVariant=${cfg.colors.surfaceVariant}
    mOnSurfaceVariant=${cfg.colors.onSurfaceVariant}
    mOutline=${cfg.colors.outline}
    mShadow=${cfg.colors.shadow}
    mHover=${cfg.colors.hover}
    mOnHover=${cfg.colors.onHover}
  '';

  theme = pkgs.linkFarm "sddm-noctalia" [
    {
      name = "share/sddm/themes/noctalia/sddm.qml";
      path = ./sddm.qml;
    }
    {
      name = "share/sddm/themes/noctalia/metadata.desktop";
      path = metadataDesktop;
    }
    {
      name = "share/sddm/themes/noctalia/theme.conf";
      path = themeConf;
    }
    {
      name = "share/sddm/themes/noctalia/Assets/background.jpg";
      path = cfg.background;
    }
  ];
in
{
  options.noctalia.sddm = {
    background = lib.mkOption {
      type = lib.types.path;
      description = "Path to the background image";
    };

    blurRadius = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Blur radius applied to the background";
    };

    colors = {
      primary = lib.mkOption {
        type = lib.types.str;
        default = "#c7a1d8";
      };
      onPrimary = lib.mkOption {
        type = lib.types.str;
        default = "#1a151f";
      };
      secondary = lib.mkOption {
        type = lib.types.str;
        default = "#a984c4";
      };
      onSecondary = lib.mkOption {
        type = lib.types.str;
        default = "#f3edf7";
      };
      tertiary = lib.mkOption {
        type = lib.types.str;
        default = "#e0b7c9";
      };
      onTertiary = lib.mkOption {
        type = lib.types.str;
        default = "#20161f";
      };
      error = lib.mkOption {
        type = lib.types.str;
        default = "#e9899d";
      };
      onError = lib.mkOption {
        type = lib.types.str;
        default = "#1e1418";
      };
      surface = lib.mkOption {
        type = lib.types.str;
        default = "#1c1822";
      };
      onSurface = lib.mkOption {
        type = lib.types.str;
        default = "#e9e4f0";
      };
      surfaceVariant = lib.mkOption {
        type = lib.types.str;
        default = "#262130";
      };
      onSurfaceVariant = lib.mkOption {
        type = lib.types.str;
        default = "#a79ab0";
      };
      outline = lib.mkOption {
        type = lib.types.str;
        default = "#342c42";
      };
      shadow = lib.mkOption {
        type = lib.types.str;
        default = "#120f18";
      };
      hover = lib.mkOption {
        type = lib.types.str;
        default = "#e0b7c9";
      };
      onHover = lib.mkOption {
        type = lib.types.str;
        default = "#20161f";
      };
    };
  };

  config = {
    services.displayManager.sddm = {
      theme = "noctalia";
      extraPackages = [ pkgs.kdePackages.qt5compat ];
    };

    environment.systemPackages = [ theme ];
  };
}
