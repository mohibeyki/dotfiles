{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # Enabling Lanzaboote forces systemd-boot off. Disk encryption is separate.
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.systemd-boot.enable = lib.mkIf config.boot.lanzaboote.enable (lib.mkForce false);

  environment.systemPackages = [ pkgs.sbctl ];
}
