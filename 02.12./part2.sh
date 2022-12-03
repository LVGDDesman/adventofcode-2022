#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

score=0
while read line; do
    score=$(tr ABCXYZ 123012 <<< $line | sed "s/\(.\) \(.\)/(\1+\2+1)%3+1+3*\2+$score/g" | bc)
done < $file
echo $score

