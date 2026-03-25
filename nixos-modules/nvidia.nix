{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    (btop.override { cudaSupport = true; })
  ];

  programs.gamemode.enable = true;
}
