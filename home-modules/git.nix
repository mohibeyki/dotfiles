{
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (config.dotfiles) host;
in
{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

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
      "gpg \"ssh\"".program =
        if isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "/run/current-system/sw/bin/op-ssh-sign";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
}
