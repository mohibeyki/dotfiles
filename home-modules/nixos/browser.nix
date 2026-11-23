{ pkgs, ... }:
let
  desktop = "brave-origin.desktop";
in
{
  home.packages = [ pkgs.brave-origin ];
  home.sessionVariables.BROWSER = "brave-origin";

  xdg.mimeApps.defaultApplications = {
    "text/html" = desktop;
    "application/xhtml+xml" = desktop;
    "x-scheme-handler/http" = desktop;
    "x-scheme-handler/https" = desktop;
    "x-scheme-handler/about" = desktop;
    "x-scheme-handler/unknown" = desktop;
  };
}
