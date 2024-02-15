set -gx EDITOR nvim

if status is-interactive
    eval (zellij setup --generate-auto-start fish | string collect)
    zoxide init fish | source
end
