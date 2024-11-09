{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.mkalias
  ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "cowsay"
    ];
    casks = [
      "iina"
      "raycast"
      "aerospace"
    ];
    taps = [ ];
    masApps = {
      "1password" = 1333542190;
      "telegram" = 747648890;
      "whatsapp" = 310633997;
      "unar" = 425424353;
    };
  };

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
}
