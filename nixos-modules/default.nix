{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
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
    extra-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.bluetooth.enable = true;

  networking = {
    networkmanager.enable = true;
    # Firewall disabled intentionally — machine is behind a NAT router with no port
    # forwarding, and dev work requires frequent port exposure for testing.
    firewall.enable = false;
  };

  services = {
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

    printing.enable = lib.mkDefault false;
    libinput.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    openssh = {
      enable = lib.mkDefault true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
      };
    };

    resolved = {
      enable = lib.mkDefault true;
      settings = {
        Resolve = {
          DNSSEC = "allow-downgrade";
          DNSOverTLS = "opportunistic";
          Domains = [ "~." ];
          FallbackDNS = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
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

  programs = {
    fish.enable = true;
    firefox.enable = lib.mkDefault true;
    nix-ld.enable = true;
    _1password.enable = lib.mkDefault true;
    _1password-gui = lib.mkDefault {
      enable = true;
      polkitPolicyOwners = [ "mohi" ];
    };
  };

  system.stateVersion = "26.05";
}
