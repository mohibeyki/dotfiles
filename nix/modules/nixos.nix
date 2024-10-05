{ pkgs, inputs, ... }:
let
  hyprlnd-pkgs-unstable =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  nix.settings = {
    substituters = [ "https://wezterm.cachix.org" ];
    trusted-public-keys = [ "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0=" ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    graphics = {
      package = hyprlnd-pkgs-unstable.mesa.drivers;
      package32 = hyprlnd-pkgs-unstable.pkgsi686Linux.mesa.drivers;
      enable32Bit = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    bind
    brave
    discord
    gparted
    hyprpaper
    lxqt.lxqt-policykit
    mako
    niv
    sbctl
    vimix-cursors
    waybar
    wofi
    zed-editor

    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];
}
