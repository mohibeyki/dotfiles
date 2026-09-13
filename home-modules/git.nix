{
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWAa0kKyejpLeHARiBUsnJvzgljWIzBJnGm2BcueVWk";

  signer =
    if isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      lib.getExe' pkgs._1password-gui "op-ssh-sign";
in
{
  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ];

    signing = {
      format = "ssh";
      signByDefault = true;
      key = signingKey;
      inherit signer;
      allowedSigners = ''
        mohibeyki@gmail.com namespaces="git" ${signingKey}
      '';
    };

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

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
