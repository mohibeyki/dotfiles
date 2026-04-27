{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    packages = [
      inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    sessionVariables.EDITOR = "nvim";
  };
}
