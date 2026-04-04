{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bottles
    cartridges
    heroic
    lutris
    mangohud
    protontricks
    protonup-ng
    protonup-qt
  ];
}
