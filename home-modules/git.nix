{
  hostConfig,
  pkgs,
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
      "gpg \"ssh\"".program =
        if pkgs.stdenv.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "/run/current-system/sw/bin/op-ssh-sign";
      commit.gpgsign = true;
    };
  };
}
