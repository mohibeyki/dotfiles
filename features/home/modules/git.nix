{ ... }:
{
  flake.homeModules.git =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        package = pkgs.git;
        ignores = [ ".DS_Store" ];
        settings = {
          user = {
            name = "Mohi Beyki";
            email = "mohibeyki@gmail.com";
          };

          alias = {
            co = "checkout";
            ci = "commit";
            st = "status";
            br = "branch";
            hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
          };

          core.editor = "nvim";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
      };
    };
}
