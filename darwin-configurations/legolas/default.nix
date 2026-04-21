{
  inputs,
  overlays,
  ...
}:
let
  keys = import ../../modules/keys.nix;
in
{
  imports = [
    ../../darwin-modules/default.nix
  ];

  networking.hostName = "legolas";
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs overlays;
      hostConfig = {
        gitSigningKey = keys.legolas;
        gitAllowedSigners = builtins.attrValues keys;
      };
    };

    users.mohi = {
      imports = [
        ../../home-configurations/mohi

        ../../home-modules
      ];
    };
  };
}
