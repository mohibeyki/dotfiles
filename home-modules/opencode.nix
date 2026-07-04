{ config, pkgs, ... }:
let
  dangerousBashCommands = {
    "rm -rf /" = "deny";
    "rm -rf /*" = "deny";
    "dd if=* of=/dev/*" = "deny";
    "mkfs.*" = "deny";
    "fdisk *" = "deny";
    "parted *" = "deny";
    "shutdown*" = "deny";
    "reboot*" = "deny";
    "poweroff*" = "deny";
    "curl * | bash" = "deny";
    "curl * | sh" = "deny";
    "wget * | bash" = "deny";
    "wget * | sh" = "deny";
    "chmod 777 *" = "deny";
    "chmod -R 777 *" = "deny";
    "chown -R *" = "deny";
  };

  sensitivePaths = {
    "/etc/shadow" = "deny";
    "/etc/ssh/ssh_host_*_key" = "deny";
    "~/.ssh/id_*" = "deny";
    "~/.aws/credentials" = "deny";
    "~/.config/1Password/*" = "deny";
    "~/secrets/**" = "deny";
  };
in
{
  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    permission = {
      bash = { "*" = "allow"; } // dangerousBashCommands;
      read = { "*" = "allow"; } // sensitivePaths;
      edit = { "*" = "allow"; } // sensitivePaths;
      glob = { "*" = "allow"; };
      grep = { "*" = "allow"; };
      list = { "*" = "allow"; };
      task = { "*" = "allow"; };
      external_directory = { "*" = "allow"; } // sensitivePaths;
      lsp = { "*" = "allow"; };
      skill = { "*" = "allow"; };
      todowrite = "allow";
      question = "allow";
      webfetch = "allow";
      websearch = "allow";
      doom_loop = "allow";
    };
  };
}