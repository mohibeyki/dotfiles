{ ... }@inputs:

let
  mkHosts = import ./mkHosts.nix inputs;
  lib = inputs.nixpkgs.lib;

  discoverHosts =
    hostsDir:
    let
      hostNames = builtins.attrNames (builtins.readDir hostsDir);
    in
    builtins.listToAttrs (
      map (
        hostName:
        let
          hostModule = import (hostsDir + "/${hostName}") { inherit inputs; };
        in
        if hostModule ? nixosModule then
          {
            name = hostName;
            value =
              mkHosts.mkNixosHost hostModule.nixosModule inputs.nixpkgs hostModule.hostConfig
                hostModule.modulesExtra
                hostModule.homeModulesExtra;
          }
        else
          {
            name = hostName;
            value =
              mkHosts.mkDarwinHost hostModule.darwinModule hostModule.hostConfig hostModule.modulesExtra
                hostModule.homeModulesExtra;
          }
      ) hostNames
    );

  partitionByType =
    hosts:
    let
      nixosHosts = lib.filterAttrs (_: v: v ? nixosConfiguration) hosts;
      darwinHosts = lib.filterAttrs (_: v: v ? darwinConfiguration) hosts;
    in
    {
      nixos = lib.mapAttrs (name: v: v.nixosConfiguration) nixosHosts;
      darwin = lib.mapAttrs (name: v: v.darwinConfiguration) darwinHosts;
    };
in
{
  inherit discoverHosts partitionByType;
}
