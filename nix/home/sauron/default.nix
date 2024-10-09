{ ... }:
let
  configPath = ../../../config;
in
{
  imports = [
    ../common.nix
  ];

  home = {
    file = {
      ".config/dunst".source = configPath + /dunst;
      ".config/hypr".source = configPath + /hypr;
      ".config/scripts".source = configPath + /scripts;
      ".config/waybar".source = configPath + /waybar;
      ".config/wofi".source = configPath + /wofi;
      ".config/brave-flags.conf".source = configPath + /chromium-flags.conf;
      ".config/code-flags.conf".source = configPath + /code-flags.conf;
    };
  };
}
