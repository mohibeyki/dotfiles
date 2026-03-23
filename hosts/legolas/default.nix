{ ... }:
{
  hostConfig = { };

  darwinModule = {
    environment.systemPackages = [ ];

    security.pam.services.sudo_local.touchIdAuth = true;

    system.stateVersion = 6;

    nixpkgs.hostPlatform = "aarch64-darwin";
  };

  modulesExtra = [ ];

  homeModulesExtra = [ ];
}
