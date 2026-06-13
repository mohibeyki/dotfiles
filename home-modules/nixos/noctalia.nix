{
  config,
  lib,
  ...
}:
let
  inherit (config.dotfiles) host;
in
lib.mkIf (host.shell == "noctalia") {
  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    settings = ../noctalia.toml;
  };

  home.file = {
    "Pictures/face.png".source = ../../assets/face.png;
    "Pictures/Wallpapers/wallpaper.jpg".source = ../../assets/wallpaper.jpg;
  };
}
