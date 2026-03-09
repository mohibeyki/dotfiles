{ ... }@inputs:
let
  homeManagerCfg = userPackages: hostConfig: extraImports: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = userPackages;

      extraSpecialArgs = {
        inherit inputs hostConfig;
      };

      users.mohi.imports = [
        ./home
      ]
      ++ extraImports;

      backupFileExtension = "bak";
    };
  };
in
{
  mkDarwin = machineHostname: hostConfig: extraModules: extraHmModules: {
    darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./modules/darwin.nix
        ./modules/common.nix
        ./hosts/darwin/${machineHostname}
        inputs.home-manager.darwinModules.home-manager
        (inputs.nixpkgs.lib.attrsets.recursiveUpdate (homeManagerCfg true hostConfig extraHmModules) {
          home-manager.users.mohi.home.homeDirectory = inputs.nixpkgs.lib.mkForce "/Users/mohi";
        })
      ]
      ++ extraModules;
    };
  };

  mkNixos = machineHostname: nixpkgsVersion: hostConfig: extraModules: extraHmModules: {
    nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./modules/nixos.nix
        ./modules/common.nix
        ./hosts/nixos/${machineHostname}
        inputs.home-manager.nixosModules.home-manager
        (homeManagerCfg false hostConfig extraHmModules)
      ]
      ++ extraModules;
    };
  };

  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
