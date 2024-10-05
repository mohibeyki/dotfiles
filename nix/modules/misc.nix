{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.wezterm.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];
}
