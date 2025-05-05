{ ... }:
{
  imports = [
    ./waybar-theme.nix
  ];

  programs.waybar = {
    enable = true;
    settings = [
      {
        output = "DP-5";
        layer = "top";
        position = "top";
        spacing = 4;
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "custom/media"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "cpu"
          "memory"
          "clock"
          "custom/power"
        ];

        "custom/launcher" = {
          format = "󰀻";
          on-click = "wofi --show drun";
        };

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace r-1";
          on-scroll-down = "hyprctl dispatch workspace r+1";
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
        };

        "hyprland/window" = {
          max-length = 48;
          rewrite = {
            "(.*) - Brave" = "$1";
          };
          separate-outputs = true;
        };

        "tray" = {
          spacing = 16;
        };

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

        "network" = {
          tooltip = false;
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰇧 {ipaddr}";
          family = "ipv4";
        };

        "cpu" = {
          interval = 2;
          format = "󰻠 {load:0.2f}";
          tooltip = false;
          on-click = "flatpak run io.missioncenter.MissionCenter";
        };

        "memory" = {
          interval = 2;
          format = "󰍛 {used:0.2f} GB";
          tooltip = true;
          tooltip-format = "󰍛 {used:0.1f} GB / {total:0.1f} GB";
          on-click = "flatpak run io.missioncenter.MissionCenter";
        };

        "clock" = {
          format = "󰥔 {:%I:%M 󰃭 %a, %b %d %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "custom/power" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "wlogout -b 6 -c 0 -r 0 -P 0 --protocol layer-shell";
        };
      }
    ];
  };
}
