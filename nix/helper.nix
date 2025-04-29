inputs:
let
  homeManagerCfg = userPackages: extraImports: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = userPackages;

      extraSpecialArgs = {
        inherit inputs;
      };

      users.mohi.imports = [
        ./home
      ] ++ extraImports;

      backupFileExtension = "bak";
    };
  };
in
{
  mkDarwin = machineHostname: nixpkgsVersion: extraHmModules: extraModules: {
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
        (inputs.nixpkgs.lib.attrsets.recursiveUpdate (homeManagerCfg true extraHmModules) {
          home-manager.users.mohi.home.homeDirectory = inputs.nixpkgs.lib.mkForce "/Users/mohi";
        })
      ] ++ extraModules;
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
        ./hosts/nixos/${machineHostname}
        (homeManagerCfg false [ ])
      ] ++ extraModules;
    };
  };

  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
