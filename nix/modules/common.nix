{
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest; # pkgs.nix;

    settings = {
      trusted-users = [
        "root"
        "mohi"
      ];

      accept-flake-config = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bc # calculator
    btop
    cachix
    fastfetch
    fd
    fishPlugins.tide
    fzf
    git
    gnused
    jq # json processor
    lazygit
    libiconv
    mc
    ripgrep
    tmux
    unzip
    wget
    xz
    zellij
    zip
    zoxide
  ];
}
