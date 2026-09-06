{ ... }:
{
  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = false;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    # Keep DMS's appearance separate from the declarative Rosé Pine desktop theme.
    settings = {
      theme = "dark";
      dynamicTheming = false;
    };
  };
}
