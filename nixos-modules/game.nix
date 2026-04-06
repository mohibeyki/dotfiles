{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
    };

    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bottles
    mangohud
    protontricks
  ];
}
