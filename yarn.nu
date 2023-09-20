alias y = yarn
alias yb = yarn build

def npm_scripts [] {
    open package.json | get scripts | columns | sort
}

def "yarn run" [script:string@npm_scripts] {
    ^yarn run $script
}

alias yr = yarn run
