#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

max=0
current=0
while read line; do
    if [[ $line == "" ]]
    then
        if [[ $current -gt $max ]]
        then

            max=$current
        fi
        current=0
    else
        current=$(($current + $line))
    fi
done < $file
echo $max
