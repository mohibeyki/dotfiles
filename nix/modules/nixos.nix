{ pkgs, ... }:
{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services = {

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    xserver = {
      enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager = {
      gnome.enable = true;
    };

    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      dnsovertls = "true";
    };

    # Disable CUPS
    printing.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs = {
    firefox.enable = true;
  };

  users.defaultUserShell = pkgs.fish;
  users.users.mohi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    description = "Mohi Beyki";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bibata-cursors
    bind
    blueberry
    brave
    discord
    geekbench
    gnome-tweaks
    gparted
    killall
    lshw
    mako
    mousam
    niv
    nwg-look
    pamixer
    papirus-icon-theme
    pavucontrol
    pipewire
    sbctl
    spotify
    uwsm
    wiremix
    wireplumber
    zed-editor
  ];
}
