{ config, pkgs, ... }:
{
  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    permission = {
      bash = {
        "*" = "allow";
        "rm -rf /" = "deny";
        "dd if=* of=/dev/*" = "deny";
        "mkfs.*" = "deny";
        "fdisk *" = "deny";
        "shutdown*" = "deny";
        "reboot*" = "deny";
        "curl * | bash" = "deny";
        "wget * | bash" = "deny";
        "chmod 777 *" = "deny";
        "chown -R *" = "deny";
      };
    };
  };
}