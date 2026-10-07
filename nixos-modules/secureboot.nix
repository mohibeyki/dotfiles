{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # Keep the old Secure Boot setup available, but do not switch bootloaders
  # until the encrypted reinstall. Enabling this forces systemd-boot off.
  boot.lanzaboote = {
    enable = false;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.systemd-boot.enable = lib.mkIf config.boot.lanzaboote.enable (lib.mkForce false);
}
