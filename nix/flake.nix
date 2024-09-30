{
  description = "Mohi's system flake!";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    nix-darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, ... }:
    let
      configuration = { pkgs, ... }: {
        nixpkgs.overlays = [
          inputs.neovim-nightly-overlay.overlays.default
        ];
        environment.systemPackages = with pkgs;
          [
            bc
            btop
            fd
            git
            gnused
            go
            gofumpt
            golangci-lint
            gopls
            jq
            kubectl
            lazygit
            lua-language-server
            mc
            neofetch
            neovim
            nil
            nodejs
            python3
            ripgrep
            selene
            stylua
            tmux
            nixpkgs-fmt
            tree-sitter
            wget
            yarn
            zoxide
          ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;

        nix = {
          package = pkgs.nixVersions.latest; # pkgs.nix;

          # Necessary for using flakes on this system.
          settings.experimental-features = [ "nix-command" "flakes" ];
        };

        nixpkgs.config.allowUnfree = true;

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        # Enable fish and fix nix packages' order on the PATH
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
    in
    {
      darwinConfigurations = {
        Legolas = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ configuration ];
        };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Legolas".pkgs;
    };
}
