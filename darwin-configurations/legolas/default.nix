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

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    inherit overlays;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs overlays;
    };

    users.mohi = {
      imports = [
        ../../home-configurations/mohi

        ../../home-modules
      ];

      dotfiles.host = {
        gitSigningKey = keys.legolas;
        gitAllowedSigners = builtins.attrValues keys;
      };
    };
  };
}
