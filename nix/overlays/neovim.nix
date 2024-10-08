{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    neovim
  ]
}
