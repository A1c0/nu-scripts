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

def all-npm-dependencies [] {
    open package.json 
    | select dependencies devDependencies 
    | transpose group items 
    | update items {|row| 
        $row.items 
        | transpose name version 
        | insert isDev ($row.group == 'devDependencies')} 
    | get items 
    | flatten
    | join (
        git blame package.json 
        | lines 
        | parse -r '^[0-9a-z]+ [^ ]+\s+\((?<updatedBy>.*?)\s{2,}(?<updatedAt>\d+-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2} \+\d+).*?"(?<name>[^"]+)' 
        | update updatedAt {into datetime}
    ) name
}

alias yr = yarn run
