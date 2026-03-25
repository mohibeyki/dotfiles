{
  inputs,
  overlays ? [ ],
  ...
}:
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
    };

    users.mohi = {
      imports = [
        ../../home-configurations/mohi

        ../../home-modules/common.nix
        ../../home-modules/fish.nix
        ../../home-modules/ghostty.nix
        ../../home-modules/git.nix
        ../../home-modules/helix.nix
        ../../home-modules/tmux.nix
        ../../home-modules/zellij.nix
      ];
    };
  };
}
