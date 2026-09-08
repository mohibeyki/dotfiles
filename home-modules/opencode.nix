_:
let
  # Best-effort path denials only. Opencode permission globs are not a security
  # boundary (easy to bypass); keep a short list of high-value secrets paths.
  sensitivePaths = {
    "/etc/shadow" = "deny";
    "/etc/ssh/ssh_host_*_key" = "deny";
    "~/.ssh/id_*" = "deny";
    "~/.aws/credentials" = "deny";
    "~/.config/1Password" = "deny";
    "~/.config/1Password/**" = "deny";
    "~/.1password" = "deny";
    "~/.1password/**" = "deny";
    "~/Library/Group Containers/2BUA8C4S2C.com.1password" = "deny";
    "~/Library/Group Containers/2BUA8C4S2C.com.1password/**" = "deny";
    "~/Documents/llm.conf" = "deny";
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
      }
      // sensitivePaths;
      grep = {
        "*" = "allow";
      }
      // sensitivePaths;
      list = {
        "*" = "allow";
      }
      // sensitivePaths;
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
