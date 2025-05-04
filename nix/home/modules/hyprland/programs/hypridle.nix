{ ... }:
{
  services.hypridle = {
    enable = true;
    settings = {

      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      # Screenlock
      listener = [
        {
          timeout = 600;
          # HYPRLOCK ONTIMEOUT
          on-timeout = "loginctl lock-session";
        }
        # dpms
        {
          # DPMS TIMEOUT
          timeout = 660;
          # DPMS ONTIMEOUT
          on-timeout = "hyprctl dispatch dpms off";
          # DPMS ONRESUME
          on-resume = "hyprctl dispatch dpms on";
        }
        # Suspend
        {
          # SUSPEND TIMEOUT
          timeout = 1800;
          #SUSPEND ONTIMEOUT
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
