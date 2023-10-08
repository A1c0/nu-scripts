def git_current_branch [] {git rev-parse --abbrev-ref HEAD | str trim}


alias gst = git status
alias grhh = git reset --hard
alias gfa = git fetch --all

def gcam [msg: string] {git commit --all --message $msg}

def ggl [] {
    let current = git_current_branch
    git pull --rebase origin $current
}

def ggfl [] {
    let current = git_current_branch
    git push --force-with-lease origin $current
}

def groh [] {
    let current   = git_current_branch
    git reset --hard $"origin/($current)"
}

alias gaa = git add --all 
alias gco = git checkout
