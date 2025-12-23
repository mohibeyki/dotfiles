{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
  };

  # Zellij configuration using KDL format
  # Home-manager doesn't have native zellij config support, so we use xdg.configFile
  xdg.configFile."zellij/config.kdl".text = ''
    keybinds clear-defaults=true {
        locked {
            bind "F12" { SwitchToMode "normal"; }
        }

        normal {
            bind "Ctrl a" { SwitchToMode "tmux"; }
            bind "F12"    { SwitchToMode "locked"; }
            bind "Ctrl q" { Quit; }
            bind "Ctrl h" { MoveFocus "left";  SwitchToMode "Normal"; }
            bind "Ctrl j" { MoveFocus "down";  SwitchToMode "Normal"; }
            bind "Ctrl k" { MoveFocus "up";    SwitchToMode "Normal"; }
            bind "Ctrl l" { MoveFocus "right"; SwitchToMode "Normal"; }
        }

        tmux {
            // Control commands
            bind "Ctrl a" { Write 2; SwitchToMode "normal"; }
            bind "d"      { Detach; }
            bind "s"      { SwitchToMode "search"; }

            // Resize Panes
            bind "h"  { Resize  "Increase Left"; }
            bind "j"  { Resize  "Increase Down"; }
            bind "k"  { Resize  "Increase Up"; }
            bind "l"  { Resize  "Increase right"; }

            // New Panes
            bind "-"  { NewPane "down";  SwitchToMode "normal"; }
            bind "\\" { NewPane "right"; SwitchToMode "normal"; }

            // Layout
            bind "space"  { NextSwapLayout; SwitchToMode "normal"; }
            bind "f"      { ToggleFocusFullscreen; SwitchToMode "normal"; }

            // Tab
            bind "c" { NewTab;          SwitchToMode "normal"; }
            bind "[" { GoToPreviousTab; SwitchToMode "normal"; }
            bind "]" { GoToNextTab;     SwitchToMode "normal"; }
            bind "1" { GoToTab 1;       SwitchToMode "normal"; }
            bind "2" { GoToTab 2;       SwitchToMode "normal"; }
            bind "3" { GoToTab 3;       SwitchToMode "normal"; }
            bind "4" { GoToTab 4;       SwitchToMode "normal"; }
            bind "5" { GoToTab 5;       SwitchToMode "normal"; }
            bind "6" { GoToTab 6;       SwitchToMode "normal"; }
            bind "7" { GoToTab 7;       SwitchToMode "normal"; }
            bind "8" { GoToTab 8;       SwitchToMode "normal"; }
            bind "9" { GoToTab 9;       SwitchToMode "normal"; }
            bind "0" { GoToTab 10;      SwitchToMode "normal"; }
        }

        search {
            // Control
            bind "Ctrl s" { SwitchToMode "normal"; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "normal"; }

            // Scroll
            bind "j" { ScrollDown; }
            bind "k" { ScrollUp; }
            bind "Ctrl f" "l" { PageScrollDown; }
            bind "Ctrl b" "h" { PageScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }

            // Search
            bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
        }

        entersearch {
            bind "Ctrl c" "Esc" { SwitchToMode "search"; }
            bind "Enter" { SwitchToMode "search"; }
        }
    }

    plugins {
        tab-bar location="zellij:tab-bar"
        status-bar location="zellij:status-bar"
        strider location="zellij:strider"
        compact-bar location="zellij:compact-bar"
        session-manager location="zellij:session-manager"
        welcome-screen location="zellij:session-manager" {
            welcome_screen true
        }
        filepicker location="zellij:strider" {
            cwd "/"
        }
        configuration location="zellij:configuration"
        plugin-manager location="zellij:plugin-manager"
        about location="zellij:about"
    }

    load_plugins {
    }

    ui {
        pane_frames {
            hide_session_name true
        }
    }

    // Choose the theme that is specified in the themes section.
    // Default: default
    //
    theme "tokyo-night"

    // Whether to show tips on startup
    // Default: true
    //
    show_startup_tips false

    default_layout "compact"
  '';
}
