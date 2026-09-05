{ ... }:
let
  # Best-effort path denials only. Opencode permission globs are not a security
  # boundary (easy to bypass); keep a short list of high-value secrets paths.
  sensitivePaths = {
    "/etc/shadow" = "deny";
    "/etc/ssh/ssh_host_*_key" = "deny";
    "~/.ssh/id_*" = "deny";
    "~/.aws/credentials" = "deny";
    "~/secrets/**" = "deny";
  };
in
{
  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    permission = {
      bash = {
        "*" = "allow";
      };
      read = {
        "*" = "allow";
      }
      // sensitivePaths;
      edit = {
        "*" = "allow";
      }
      // sensitivePaths;
      glob = {
        "*" = "allow";
      };
      grep = {
        "*" = "allow";
      };
      list = {
        "*" = "allow";
      };
      task = {
        "*" = "allow";
      };
      external_directory = {
        "*" = "allow";
      }
      // sensitivePaths;
      lsp = {
        "*" = "allow";
      };
      skill = {
        "*" = "allow";
      };
      todowrite = "allow";
      question = "allow";
      webfetch = "allow";
      websearch = "allow";
      doom_loop = "allow";
    };
  };
}
