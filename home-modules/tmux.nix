{
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
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
        plugin = pkgs.tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'moon'
          set -g @rose_pine_host 'on'
          set -g @rose_pine_date_time '%H:%M'
          set -g @rose_pine_directory 'on'
          set -g @rose_pine_show_current_program 'on'
          set -g @rose_pine_show_pane_directory 'on'

          # Status bar sizing
          set -g status-right-length 100
          set -g status-left-length 100

          # Pane borders — inactive: subtle, active: foam (cyan) bold
          set -g pane-border-style 'fg=#44415a'
          set -g pane-active-border-style 'fg=#9ccfd8,bold'
          set -g pane-border-lines heavy
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
