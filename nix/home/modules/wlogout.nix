{ pkgs, ... }:
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Power Off";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Restart";
        keybind = "r";
      }
    ];

    style = ''
      @define-color bg-color rgba(24, 24, 39, 0.5);
      @define-color bg-color-focus rgba(24, 24, 39, 0.3);
      @define-color bg-color-hover rgba(24, 24, 39, 0.1);

      @define-color black #181926;
      @define-color red #f07178;
      @define-color green #c3e88d;
      @define-color yellow #ffcb6b;
      @define-color blue #82aaff;
      @define-color magenta #c792ea;
      @define-color cyan #89ddff;
      @define-color white #eeffff;

      * {
          background-image: none;
          font-size: 40px;
      }

      window {
          background-color: rgba(0, 0, 0, 0.02);
      }

      button {
          color: @white;
          background-color: @bg-color;
          outline-style: none;
          border: none;
          border-width: 0px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          border-radius: 0px;
          box-shadow: none;
          text-shadow: none;
          animation: gradient_f 20s ease-in infinite;
      }

      button:focus {
          background-color: @bg-color-focus;
          background-size: 30%;
          color: @white;
      }

      button:hover {
          background-color: @bg-color-hover;
          background-size: 40%;
          color: @white;
          border-radius: 20px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(0.55, 0, 0.28, 1.682);
      }

      button:hover#lock {
          border-radius: 20px;
          margin: 108px 0px 108px 216px;
      }

      button:hover#logout {
          border-radius: 20px;
          margin: 108px 0px 108px 0px;
      }

      button:hover#suspend {
          border-radius: 20px;
          margin: 108px 0px 108px 0px;
      }

      button:hover#shutdown {
          border-radius: 20px;
          margin: 108px 0px 108px 0px;
      }

      button:hover#hibernate {
          border-radius: 20px;
          margin: 108px 0px 108px 0px;
      }

      button:hover#reboot {
          border-radius: 20px;
          margin: 108px 216px 108px 0px;
      }

      #lock {
          background-image: image(
              url("/home/mohi/.config/wlogout/icons/lock_light.png")
          );
          border-radius: 32px 0px 0px 32px;
          margin: 216px 0px 216px 216px;
      }

      #logout {
          background-image: image(
              url("/home/mohi/.config/wlogout/icons/logout_light.png")
          );
          border-radius: 0px 0px 0px 0px;
          margin: 216px 0px 216px 0px;
      }

      #suspend {
          background-image: image(
              url("/home/mohi/.config/wlogout/icons/suspend_light.png")
          );
          border-radius: 0px 0px 0px 0px;
          margin: 216px 0px 216px 0px;
      }

      #shutdown {
          background-image: image(
              url("/home/mohi/.config/wlogout/icons/shutdown_light.png")
          );
          border-radius: 0px 0px 0px 0px;
          margin: 216px 0px 216px 0px;
      }

      #hibernate {
          background-image: image(
              url("/home/mohi/.config/wlogout/icons/hibernate_light.png")
          );
          border-radius: 0px 0px 0px 0px;
          margin: 216px 0px 216px 0px;
      }

      #reboot {
          background-image: image(
              url("/home/mohi/.config/wlogout/icons/reboot_light.png")
          );
          border-radius: 0px 32px 32px 0px;
          margin: 216px 216px 216px 0px;
      }
    '';
  };

  # Copy wlogout icons to the config directory
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };
}
