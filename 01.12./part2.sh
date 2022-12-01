#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

totals=()
current=0
while read line; do
    if [[ $line == "" ]]
    then
        if [[ $current -gt $max ]]
        then
            totals+=($current)
        fi
        current=0
    else
        current=$(($current + $line))
    fi
done < $file

printf "%s\n" "${totals[@]}" | sort -nr | head -n 3 | xargs | sed 's/ /+/g' | bc
