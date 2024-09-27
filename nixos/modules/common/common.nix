{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
	  fish
	  git
	  gnumake
	  mc
	  neovim
	  wget
    btop
    fd
    gcc
    go
    lazygit
    nodejs
    ripgrep
    rustup
    tree-sitter
    zoxide
  ];
}
