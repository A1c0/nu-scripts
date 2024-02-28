def split-each [num:int] {
    let input = $in;
    let last_index = $input | length | $in / $num | math floor;
    0..$last_index | each {|i| $input | skip ($i * $num) | take $num}      
}