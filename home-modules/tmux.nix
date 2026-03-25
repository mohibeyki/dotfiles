{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "ghostty";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour "mocha"
          set -g @catppuccin_window_status_style "rounded"

          # Window status
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
        '';
      }
    ];

    extraConfig = ''
      set-option -ga terminal-overrides ",ghostty:Tc"

      # clear on Ctrl+k
      bind -n C-k send-keys -R \; send-keys C-l \; clear-history

      # split panes using | and -
      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf

      bind M-h previous-window
      bind M-l next-window

      # base 1 indexing
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # vi mode settings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # pane resize key bindings
      bind h resize-pane -L 10
      bind j resize-pane -D 5
      bind k resize-pane -U 5
      bind l resize-pane -R 10
    '';
  };
}
