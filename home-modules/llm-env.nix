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
  llmEnvFile = "${config.xdg.configHome}/llm.conf";

  # Preserve the caller's allexport setting when sourcing shell-compatible values.
  posixInit = ''
    if [ -r "${llmEnvFile}" ]; then
      case $- in
        *a*) . "${llmEnvFile}" ;;
        *)
          set -a
          . "${llmEnvFile}"
          set +a
          ;;
      esac
    fi
  '';
in
{
  # Fish: parse KEY=value (skip blanks/comments) and export.
  programs = {
    fish.shellInit = ''
      set -l __llm_env "${llmEnvFile}"
      if test -r "$__llm_env"
        while read -l __line
          set __line (string replace -r '\r$' "" -- "$__line")
          set -l __kv (string split -m 1 = -- "$__line")
          test (count $__kv) -eq 2; or continue
          string match -rq '^[A-Za-z_][A-Za-z0-9_]*$' -- "$__kv[1]"; or continue

          # Remove one matching pair of quotes, not every quote at either end.
          # Quoted expansion preserves empty values as one string.
          set -l __val "$__kv[2]"
          if string match -rq '^".*"$' -- "$__val"; or string match -rq "^'.*'\$" -- "$__val"
            set __val (string sub -s 2 -l (math (string length -- "$__val") - 2) -- "$__val")
          end
          set -gx "$__kv[1]" "$__val"
        end < "$__llm_env"
      end
      set -e __llm_env
    '';

    # Used if these shells are enabled in Home Manager; Fish is the login shell.
    bash.initExtra = posixInit;
    zsh.initContent = posixInit;
  };
}
