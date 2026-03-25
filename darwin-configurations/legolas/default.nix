{ inputs, ... }:
{
  imports = [
    inputs.nix-darwin.darwinModules
    ../../darwin-modules/default.nix
  ];

  networking.hostName = "legolas";
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };

    users.mohi = {
      imports = [
        ../../home-configurations/mohi
        ../../home-modules/common.nix
      ];
    };
  };
}
