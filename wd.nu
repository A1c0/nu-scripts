def warprc [] {$env.HOME | path join ".warprc"}

def currentAliases [] {warprc | open | lines | split column ":" alias full_path}

export def "add" [alias: string] {
    let currentRelativePath = $env.PWD | str replace $env.HOME ~;
    let newItem = [[alias full_path]; [$alias $currentRelativePath]];
    let newAliases = currentAliases | where alias != $alias | append $newItem;
    $newAliases | to csv -n -s ":" | save (warprc) -f;
    print $"(ansi green_bold)*(ansi reset) Warp (ansi green_bold)($alias)(ansi reset) added";
}

def wdAliases [] { currentAliases | get alias | sort }

export def-env main [alias: string@wdAliases] {
    let full_path = currentAliases | where alias == $alias | get full_path | first;
    cd $full_path;
}