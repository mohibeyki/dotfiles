{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    brave
    discord
	  vimix-cursors
    wezterm
  ];
}

