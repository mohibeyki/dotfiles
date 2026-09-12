{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

    loader = {
      timeout = 8;

      systemd-boot = {
        enable = true;
        configurationLimit = lib.mkDefault 10;
      };

      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "ntfs" ];
  };

  nix.gc.dates = "weekly";

  nix.settings = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
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
