#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

score=0
while read line; do
    line=$(tr ABCXYZ 123012 <<< $line)
    a=${line:0:1}
    b=${line:2:3}
    ascore=$(bc <<< "($a + $b -1)%3" | tr 0 3)
    score=$(($score+$ascore+3*$b))
done < $file
echo $score

