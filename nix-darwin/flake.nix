{
  description = "Mohi's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nix-darwin, nixpkgs, ... }@inputs:
    let
      configuration = { pkgs, ... }: {
        nixpkgs.overlays = overlays;
        environment.systemPackages =
          [
            pkgs.btop
            pkgs.fd
            pkgs.fish
            pkgs.git
            pkgs.gnused
            pkgs.go
            pkgs.gopls
            pkgs.jq
            pkgs.kubectl
            pkgs.lazygit
            pkgs.lldb
            pkgs.lua-language-server
            pkgs.mc
            pkgs.neofetch
            pkgs.neovim
            pkgs.nodejs
            pkgs.python3
            pkgs.ripgrep
            pkgs.rustup
            pkgs.selene
            pkgs.taplo
            pkgs.tmux
            pkgs.wget
            pkgs.yarn
            pkgs.zellij
            pkgs.zoxide
            pkgs.zsh
          ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        nix.package = pkgs.nixVersions.latest; # pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";
        nixpkgs.config.allowUnfree = true;

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;
        programs.fish.enable = true;
        programs.fish.shellInit = ''
        for p in /run/current-system/sw/bin
          if not contains $p $fish_user_paths
            set -g fish_user_paths $p $fish_user_paths
          end
        end
        '';

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
      {
      darwinConfigurations."Legolas" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Legolas".pkgs;
    };
}
