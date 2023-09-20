alias gco = git checkout
alias gst = git status
alias grhh = git reset --hard HEAD
alias gaa = git add --all
alias gfa = git fetch --all
alias gcam = git commit --all --message 


def ggfl [] {
    let current = git rev-parse --abbrev-ref HEAD
    print $current;
    print $current | describe;
    git push --force-with-lease origin $current;
}

alias groh = git reset --hard $"origin/(current_branch)"
