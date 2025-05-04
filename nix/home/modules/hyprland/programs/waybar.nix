{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        # height = 30;
        # width = 1280;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "custom/media"
          "tray"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
          "custom/power"
        ];
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "tray" = {
          spacing = 10;
        };
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };
        "memory" = {
          format = "{}% ";
        };
        "temperature" = {
          critical-threshold = 80;
          thermal-zone = 5;
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        # "power-profiles-daemon": {
        #   "format": "{icon}",
        #   "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
        #   "tooltip": true,
        #   "format-icons": {
        #     "default": "",
        #     "performance": "",
        #     "balanced": "",
        #     "power-saver": ""
        #   }
        # },
        # "network": {
        #   // "interface": "wlp2*", // (Optional) To force the use of this interface
        #   "format": "{ifname}",
        #   "format-wifi": "{essid} ({signalStrength}%) ",
        #   "format-ethernet": "{ipaddr}/{cidr} ",
        #   "tooltip-format": "{ifname} via {gwaddr} ",
        #   "format-linked": "{ifname} (No IP) ",
        #   "format-disconnected": "Disconnected ⚠",
        #   "format-alt": "{ifname}: {ipaddr}/{cidr}",
        #   "max-length": 50
        # },
        "pulseaudio" = {
          on-click = "pwvucontrol";
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };
        "custom/power" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "wlogout --protocol layer-shell";
        };
      }
    ];
    style = ''
          * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: "BerkeleyMono Nerd Font";
            font-size: 13px;
            min-height: 0;
          }

        window#waybar {
      background: transparent;
                  /*    background-color: rgba(43, 48, 59, 0.5); */
                  /*    border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
      color: #ffffff;
             transition-property: background-color;
             transition-duration: .5s;
        }

        window#waybar.hidden {
      opacity: 0.2;
        }

      #waybar.empty #window {
        background-color: transparent;
      }

      #workspaces {
      }

      #window {
      margin: 2;
              padding-left: 8;
              padding-right: 8;
              background-color: rgba(0,0,0,0.3);
              font-size:14px;
              font-weight: bold;
      }

      button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
        /* Avoid rounded borders under each button name */
      border: none;
              border-radius: 0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
      background: inherit;
                  border-top: 2px solid #c9545d;
             }

      #workspaces button {
      padding: 0 4px;
               /*    background-color: rgba(0,0,0,0.3); */
      }

      #workspaces button:hover {
      }

      #workspaces button.focused {
        /*    box-shadow: inset 0 -2px #c9545d; */
        background-color: rgba(0,0,0,0.3);
      color:#c9545d;
            border-top: 2px solid #c9545d;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #mode {
        background-color: #64727D;
        border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #power-profiles-daemon,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
      margin: 3px;
              padding-left: 4px;
              padding-right: 4px;
              background-color: rgba(0,0,0,0.3);
      color: #ffffff;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      #clock {
        font-size:14px;
        font-weight: bold;
      }

      #battery icon {
      color: red;
      }

      #battery.charging, #battery.plugged {
      color: #ffffff;
             background-color: #26A65B;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
      color: #000000;
        }
      }

      #battery.warning:not(.charging) {
        background-color: #f53c3c;
      color: #ffffff;
             animation-name: blink;
             animation-duration: 0.5s;
             animation-timing-function: linear;
             animation-iteration-count: infinite;
             animation-direction: alternate;
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
      color: #ffffff;
             animation-name: blink;
             animation-duration: 0.5s;
             animation-timing-function: linear;
             animation-iteration-count: infinite;
             animation-direction: alternate;
      }

      label:focus {
              background-color: #000000;
            }

      #network.disconnected {
        background-color: #f53c3c;
      }

      #temperature.critical {
        background-color: #eb4d4b;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }


    '';
  };
}
