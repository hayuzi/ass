<?php


function getRet(array $arr, int $num) {
    $ret = [];
    $x = 0;
    $len = count($arr)
    foreach($arr as $k => $v) {
        if ($k == $len - 1 - $x) {
            break;
        }
        if ($x = 0) {
            if（$v > $arr[$k+1]）{
                $ret[] = $v;
                $x++;
            } else {
                continue;
            }
        } else {

        }
        if ($x == $num) {
            break;
        }
    }

}