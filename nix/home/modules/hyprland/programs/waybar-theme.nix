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
          all: unset;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 16px;
      }

      window#waybar {
      }

      .modules-left,
      .modules-center,
      .modules-right {
          margin-top: 4px;
          background-color: transparent;
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
          padding: 4px 24px;
          margin: 0 4px;
          background-color: alpha(@bg-lighter, 0.1);
          color: @fg;
          border-radius: 4px;
          min-height: 32px;
      }

      #workspaces button {
          margin: 0px 8px;
          color: @fg;
      }

      #workspaces button:hover {
          color: @magenta;
      }

      #workspaces button.active {
          color: @red;
      }

      #custom-launcher {
          color: @fg;
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
          color: @fg;
      }

      #cpu {
          color: @fg;
      }

      #memory {
          color: @fg;
      }

      #pulseaudio {
          color: @fg;
      }

      #network {
          color: @fg;
      }

      #clock {
          color: @fg;
      }

      #custom-power {
          color: @red;
      }
    '';
  };
}
