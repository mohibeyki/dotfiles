{ ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -gx tide_context_always_display:true
    '';

    functions = {
      d = {
        body = ''
          x2ssh -et dev
        '';
      };
    };
  };
}
