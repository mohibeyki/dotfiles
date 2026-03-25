{ self, inputs, ... }:
{
  flake.nixosConfigurations.sauron = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.configuration-sauron
    ];
  };
}
