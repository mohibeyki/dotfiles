_: {
  programs.helix = {
    enable = true;
    defaultEditor = false;

    settings = {
      theme = "rose_pine_moon";

      editor = {
        bufferline = "always";
        color-modes = true;
        completion-trigger-len = 2;
        cursorline = true;
        end-of-line-diagnostics = "hint";
        idle-timeout = 250;
        insert-final-newline = true;
        line-number = "relative";
        mouse = false;
        popup-border = "all";
        preview-completion-insert = false;
        rulers = [ 160 ];
        scrolloff = 8;
        shell = [
          "fish"
          "-c"
        ];
        text-width = 160;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        auto-save = {
          after-delay = {
            enable = true;
            timeout = 3000;
          };
          focus-lost = true;
        };

        file-picker = {
          git-exclude = true;
          git-global = true;
          git-ignore = true;
          hidden = false;
          max-depth = 8;
        };

        gutters = {
          layout = [
            "diagnostics"
            "diff"
            "line-numbers"
            "spacer"
          ];
          line-numbers = {
            min-width = 1;
          };
        };

        indent-guides = {
          character = "▏";
          render = true;
          skip-levels = 1;
        };

        inline-diagnostics = {
          cursor-line = "warning";
          max-diagnostics = 20;
          max-wrap = 80;
          other-lines = "info";
        };

        lsp = {
          auto-signature-help = true;
          display-color-swatches = true;
          display-inlay-hints = true;
          display-messages = true;
          display-signature-help-docs = true;
          enable = true;
          snippets = true;
        };

        search = {
          smart-case = true;
          wrap-around = true;
        };

        smart-tab = {
          enable = true;
          supersede-menu = true;
        };

        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
          "`" = "`";
          "<" = ">";
        };

        statusline = {
          center = [ "file-name" ];
          left = [
            "file-modification-indicator"
            "mode"
            "read-only-indicator"
            "version-control"
          ];
          right = [
            "diagnostics"
            "file-encoding"
            "file-line-ending"
            "file-type"
            "position"
            "register"
            "selections"
            "spinner"
            "workspace-diagnostics"
          ];
          separator = "│";
          mode = {
            insert = "INSERT";
            normal = "NORMAL";
            select = "SELECT";
          };
        };

        whitespace = {
          characters = {
            nbsp = "⍽";
            newline = "⏎";
            nnbsp = "␣";
            space = "·";
            tab = "→";
            tabpad = "·";
          };
          render = {
            nbsp = "all";
            newline = "none";
            nnbsp = "all";
            space = "all";
            tab = "all";
          };
        };
      };

      keys = {
        insert = {
          A-h = "move_char_left";
          A-j = "move_line_down";
          A-k = "move_line_up";
          A-l = "move_char_right";
        };

        normal = {
          "C-[" = ":buffer-previous";
          "C-]" = ":buffer-next";
          C-d = "half_page_down";
          C-u = "half_page_up";
          C-l = ":fmt";
          C-n = [
            "move_line_down"
            "scroll_down"
          ];
          C-p = [
            "move_line_up"
            "scroll_up"
          ];
          C-q = ":buffer-close";
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          H = "goto_line_start";
          L = "goto_line_end";
        };
      };
    };

    languages = {
      language-server = {
        rust-analyzer = {
          command = "rust-analyzer";
          config = {
            inlayHints = {
              bindingModeHints.enable = false;
              closingBraceHints.minLines = 10;
              closureReturnTypeHints.enable = "with_block";
              discriminantHints.enable = "fieldless";
              lifetimeElisionHints.enable = "skip_trivial";
              typeHints.hideClosureInitialization = false;
            };
            check = {
              command = "clippy";
            };
            files = {
              watcher = "server";
            };
          };
        };
      };

      language = [
        {
          name = "toml";
          formatter = {
            command = "taplo";
            args = [ "format" "-" ];
          };
        }
        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          persistent-diagnostic-sources = [ "rustc" "clippy" ];
        }
        {
          name = "zig";
          language-servers = [ "zls" ];
          formatter = {
            command = "zig";
            args = [ "fmt" "--stdin" ];
          };
        }
        {
          name = "cpp";
          language-servers = [ "clangd" ];
          auto-format = true;
        }
        {
          name = "c";
          language-servers = [ "clangd" ];
          auto-format = true;
        }
      ];
    };
  };
}
