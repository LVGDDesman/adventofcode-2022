#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

score=0
while read line; do
    line=$(tr ABCXYZ 123123 <<< $line)
    a=${line:0:1}
    b=${line:2:3}
    score=$(($score + $b)) 
    [[ $b -eq $a ]] && score=$(($score + 3))
    [[ $b -gt $a && $(($a+$b)) -ne 4 ]] && score=$(($score + 6))
    [[ $a -gt $b && $(($a+$b)) -eq 4 ]] && score=$(($score + 6))
    #echo $a,$b=$score
    #score=$(($score + $(sed 's/ \([XYZ]\)/-\1-1)*-3 + \1/g' <<< "($line" | tr AXBYCZ 112233 | bc))) # sadly doesn't work :C
done < $file
echo $score

