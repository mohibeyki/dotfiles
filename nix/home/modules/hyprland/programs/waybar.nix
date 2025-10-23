{ ... }:
{
  imports = [
    ./waybar-theme.nix
  ];

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        height = 30;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "memory"
          "custom/gpt"
          "custom/weather"
          "battery"
          "battery#bat2"
          "sway/mode"
          "sway/scratchpad"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "custom/swaync"
          "sway/language"
          "backlight"
          "idle_inhibitor"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          persistent-workspaces = {
            "*" = [
              1
              2
              3
            ];
          };
        };

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "custom/gpt" = {
          format = " ";
          tooltip = false;
          on-click = "firefox -P ai --new-window https://chatgpt.com/";
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [
            ""
            ""
          ];
          tooltip = true;
          "tooltip-format" = "{app}: {title}";
        };

        "custom/weather" = {
          exec = "bash ~/.config/scripts/waybar-weather.sh";
          on-click = "mousam";
          interval = 3;
          tooltip = false;
          format = "{}";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        tray = {
          spacing = 10;
        };

        clock = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };

        memory = {
          format = "{}% ";
        };

        "custom/swaync" = {
          exec = "bash ~/.config/scripts/waybar-swaync.sh";
          interval = 1;
          tooltip = false;
          format = "{} ";
          on-click = "swaync-client -t";
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          interval = 3;
          "format-icons" = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        "battery#bat2" = {
          bat = "BAT2";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon} ";
          "format-bluetooth-muted" = "  {icon} ";
          "format-muted" = " ";
          "format-source" = " {volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            headphone = "";
            "hands-free" = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              " "
            ];
          };
          on-click = "pavucontrol";
        };

        "custom/power" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "wlogout -b 4";
        };

        "sway/language" = { };
      }
    ];
  };
}
