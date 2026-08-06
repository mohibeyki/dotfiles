{
  config,
  ...
}:
let
  # Shared secrets file (not managed by Nix): KEY=value lines.
  #   MOONSHOT_API_KEY=sk-...
  #   OPENAI_API_KEY=sk-...
  #   ANTHROPIC_API_KEY=sk-...
  #   XAI_API_KEY=xai-...
  #
  # Do not use home.sessionVariablesExtra for this — HM also emits it into
  # hm-session-vars.fish, and bash `set -a` is invalid Fish syntax.
  llmEnvFile = "${config.home.homeDirectory}/Documents/llm.conf";
in
{
  # Fish: parse KEY=value (skip blanks/comments) and export.
  programs.fish.shellInit = ''
    set -l __llm_env "${llmEnvFile}"
    if test -f $__llm_env
      for __line in (command cat $__llm_env | string match -r -v '^\s*#' | string match -r -v '^\s*$')
        set -l __kv (string split -m 1 = -- $__line)
        if test (count $__kv) -eq 2
          set -l __val (string trim --chars \'\" -- $__kv[2])
          set -gx $__kv[1] $__val
        end
      end
      set -e __line __kv __val
    end
    set -e __llm_env
  '';

  # Bash/zsh: allexport-source the same file (never goes through Fish).
  programs.bash.initExtra = ''
    if [ -f "${llmEnvFile}" ]; then
      set -a
      # shellcheck disable=SC1090
      . "${llmEnvFile}"
      set +a
    fi
  '';

  programs.zsh.initExtra = ''
    if [ -f "${llmEnvFile}" ]; then
      set -a
      # shellcheck disable=SC1090
      . "${llmEnvFile}"
      set +a
    fi
  '';
}
