def split-each [num:int] {
    let input = $in;
    let loop_i = $input | length | $in / $num | math ceil;
    mut arr = [];
    mut i = 0; loop {
        if $i == $loop_i { break };
        let item = ($input | skip ($i * $num) | take $num)
        $arr = ($arr | append [$item]);
        $i = $i + 1;
    }
    $arr;
}
