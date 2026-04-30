{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      bzip2
      curl
      libffi
      libxml2
      ncurses
      openssl
      sqlite
      stdenv.cc.cc
      xz
      zlib
      zstd
    ];
  };
}
