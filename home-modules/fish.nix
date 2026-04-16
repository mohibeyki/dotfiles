{
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        inherit (pkgs.fishPlugins.tide) src;
      }
    ];

    interactiveShellInit = ''
      set -g tide_context_always_display true
      set -g tide_context_hostname_parts 1
    '';

    functions = {
      claude-minimax = ''
        set key_file ~/.config/ai-api/minimax.txt
        if not test -f $key_file
          echo "Error: $key_file not found"
          return 1
        end
        set -x ANTHROPIC_BASE_URL "https://api.minimax.io/anthropic"
        set -x ANTHROPIC_AUTH_TOKEN (string trim (cat $key_file))
        set -x API_TIMEOUT_MS "3000000"
        set -x CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC "1"
        set -x ANTHROPIC_MODEL "MiniMax-M2.7"
        set -x ANTHROPIC_SMALL_FAST_MODEL "MiniMax-M2.7"
        set -x ANTHROPIC_DEFAULT_SONNET_MODEL "MiniMax-M2.7"
        set -x ANTHROPIC_DEFAULT_OPUS_MODEL "MiniMax-M2.7"
        set -x ANTHROPIC_DEFAULT_HAIKU_MODEL "MiniMax-M2.7"
        claude $argv
        set -e ANTHROPIC_BASE_URL ANTHROPIC_AUTH_TOKEN API_TIMEOUT_MS CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC ANTHROPIC_MODEL ANTHROPIC_SMALL_FAST_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL ANTHROPIC_DEFAULT_OPUS_MODEL ANTHROPIC_DEFAULT_HAIKU_MODEL
      '';

      claude-kimi = ''
        set key_file ~/.config/ai-api/kimi.txt
        if not test -f $key_file
          echo "Error: $key_file not found"
          return 1
        end
        set -x ANTHROPIC_BASE_URL "https://api.kimi.com/coding/"
        set -x ANTHROPIC_AUTH_TOKEN (string trim (cat $key_file))
        claude $argv
        set -e ANTHROPIC_BASE_URL ANTHROPIC_AUTH_TOKEN
      '';
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      tree = "eza --tree --icons";
    };
  };
}
