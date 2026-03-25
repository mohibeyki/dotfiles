{ ... }:
{
  flake.nixosModules.nvidia =
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
            enable = true;
            finegrained = false;
          };
        };
      };

      boot.kernelParams = [
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      ];

      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
        (btop.override { cudaSupport = true; })
      ];

      programs.gamemode.enable = true;
    };
}
