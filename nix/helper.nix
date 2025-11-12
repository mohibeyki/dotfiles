{ ... }@inputs:
{
  mkDarwin = machineHostname: nixpkgsVersion: extraModules: {
    darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./modules/darwin.nix
        ./modules/common.nix
        ./hosts/darwin/${machineHostname}
      ]
      ++ extraModules;
    };
  };

  mkNixos = machineHostname: nixpkgsVersion: extraModules: {
    nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./modules/nixos.nix
        ./modules/common.nix
        ./programs/ghostty.nix
        ./hosts/nixos/${machineHostname}
      ]
      ++ extraModules;
    };
  };

  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
