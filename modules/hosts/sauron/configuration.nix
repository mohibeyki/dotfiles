{ self, ... }:
let
  hostConfig = import ./host-config.nix;
in
{
  flake.nixosModules.configuration-sauron = {
    imports = [
      self.nixosModules.hardware-sauron
      self.nixosModules.nixos
      self.nixosModules.nvidia

      self.nixosModules.containers
      self.nixosModules.desktop
      self.nixosModules.dev
      self.nixosModules.secureboot
      self.nixosModules.shared
      self.nixosModules.steam

      self.nixosModules.home-sauron
    ];

    _module.args.hostConfig = hostConfig;
  };
}
