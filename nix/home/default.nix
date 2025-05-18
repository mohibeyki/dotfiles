{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = [ ];
  };

  programs = {
    home-manager.enable = true;

    fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo = {
          padding = {
            top = 2;
          };
        };
        display = {
          separator = " ➜  ";
        };
        "modules" = [
          "break"
          "break"
          "break"
          {
            type = "os";
            key = "OS   ";
            keyColor = "31";
          }
          {
            type = "kernel";
            key = " ├  ";
            keyColor = "31";
          }
          {
            type = "shell";
            key = " └  ";
            keyColor = "31";
          }
          "break"
          {
            type = "wm";
            key = "WM   ";
            keyColor = "32";
          }
          {
            type = "wmtheme";
            key = " ├ 󰉼 ";
            keyColor = "32";
          }
          {
            type = "icons";
            key = " ├ 󰀻 ";
            keyColor = "32";
          }
          {
            type = "cursor";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "terminal";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "terminalfont";
            key = " └  ";
            keyColor = "32";
          }
          "break"
          {
            type = "host";
            format = "{5} {1} Type {2}";
            key = "PC   ";
            keyColor = "33";
          }
          {
            type = "cpu";
            format = "{1} ({3}) @ {7} GHz";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "gpu";
            format = "{1} {2} @ {12} GHz";
            key = " ├ 󰢮 ";
            keyColor = "33";
          }
          {
            type = "memory";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "swap";
            key = " ├ 󰓡 ";
            keyColor = "33";
          }
          {
            type = "disk";
            key = " ├ 󰋊 ";
            keyColor = "33";
          }
          {
            type = "monitor";
            key = " └  ";
            keyColor = "33";
          }
          "break"
          "break"
        ];
      };
    };

    git = {
      enable = true;
      userName = "Mohi Beyki";
      userEmail = "mohibeyki@gmail.com";
      ignores = [ ".DS_Store" ];
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      };
    };

    helix = {
      enable = true;
    };

    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
    };
  };

  home.stateVersion = "25.05";
}
