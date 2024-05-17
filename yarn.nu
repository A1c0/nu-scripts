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
    if ($flags | is-empty) {
        ^yarn run $script;
        return;
    }
    else {
        ^yarn run $script $flags;
        return;
    }
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
    | join -i (
        git blame -c package.json 
        | lines 
        | parse -r '^.*\t\((?<updatedBy>.*)\t(?<updatedAt>.*)\t\d+\)\s+\"(?<name>.*)\":.*\d+.\d+.\d+' 
        | update updatedAt {into datetime}
    ) name
}

def safeParseInt [d:string] {try {$d | into int } catch {0}}

def parseSemVer [version] {
    const sem_ver_regex = '(?P<major>\d+)(\.(?P<minor>\d+)(\.(?P<patch>\d+))?)?';
    let parsed = $version | parse --regex $sem_ver_regex | first;
    {major: (safeParseInt $parsed.major), minor: (safeParseInt $parsed.minor), patch: (safeParseInt $parsed.patch) }
}

def compute-criticality [current: string, latest: string] {
    let current_parsed = parseSemVer $current 
    let latest_parsed = parseSemVer $latest;

    if ($current_parsed.major < $latest_parsed.major) {
        if ($latest_parsed.major - $current_parsed.major > 1) {
            return 3
        } else {
            return 2
        }
    } else if ($current_parsed.minor != $latest_parsed.minor) {
        return 1
    } else {
        return 0
    }
}

def all-npm-dependencies-with-latest [] {
    let dependencies = all-npm-dependencies;
    let latest_version = $dependencies | get name | par-each {|name| {name : $name, latest: (http get $"https://registry.npmjs.org/($name)" | | get dist-tags.latest) }}
    $dependencies | join $latest_version name | insert criticality {|row| compute-criticality $row.version $row.latest};
}

alias yr = yarn run
