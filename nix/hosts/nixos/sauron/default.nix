{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "sauron";

    # Enable networking
    networkmanager.enable = true;
    # Disable IPv6.
    # enableIPv6 = false;

    # Disable firewall.
    firewall.enable = false;
  };

  services.resolved.settings.Resolve.DNS = [ "192.168.1.10#dns.home.biook.me" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
