#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

while read line; do
    score=14
    sot=${line:0:14}
    line=${line:14}
    while true; do
        [[ $(sed -e 's/\(.\)/\1\r\n/g' <<< $sot | sort -u | wc -l) -eq 15 ]] && echo $score && break
        
        [[ $line == "" ]] && echo "nothing found" && break
        sot="${sot:1}${line:0:1}"
        line=${line:1}
        score=$(($score+1))
    done

done < $file

