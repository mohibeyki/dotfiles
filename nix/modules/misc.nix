{ pkgs, inputs, ... }:
{
  nix.settings = {
    substituters = [ "https://wezterm.cachix.org" ];
    trusted-public-keys = [ "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0=" ];
  };

  environment.systemPackages = [
    inputs.wezterm.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];
}
