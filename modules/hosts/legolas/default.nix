{ self, inputs, ... }:
{
  flake.darwinConfigurations.legolas = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.darwinModules.configuration-legolas
    ];
  };
}
