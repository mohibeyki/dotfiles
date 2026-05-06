{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  programs = {
    steam = {
      enable = true;
      platformOptimizations.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamescope.enable = true;
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          softrealtime = "auto";
        };
        cpu = {
          park_cores = "no";
          pin_cores = "no";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          nv_powermizer_mode = 1;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    protontricks
    protonup-rs
    winetricks
  ];
}
