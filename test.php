<?php


function getRet(array $arr, int $num) {
    $ret = [];
    $len = count($arr)
    $i = 0;
    $j = 0;

    while($i < $len && $j < $num) {
        // 如果最后一个，直接压入结果中
        // 第一个直接入栈，确保栈内有值
        if($i == $len - 1 || $i == 0) {
            $ret[] = $arr[$i];
            $i++;
            continue;
        }

        // 对比数据值，如果当前数据值大于等于后一个，入栈处理数据
        if ($arr[$i] >= $arr[$i+1]) {
            $ret[] = $arr[$i];
            $i++;
            $j++;
        } else {
            // 对比当前的下一个数据与栈内数据
            if ($arr[$i+1] >= $ret[$j]) {
                
            }

        }





        if ($arr[$i] < $arr[)

        if ($j == 0) {

            

        }


        $i++;



    }



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