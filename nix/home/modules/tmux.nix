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
        plugin = pkgs.tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_window_id_style fsquare
          set -g @tokyo-night-tmux_pane_id_style hsquare
          set -g @tokyo-night-tmux_zoom_id_style dsquare

          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_date_format YMD
          set -g @tokyo-night-tmux_time_format 24H

          set -g @tokyo-night-tmux_show_path 1
          set -g @tokyo-night-tmux_path_format relative
        '';
      }
    ];

    extraConfig = ''
      set-option -ga terminal-overrides ",ghostty:Tc"

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
