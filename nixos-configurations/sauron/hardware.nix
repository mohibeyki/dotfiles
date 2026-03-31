{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "thunderbolt"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [ "zswap.enabled=1" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/71445f9f-781a-44e2-89b0-7be62a870c34";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd:3"
        "noatime"
        "space_cache=v2"
        "discard=async"
        "ssd"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7DC1-9182";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/7a8912b4-a782-4526-aba7-f46617496d7e";
      fsType = "btrfs";
      options = [
        "compress=zstd:3"
        "noatime"
        "space_cache=v2"
        "discard=async"
        "ssd"
      ];
    };

    "/mnt/games" = {
      device = "/dev/disk/by-uuid/c10b9414-a469-411a-817f-50617a41af28";
      fsType = "btrfs";
      options = [
        "compress=zstd:3"
        "noatime"
        "space_cache=v2"
        "discard=async"
        "ssd"
      ];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25; # 16GB
    algorithm = "zstd";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
