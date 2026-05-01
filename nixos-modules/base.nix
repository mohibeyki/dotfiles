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
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
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
