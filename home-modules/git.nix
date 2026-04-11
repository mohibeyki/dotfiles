{
  hostConfig,
  ...
}:
{
  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ];
    settings = {
      user = {
        name = "Mohi Beyki";
        email = "mohibeyki@gmail.com";
        signingKey = hostConfig.gitSigningKey;
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

      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/run/current-system/sw/bin/op-ssh-sign";
      commit.gpgsign = true;
    };
  };
}
