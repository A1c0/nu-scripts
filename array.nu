def split-each [num:int] {
    let $arr = $in;
    let loop_i = $arr | length | $num mod $in | $in + 1;
    mut i = 0;
    mut res = [];
    loop {
        if $i == $loop_i {break};

        let start = $i * $num;
        let tmp = $arr | skip $start | take $num;
        $res = ($res | append [$tmp]);

        $i += 1;
    }
    $res;
}
