def aws_profil [] = {open ~/.aws/config | lines | filter {|x| $x =~ '\[profil.*\]'} | parse "[profile {profil}]" | get profil | append "default"};

export def "aws profile current" [] {
    aws sts get-caller-identity | str replace --all --regex '\n\s*' '' | from json
}

export def --env "aws profile switch" [profile: string@aws_profil] {
    if $profile == "default" {
        hide-env AWS_PROFILE
    } else {
        $env.AWS_PROFILE = $profile;
    }
}