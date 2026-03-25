{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home = {
    username = "mohi";
    stateVersion = "26.05";
    homeDirectory = if isDarwin then "/Users/mohi" else "/home/mohi";
  };
}
