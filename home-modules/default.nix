{ ... }:
{
  imports = [
    ./host-config.nix
    ./common.nix
    ./agents.nix
    ./user-dev.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./neovim.nix
    ./onepassword.nix
    ./rclone.nix
    ./ssh.nix
    ./tmux.nix
    ./zed.nix
  ];
}
