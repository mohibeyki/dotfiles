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
    ./onepassword.nix
    ./rclone.nix
    ./ssh.nix
    ./tmux.nix
    ./zed.nix
    ./zellij.nix
  ];
}
