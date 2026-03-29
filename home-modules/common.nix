{
  hostConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  desktopMode = hostConfig.desktopMode or "gnome";
  bravePasswordStore = if desktopMode == "plasma" then "kwallet6" else "gnome-libsecret";
  brave = pkgs.writeShellScriptBin "brave" ''
    exec ${lib.getExe pkgs.brave} --password-store=${bravePasswordStore} "$@"
  '';
in
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = [
      brave
      inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  programs = {
    home-manager.enable = true;

    man = {
      enable = true;
      generateCaches = false;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
