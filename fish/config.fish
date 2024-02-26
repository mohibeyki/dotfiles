set -gx EDITOR nvim

if status is-interactive
    zoxide init fish | source
end
