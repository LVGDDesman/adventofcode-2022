#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

stacks=()
IFS=''
move=""
#start
while read line; do
    [[ $line == "" ]] && move="1" && continue
    if [[ $move == "" ]]
    then
        len=$(wc -c <<< $line)
        i=0
        while true; do
            pos=$(($i*4+1)) 
            [ $pos -gt $len ] && break;
            char=${line:$pos:1}
            [[ $char =~ [0-9] ]] && break
            [[ $char == " " ]] && stacks[$i]="" || stacks[$i]="$char${stacks[$i]}"
            i=$(($i+1))
        done
    else
        count=$(sed 's/.*move \([0-9]*\).*/\1/g' <<< $line)
        from=$(($(sed 's/.*from \([0-9]*\).*/\1/g' <<< $line)-1))
        to=$(($(sed 's/.*to \([0-9]*\).*/\1/g' <<< $line)-1))
        stacks[$to]+=$(rev <<< "${stacks[$from]:(-${count})}")
        stacks[$from]="${stacks[$from]:0:(-$count)}"
    fi
done < $file

sed -E 's/[a-zA-Z]*([a-zA-Z])[ ]?/\1/g' <<< "${stacks[@]}"
