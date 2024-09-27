{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    brave
    discord
    gparted
    vimix-cursors
    wezterm
  ];
}

