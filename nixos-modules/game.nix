{ pkgs, ... }:
{
  programs = {
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protontricks
  ];
}
