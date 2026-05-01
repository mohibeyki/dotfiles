{ ... }:
{
  imports = [
    ./host-config.nix
    ./common.nix
    ./user-dev.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./helix.nix
    ./neovim.nix
    ./nixvim.nix
    ./tmux.nix
    ./zed.nix
    ./zellij.nix
  ];
}
