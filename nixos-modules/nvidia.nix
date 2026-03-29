{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    (btop.override { cudaSupport = true; })
  ];
}
