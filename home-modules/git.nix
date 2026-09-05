{ config, ... }:
let
  inherit (config.dotfiles) host;
in
{
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.ssh/proton-pass-ssh-agent.sock";

  home.file.".ssh/allowed_signers".text =
    builtins.concatStringsSep "\n" (map (key: "mohibeyki@gmail.com ${key}") host.gitAllowedSigners)
    + "\n";

  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ];
    settings = {
      user = {
        name = "Mohi Beyki";
        email = "mohibeyki@gmail.com";
        signingKey = host.gitSigningKey;
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
      "gpg \"ssh\"".allowedSignersFile = "~/.ssh/allowed_signers";
      commit.gpgsign = true;
      tag.gpgsign = true;

    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
