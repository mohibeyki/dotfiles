{ inputs, pkgs, ... }:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = true;
    cli.enable = true;
  };

  # Symlink caelestia dotfiles configs
  xdg.configFile = {
    "hypr/hyprland" = {
      source = "${inputs.caelestia}/hypr/hyprland";
      recursive = true;
    };
    "hypr/scheme" = {
      source = "${inputs.caelestia}/hypr/scheme";
      recursive = true;
    };
    "hypr/scripts" = {
      source = "${inputs.caelestia}/hypr/scripts";
      recursive = true;
    };
    "hypr/hyprland.conf".source = "${inputs.caelestia}/hypr/hyprland.conf";
    "hypr/variables.conf".source = "${inputs.caelestia}/hypr/variables.conf";
    "foot".source = "${inputs.caelestia}/foot";
    "btop".source = "${inputs.caelestia}/btop";
    "fastfetch".source = "${inputs.caelestia}/fastfetch";
    "starship.toml".source = "${inputs.caelestia}/starship.toml";
  };

  # Caelestia runtime dependencies
  home.packages = with pkgs; [
    brightnessctl
    cliphist
    eza
    fastfetch
    foot
    fuzzel
    grim
    hyprpicker
    inotify-tools
    libnotify
    papirus-icon-theme
    slurp
    starship
    swappy
    trash-cli
    wl-clipboard
    zoxide
  ];
}
