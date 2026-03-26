{ lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.zed-editor = {
    enable = true;
    package = lib.mkIf isDarwin null;

    extensions = [
      "dockerfile"
      "kdl"
      "lua"
      "make"
      "nix"
      "rose-pine-theme"
      "toml"
      "zig"
    ];

    userSettings = {
      inlay_hints = {
        show_background = true;
        enabled = true;
      };

      load_direnv = "shell_hook";
      show_whitespaces = "all";

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      vim = {
        use_smartcase_find = true;
        toggle_relative_line_numbers = true;
      };

      minimap = {
        show = "always";
      };

      relative_line_numbers = "enabled";
      which_key = {
        enabled = true;
      };

      ui_font_family = ".ZedSans";
      buffer_line_height = "comfortable";
      buffer_font_family = "JetBrainsMono Nerd Font";
      auto_update = isDarwin;
      restore_on_startup = "last_session";
      use_system_prompts = true;
      when_closing_with_no_tabs = "keep_window_open";
      on_last_window_closed = "quit_app";
      use_system_path_prompts = true;
      helix_mode = false;
      vim_mode = true;
      base_keymap = "VSCode";

      icon_theme = {
        mode = "dark";
        light = "Zed (Default)";
        dark = "Zed (Default)";
      };

      ui_font_size = 16;
      buffer_font_size = 16;

      theme = {
        mode = "dark";
        light = "Rosé Pine Dawn";
        dark = "Rosé Pine Moon";
      };

      languages = {
        Nix = {
          language_servers = [ "nixd" ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };

        Rust = {
          language_servers = [ "rust-analyzer" ];
        };

        Python = {
          language_servers = [ "pyright" ];
          formatter = {
            external = {
              command = "ruff";
              arguments = [
                "format"
                "-"
              ];
            };
          };
        };

        Go = {
          language_servers = [ "gopls" ];
        };

        Lua = {
          language_servers = [ "lua-language-server" ];
          formatter = {
            external = {
              command = "stylua";
            };
          };
        };

        JSON = {
          language_servers = [ "jsonls" ];
        };

        YAML = {
          language_servers = [ "yamlls" ];
        };

        TOML = {
          language_servers = [ "taplo" ];
          formatter = {
            external = {
              command = "taplo";
              arguments = [
                "fmt"
                "-"
              ];
            };
          };
        };

        Markdown = {
          language_servers = [ "marksman" ];
        };

        C = {
          language_servers = [ "clangd" ];
        };

        "C++" = {
          language_servers = [ "clangd" ];
        };

        zig = {
          language_servers = [ "zls" ];
          formatter = {
            external = {
              command = "zig";
              arguments = [
                "fmt"
                "--stdin"
              ];
            };
          };
        };
      };
    };
  };
}
