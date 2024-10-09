{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.helix.overlays.default ];
  environment.systemPackages = with pkgs; [
    helix
  ];
}
