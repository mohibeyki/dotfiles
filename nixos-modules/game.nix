{
  pkgs,
  ...
}:
{
  programs = {
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    mangohud
    protontricks
    steamtinkerlaunch
  ];
}
