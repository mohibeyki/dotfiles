{ ... }:
{
  programs.waybar = {
    style = ''
      @define-color bg #0f0f17;
      @define-color fg #a6accd;
      @define-color bg-light #181827;
      @define-color bg-lighter #292943;

      @define-color black #181926;
      @define-color red #f07178;
      @define-color green #c3e88d;
      @define-color yellow #ffcb6b;
      @define-color blue #82aaff;
      @define-color magenta #c792ea;
      @define-color cyan #89ddff;
      @define-color white #eeffff;

      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 16px;
        min-width: 0;
        min-height: 0;
        transition: none;
      }

      window#waybar {
        background-color: transparent;
      }

      .modules-left {
        margin: 4px 4px 0;
        padding: 0px;
        background-color: transparent;
        border-radius: 4px;
      }

      .modules-center {
        margin: 4px 4px 0;
        padding: 0px;
        background-color: transparent;
        border-radius: 4px;
      }

      .modules-right {
        margin: 4px 4px 0;
        padding: 0px;
        background-color: transparent;
        border-radius: 4px;
      }

      #custom-launcher,
      #workspaces,
      #window,
      #tray,
      #cpu,
      #memory,
      #pulseaudio,
      #network,
      #clock,
      #custom-power {
        padding: 0px 24px;
        margin: 4px;
        background-color: @bg-light;
        color: @fg;
        min-width: 24px;
        min-height: 24px;
        border-radius: 4px;
      }

      #workspaces {
        padding: 0px;
        margin: 0px 0px;
        border: 0px;
        border-radius: 0px;
        background-color: transparent;
      }

      #workspaces button {
        background-color: @bg;
        color: @blue;
        border-radius: 4px;
        border: 0px;
        padding: 4px 16px 4px 16px;
        margin: 4px 4px;
        min-height: 32px;
      }

      #workspaces button:hover {
        color: @blue;
        background-color: @bg-light;
        border: 0px;
      }

      #workspaces button.active {
        color: @blue;
        background-color: @bg-light;
        border: 0px;
      }

      #custom-launcher {
        color: @magenta;
      }

      #window {
        color: @fg;
      }

      window#waybar.empty #window {
        background-color: transparent;
      }

      window#waybar.empty .modules-center {
        background-color: transparent;
      }

      #custom-pacman {
        color: @blue;
      }

      #cpu {
        color: @red;
      }

      #memory {
        color: @yellow;
      }

      #pulseaudio {
        color: @green;
      }

      #network {
        color: @magenta;
      }

      #clock {
        color: @blue;
      }

      #custom-power {
        color: @red;
      }
    '';
  };
}
