{ pkgs, fenix, ... }:
{
  nixpkgs.overlays = [ fenix.overlays.default ];
  environment.systemPackages = with pkgs; [
    fenix.packages.${system}.minimal.toolchain
  ];
}
