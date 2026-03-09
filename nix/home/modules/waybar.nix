{ hostConfig, ... }:
{
  programs.waybar = {
    enable = true;

    settings = [
      {
        output = hostConfig.primaryMonitor;
        layer = "top";
        height = 54;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "group/tray-expander"
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "battery"
          "custom/weather"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "󰧞";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󰺕";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
          };
        };

        "custom/weather" = {
          exec = "bash ~/.config/scripts/waybar-weather.sh";
          on-click = "mousam";
          interval = 1200;
          tooltip = false;
          format = "{}";
        };

        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "ghostty -e btop";
        };

        clock = {
          format = "{:%a, %b %d %I:%M %p}";
          format-alt = "{:L%d %B W%V %Y}";
          tooltip = false;
        };

        network = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰈀";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          spacing = 1;
        };

        battery = {
          format = "{capacity}% {icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-icons = {
            charging = [
              "󰢟"
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueberry";
        };

        pulseaudio = {
          format = "{icon}";
          on-click = "ghostty --class=com.github.tsowell.wiremix -e wiremix";
          on-click-right = "pamixer -t";
          tooltip-format = "Playing at {volume}%";
          scroll-step = 5;
          format-muted = "󰝟";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = [
            "custom/expand-icon"
            "tray"
          ];
        };

        "custom/expand-icon" = {
          format = "󰛁";
          tooltip = false;
        };

        tray = {
          icon-size = 14;
          spacing = 14;
        };

        "custom/power" = {
          format = " 󰐥 ";
          tooltip = false;
          on-click = "wlogout -b 6 --protocol layer-shell";
        };
      }
    ];

    style = ''
      @define-color foreground #cdd6f4;
      @define-color background #1a1b26;

      * {
          background-color: transparent;
          color: @foreground;
          border: none;
          border-radius: 0;
          min-height: 0;
          font-size: 16px;
          font-family: JetBrainsMono Nerd Font;
          font-weight: 300;
      }

      window#waybar {
          padding: 0;
          margin: 0;
          border: 0;
      }

      .modules-left,
      .modules-center,
      .modules-right {
          background-color: @background;
          padding: 8px 8px;
          border-radius: 8px;
          margin: 8px 0 0 0;
      }

      .modules-left {
          margin-left: 8px;
      }

      .modules-right {
          margin-right: 8px;
      }

      #workspaces button {
          all: initial;
          padding: 0 8px;
          margin: 0 2px;
          min-width: 12px;
      }

      #workspaces button.empty {
          opacity: 0.5;
      }

      .module {
          padding: 4px 4px;
          margin: 0 4px;
          min-width: 12px;
      }

      #clock {
          padding: 4px 8px;
          margin: 0;
      }

      #tray {
          padding: 0;
      }

      #custom-expand-icon {
          padding: 0 8px;
      }

      tooltip {
          padding: 2px;
      }

      .hidden {
          opacity: 0;
      }
    '';
  };

  # Copy the waybar scripts to the config directory
  home.file.".config/scripts/waybar-weather.sh" = {
    executable = true;
    text = ''
      #!/bin/sh

      UNITS="imperial"
      SYMBOL="°F"; [ "$UNITS" = "metric" ] && SYMBOL="°C"
      API_URL="https://api.open-meteo.com/v1/forecast"

      # get loc
      loc=$(curl -sf "https://free.freeipapi.com/api/json")
      lat=$(echo "$loc" | jq -r '.latitude')
      lon=$(echo "$loc" | jq -r '.longitude')

      weather=$(curl -sf "$API_URL?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code,is_day&temperature_unit=$( [ "$UNITS" = "metric" ] && echo "celsius" || echo "fahrenheit" )&timezone=auto")

      # display
      if [ -n "$weather" ] && echo "$weather" | jq -e '.current' >/dev/null 2>&1; then
          temp=$(echo "$weather" | jq '.current.temperature_2m' | cut -d. -f1)
          code=$(echo "$weather" | jq '.current.weather_code')
          is_day=$(echo "$weather" | jq '.current.is_day')

          case $code in
              0)
                  if [ "$is_day" -eq 1 ]; then
                      icon="☀️"
                  else
                      icon="🌙"
                  fi
                  ;;
              1|2|3) icon="⛅" ;;
              45|48) icon="🌫️" ;;
              51|53|55|61|63|65|80|81|82) icon="🌧️" ;;
              56|57|66|67) icon="🌦️" ;;
              71|73|75|77|85|86) icon="❄️" ;;
              95|96|99) icon="⛈️" ;;
              *) icon="🌈" ;;
          esac

          echo "$temp$SYMBOL $icon"
      else
          echo "Weather Unavailable"
      fi
    '';
  };

  home.file.".config/scripts/waybar-swaync.sh" = {
    executable = true;
    text = ''
      #!/bin/sh

      ICON_NORMAL=""
      ICON_SILENT=""
      ICON_WIFI=""
      ICON_BT=""
      ICON_NOINT="󰅛"

      if ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
          NET_ICON="$ICON_WIFI"
      else
          NET_ICON="$ICON_NOINT"
      fi

      STATUS=$(swaync-client -D 2>/dev/null)

      if [[ "$STATUS" == "true" ]]; then
          echo " $ICON_SILENT   $NET_ICON   $ICON_BT"
      elif [[ "$STATUS" == "false" ]]; then
          echo " $ICON_NORMAL   $NET_ICON   $ICON_BT"
      else
          echo " $ICON_NORMAL   $NET_ICON   $ICON_BT"
      fi
    '';
  };
}
