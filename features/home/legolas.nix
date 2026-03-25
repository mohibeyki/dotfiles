{ self, inputs, ... }:
{
  flake.nixosModules.home-legolas = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = {
        inherit inputs;
      };

      users.mohi = {
        imports = [
          self.homeModules.common
        ];

        home.homeDirectory = "/Users/mohi";
      };
    };
  };
}
