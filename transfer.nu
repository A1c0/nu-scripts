def file_in_dir [] {ls | where type == file | get name}

# Upload file and copy the link
export def main [
    file: string@file_in_dir #  The file you want to tranfer
    ] {
    let relative_path = $"./($file)"
    let url = $"https://transfer.synalabs.hosting/($file)"
    let download_url = curl --progress-bar --upload-file $relative_path $url | str trim
    $"curl -o ($file) ($download_url)" | pbcopy
    print $download_url
}