def warprc [] {$env.HOME | path join ".warprc"}

def currentAliases [] {warprc | open | lines | split column ":" value description}

export def "add" [alias: string] {
    let currentRelativePath = $env.PWD | str replace $env.HOME ~;
    let newItem = [[alias full_path]; [$alias $currentRelativePath]];
    let newAliases = currentAliases | where alias != $alias | append $newItem;
    $newAliases | to csv -n -s ":" | save (warprc) -f;
    print $"(ansi green_bold)*(ansi reset) Warp (ansi green_bold)($alias)(ansi reset) added";
}

def "nu-complete wd" [] { currentAliases | sort-by value | each {|e| $e | into record} }

export def-env main [alias: string@"nu-complete wd"] {
    let alias_relative_path = currentAliases | where value == $alias | get description | first
    cd $alias_relative_path;
}