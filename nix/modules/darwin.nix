{ pkgs, config, ... }:
{
  ids.gids.nixbld = 350;

  environment.systemPackages = [
    pkgs.mkalias
  ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "iina"
      "raycast"
      "aerospace"
    ];
    taps = [ ];
    masApps = {
      "1Password" = 1333542190;
      "Telegram" = 747648890;
      "WhatsApp Messenger" = 310633997;
      "The Unarchiver" = 425424353;
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
