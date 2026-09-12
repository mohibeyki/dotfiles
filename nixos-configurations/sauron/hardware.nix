{
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
  };

  # On reinstall, split btrfs: @ (/), @nix (/nix), @home (/home), @log (/var/log).
  # Snapshot @ and @home only. These UUIDs are from the previous disk layout.
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
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25; # ~16GB on 64GB RAM
    algorithm = "zstd";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
}
