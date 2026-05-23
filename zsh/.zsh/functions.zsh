# Sesh - fuzzy find tmux sessions
function s() {
    local session
    session=$(sesh list -t | fzf \
        --no-sort --border-label ' sesh ' --prompt '⚡ ' \
        --header ' ^a all / ^t tmux / ^g configs / ^d kill' \
        --bind 'ctrl-a:change-prompt(⚡ )+reload(sesh list)' \
        --bind 'ctrl-t:change-prompt(🪟 )+reload(sesh list -t)' \
        --bind 'ctrl-g:change-prompt(⚙️ )+reload(sesh list -c)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡ )+reload(sesh list -t)')
    [[ -n "$session" ]] && sesh connect "$session"
}

glog() {
    local n="${1#-}"
    git log "-${n:-10}" --oneline --graph --decorate
}
