{ self, ... }:
{
  flake.darwinModules.configuration-legolas = {
    imports = [
      self.nixosModules.dev
      self.nixosModules.shared

      self.nixosModules.home-legolas
    ];

    security.pam.services.sudo_local.touchIdAuth = true;

    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
