{
  pkgs,
  config,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;

      # Off until a swap partition larger than VRAM exists. zram (~16GB) cannot
      # hold a 24GB VRAM dump; PreserveVideoMemoryAllocations then hangs resume
      # and sometimes the following boot.
      powerManagement.enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];
}
