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
    MainScript=Main.qml
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
      name = "share/sddm/themes/noctalia/Main.qml";
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
      path = ../assets/sddm.jpg;
    }
    {
      name = "share/sddm/themes/noctalia/Assets/face.png";
      path = ../assets/face.png;
    }
  ];
in
{
  options.noctalia.sddm = {
    blurRadius = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Blur radius applied to the background";
    };

    colors = {
      primary = lib.mkOption {
        type = lib.types.str;
        default = "#c4a7e7";
      };
      onPrimary = lib.mkOption {
        type = lib.types.str;
        default = "#232136";
      };
      secondary = lib.mkOption {
        type = lib.types.str;
        default = "#56526e";
      };
      onSecondary = lib.mkOption {
        type = lib.types.str;
        default = "#e0def4";
      };
      tertiary = lib.mkOption {
        type = lib.types.str;
        default = "#ea9a97";
      };
      onTertiary = lib.mkOption {
        type = lib.types.str;
        default = "#232136";
      };
      error = lib.mkOption {
        type = lib.types.str;
        default = "#eb6f92";
      };
      onError = lib.mkOption {
        type = lib.types.str;
        default = "#232136";
      };
      surface = lib.mkOption {
        type = lib.types.str;
        default = "#232136";
      };
      onSurface = lib.mkOption {
        type = lib.types.str;
        default = "#e0def4";
      };
      surfaceVariant = lib.mkOption {
        type = lib.types.str;
        default = "#2a273f";
      };
      onSurfaceVariant = lib.mkOption {
        type = lib.types.str;
        default = "#908caa";
      };
      outline = lib.mkOption {
        type = lib.types.str;
        default = "#393552";
      };
      shadow = lib.mkOption {
        type = lib.types.str;
        default = "#232136";
      };
      hover = lib.mkOption {
        type = lib.types.str;
        default = "#44415a";
      };
      onHover = lib.mkOption {
        type = lib.types.str;
        default = "#e0def4";
      };
    };
  };

  config = {
    services.displayManager.sddm.extraPackages = with pkgs; [
      kdePackages.qt5compat
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    environment.systemPackages = [ theme ];
  };
}
