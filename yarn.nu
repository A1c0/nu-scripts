alias y = yarn
alias yb = yarn build

def closest_file [name:string] {
    while (ls | where name == $name | length) == 0 { 
        if (pwd) == $env.HOME { 
            error make {
                msg: "Could not find the file"
                label: {
                    text: "The file doesn't exist in any of the parent directories"
                    span: (metadata $name).span
                }
            };
        } else { 
            cd ..  
        }
    }
    pwd | path join $name;
}

def npm_scripts [] {
    open (closest_file package.json) | get scripts | columns | sort
}

def "yarn run" [script:string@npm_scripts, ...flags: string] {
    ^yarn run $script $flags
}

alias yr = yarn run
