{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = lib.mkDefault 10;
      };

      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "ntfs" ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  nix.gc.dates = "weekly";

  nix.settings = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.bluetooth.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = lib.mkDefault true;
  };

  # Root is a single btrfs mount of subvol=@ (see hardware.nix). There is no
  # separate /home mount. Snapshot the mounted root subvolume (".") into
  # /.snapshots, which is created as its own subvolume on activation.
  system.activationScripts.btrbkSnapshots = {
    deps = [ "specialfs" ];
    text = ''
      if [ ! -e /.snapshots ]; then
        ${pkgs.btrfs-progs}/bin/btrfs subvolume create /.snapshots
      fi
    '';
  };

  services = {
    btrbk.instances.local = {
      onCalendar = "daily";
      settings = {
        snapshot_preserve = "7d 4w";
        snapshot_preserve_min = "3d";

        volume."/" = {
          snapshot_dir = ".snapshots";
          # "." = currently mounted subvolume (@), not a separate / path.
          subvolume."." = { };
        };
      };
    };

    flatpak.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };

    libinput.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    openssh = {
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
      };
    };

    # Advertise sauron.local and resolve other *.local hostnames (mDNS/Bonjour).
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
  };

  users = {
    defaultUserShell = pkgs.fish;

    users.mohi = {
      isNormalUser = true;
      description = "Mohi Beyki";
      shell = pkgs.fish;

      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  # programs.fish.enable is also set in home-modules/fish.nix for HM user config.
  # Both are required: the system-level declaration enables fish as the login shell;
  # the HM declaration configures aliases, plugins, and other user settings.
  programs.fish.enable = true;

  system.stateVersion = "26.05";
}
