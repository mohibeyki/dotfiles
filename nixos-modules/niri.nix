{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    cliphist
    grim
    slurp
    swappy
    pavucontrol
    playerctl
    wl-clipboard
    xwayland-satellite
  ];

  programs.niri.enable = true;
}
