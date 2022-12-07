#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

while read line; do
    score=4
    sot=${line:0:4}
    line=${line:4}
    while true; do
        [[ $(sed -e 's/\(.\)/\1\r\n/g' <<< $sot | sort -u | wc -l) -eq 5 ]] && echo $score && break
        
        [[ $line == "" ]] && echo "nothing found" && break
        sot="${sot:1}${line:0:1}"
        line=${line:1}
        score=$(($score+1))
    done

done < $file

