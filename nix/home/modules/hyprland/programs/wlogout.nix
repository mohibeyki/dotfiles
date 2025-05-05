{ ... }:
{
  home.file = {
    ".config/wlogout/icons" = {
      source = ../icons;
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "lock";
        "action" = "loginctl lock-session";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "logout";
        "action" = "loginctl terminate-user $USER";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "hibernate";
        "action" = "systemctl hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }
      {
        "label" = "shutdown";
        "action" = "systemctl poweroff";
        "text" = "Power Off";
        "keybind" = "s";
      }
      {
        "label" = "suspend";
        "action" = "systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
      {
        "label" = "reboot";
        "action" = "systemctl reboot";
        "text" = "Restart";
        "keybind" = "r";
      }
    ];

    style = ''
      @define-color bar-bg rgba(0, 0, 0, 0);

      @define-color main-color #7aa2f7;
      @define-color main-bg #24283b;

      @define-color tool-bg #414868;
      @define-color tool-color #b4f9f8;
      @define-color tool-border #565f89;

      @define-color wb-color #7dcfff;

      @define-color wb-act-bg #bb9af7;
      @define-color wb-act-color #b4f9f8;

      @define-color wb-hvr-bg #7aa2f7;
      @define-color wb-hvr-color #cfc9c2;

      * {
          background-image: none;
          font-size: 40px;
      }

      window {
          background-color: rgba(0,0,0,0.5);
      }

      button {
          color: black;
          background-color: @main-color;
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
          background-color: @wb-act-bg;
          background-size: 30%;
      }

      button:hover {
          background-color: @wb-hvr-bg;
          background-size: 40%;
          border-radius: 24px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
      }

      button:hover#lock {
          border-radius: 24px;
          margin : 108px 0px 108px 216px;
      }

      button:hover#logout {
          border-radius: 24px;
          margin : 108px 0px 108px 0px;
      }

      button:hover#suspend {
          border-radius: 24px;
          margin : 108px 0px 108px 0px;
      }

      button:hover#shutdown {
          border-radius: 24px;
          margin : 108px 0px 108px 0px;
      }

      button:hover#hibernate {
          border-radius: 24px;
          margin : 108px 0px 108px 0px;
      }

      button:hover#reboot {
          border-radius: 24px;
          margin : 108px 216px 108px 0px;
      }

      #lock {
          background-image: image(url("$HOME/.config/wlogout/icons/lock_dark.png"), url("/usr/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
          border-radius: 40px 0px 0px 40px;
          margin : 216px 0px 216px 216px;
      }

      #logout {
          background-image: image(url("$HOME/.config/wlogout/icons/logout_dark.png"), url("/usr/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
          border-radius: 0px 0px 0px 0px;
          margin : 216px 0px 216px 0px;
      }

      #suspend {
          background-image: image(url("$HOME/.config/wlogout/icons/suspend_dark.png"), url("/usr/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
          border-radius: 0px 0px 0px 0px;
          margin : 216px 0px 216px 0px;
      }

      #shutdown {
          background-image: image(url("$HOME/.config/wlogout/icons/shutdown_dark.png"), url("/usr/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
          border-radius: 0px 0px 0px 0px;
          margin : 216px 0px 216px 0px;
      }

      #hibernate {
          background-image: image(url("$HOME/.config/wlogout/icons/hibernate_dark.png"), url("/usr/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
          border-radius: 0px 0px 0px 0px;
          margin : 216px 0px 216px 0px;
      }

      #reboot {
          background-image: image(url("$HOME/.config/wlogout/icons/reboot_dark.png"), url("/usr/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
          border-radius: 0px 40px 40px 0px;
          margin : 216px 216px 216px 0px;
      }
    '';
  };
}
