{ ... }:
{
  flake.nixosModules.nixos =
    { lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

        loader = {
          systemd-boot.enable = lib.mkDefault true;
          efi.canTouchEfiVariables = lib.mkDefault true;
        };

        supportedFilesystems = [ "ntfs" ];
        consoleLogLevel = lib.mkDefault 0;
        initrd.verbose = lib.mkDefault false;

        kernelParams = lib.mkDefault [
          "quiet"
          "loglevel=3"
          "systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
        ];
      };

      time.timeZone = "America/Los_Angeles";
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      security = {
        sudo.wheelNeedsPassword = true;
        polkit.enable = true;
        rtkit.enable = true;
        pam.services.hyprlock = { };
      };

      hardware.bluetooth.enable = true;

      networking = {
        hostName = "sauron";
        networkmanager.enable = true;
        firewall.enable = false;
      };

      services = {
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
        openssh.enable = lib.mkDefault true;

        resolved = {
          enable = true;
          settings = {
            Resolve = {
              DNS = [ "192.168.1.10#dns.home.biook.me" ];
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
            "docker"
          ];
        };
      };

      programs = {
        fish.enable = true;
        firefox.enable = lib.mkDefault true;
        _1password.enable = lib.mkDefault true;
        _1password-gui = lib.mkDefault {
          enable = true;
          polkitPolicyOwners = [ "mohi" ];
        };
      };

      system.stateVersion = "25.05";
    };
}
