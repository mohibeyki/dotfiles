{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  boot.kernelModules = [ "ntsync" ];

  programs = {
    steam = {
      enable = true;
      extest.enable = true;
      platformOptimizations.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = with pkgs; [
        hidapi
      ];
    };

    gamescope.enable = true;
  };

  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    protontricks
    protonup-rs
    winetricks
  ];
}
