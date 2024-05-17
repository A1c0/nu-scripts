def git_current_branch [] {git rev-parse --abbrev-ref HEAD | str trim}

alias gst = git status
alias grhh = git reset --hard
alias gfa = git fetch --all

def gcam [msg: string] {git commit --all --message $msg}

def ggl [] {
    let current = git_current_branch
    git pull --rebase origin $current
}

def ggp [] {
    let current = git_current_branch
    git push origin $current
}

def ggfl [] {
    let current = git_current_branch
    git push --force-with-lease origin $current
}

def groh [] {
    let current   = git_current_branch
    git reset --hard $"origin/($current)"
}

def gpsup [] {
    let current   = git_current_branch
    git push --set-upstream origin $current
}

def gstf [] {
    let files_modified = gst -s | lines | split column ' ' --collapse-empty | rename flag name;
    let files_modified_ls_info = $files_modified | get name | par-each {ls -l $in | first};

    $files_modified | join $files_modified_ls_info name | select flag name created accessed modified;
}

def add_apr_in_branch [apr:string] {
    let current = git_current_branch
    git branch -M $"($apr | str upcase)_($current)"
}

alias gaa = git add --all 
alias gco = git checkout
