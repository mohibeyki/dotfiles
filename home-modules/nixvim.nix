{
  inputs,
  pkgs,
  ...
}:
let
  nixvim = inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "nixvim" ''
        exec ${nixvim}/bin/nvim "$@"
      '')
    ];

    sessionVariables.EDITOR = "nvim";
  };
}
