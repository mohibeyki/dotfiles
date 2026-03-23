inputs:
let
  inherit (inputs.nixpkgs) lib;

  mkHomeManagerModule = userPackages: hostConfig: extraImports: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = userPackages;

      extraSpecialArgs = {
        inherit inputs hostConfig;
      };

      users.mohi.imports = [
        ../home
      ]
      ++ extraImports;

      backupFileExtension = "bak";
    };
  };
in
{
  mkDarwinHost = hostModule: hostConfig: extraModules: extraHmModules: {
    darwinConfiguration = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ../modules/darwin.nix
        ../modules/common.nix
        hostModule
        inputs.home-manager.darwinModules.home-manager
        (lib.recursiveUpdate (mkHomeManagerModule true hostConfig extraHmModules) {
          home-manager.users.mohi.home.homeDirectory = lib.mkForce "/Users/mohi";
        })
      ]
      ++ extraModules;
    };
  };

  mkNixosHost = hostModule: nixpkgs: hostConfig: extraModules: extraHmModules: {
    nixosConfiguration = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ../modules/nixos.nix
        ../modules/common.nix
        hostModule
        inputs.home-manager.nixosModules.home-manager
        (mkHomeManagerModule false hostConfig extraHmModules)
      ]
      ++ extraModules;
    };
  };
}
