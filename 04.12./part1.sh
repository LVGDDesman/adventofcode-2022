#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

score=0
while read line; do
    score=$(($score+$(sed 's/\(.*\)-\(.*\),\(.*\)-\(.*\)/((\1<=\3)\&\&(\2>=\4)||(\3<=\1)\&\&(\4>=\2))/g' <<< $line  | bc )))
    
done < $file

echo $score

