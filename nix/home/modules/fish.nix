{ ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -gx EDITOR nvim
      set -g pure_enable_single_line_prompt true
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
