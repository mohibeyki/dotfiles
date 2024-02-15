{
  description = "Mohi's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages =
        [ 
          pkgs.btop
          pkgs.dockerfile-language-server-nodejs
          pkgs.fd
          pkgs.fish
          pkgs.git
          pkgs.gnused
          pkgs.go
          pkgs.gopls
          pkgs.helix
          pkgs.lldb
          pkgs.lsix
          pkgs.macchina
          pkgs.mc
          pkgs.neovim
          pkgs.nil
          pkgs.nodejs
          pkgs.python3
          pkgs.ranger
          pkgs.ripgrep
          pkgs.rustup
          pkgs.taplo
          pkgs.tmux
          pkgs.wget
          pkgs.zellij
          pkgs.zoxide
          pkgs.zsh
       ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Legolas" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Legolas".pkgs;
  };
}
