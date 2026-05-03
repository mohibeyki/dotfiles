{
  pkgs,
  config,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;

      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];
}
