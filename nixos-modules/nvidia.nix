{
  pkgs,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware = {
    nvidia = {
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
