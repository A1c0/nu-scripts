def warprc [] {$env.HOME | path join ".warprc"}

def currentAliases [] {warprc | open | lines | split column ":" alias full_path}

export def "wd add" [alias: string] {
    let currentRelativePath = $env.PWD | str replace $env.HOME ~;
    let newItem = [[alias full_path]; [$alias $currentRelativePath]];
    let newAliases = currentAliases | where alias != $alias | append $newItem;
    print $newAliases;
    $newAliases | to csv -n -s ":" | save (warprc) -f;
    print $"Warp added as ($alias)";
}

def wdAliases [] { currentAliases | get alias | sort }

export def-env main [alias: string@wdAliases] {
    let full_path = currentAliases | where alias == $alias | get full_path | first;
    cd $full_path;
}