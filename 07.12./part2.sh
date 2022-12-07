#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

currdir="root"
declare -A scores
while read line; do

    if [[ $(grep -o "\$ cd" <<< $line) != ""  ]]
    then
        dir=$(grep -o "[a-zA-Z\./]*$" <<< $line)
        [[ $dir == "/" ]] && currdir="root"
        [[ $dir == ".." ]] && currdir="$(dirname $currdir)"
        [[ $dir != "/" && $dir != ".." ]] && currdir="$currdir/$dir"
    elif [[ $(grep -o "\$ ls" <<< $line) != ""  ]]
    then
        scores["$currdir"]="0"
    elif [[ $(grep -o "^dir" <<< $line) != ""  ]] 
    then
        dir="$currdir/$(grep -o "[a-zA-Z\./]*$" <<< $line)"
        scores["$currdir"]+="+$dir"
    elif [[ $(grep -o "^[0-9]" <<< $line) != ""  ]] 
    then
        size=$(grep -o "[0-9]*" <<< $line)
        scores["$currdir"]+="+$size"
    else
        echo "dont understand $line"
    fi

done < $file

changed=true
while $changed ; do
    changed=false
    for folder in "${!scores[@]}"; do 
        term=${scores[$folder]}
        if [[ $(grep -o "[a-zA-Z]" <<< $term | wc -l) -eq 0 ]]
        then
           scores[$folder]=$(bc <<< $term) 
        else
            for key in $(grep -o "[a-zA-Z/]*" <<< $term)
            do
                scores[$folder]=$(sed "s#$key#${scores[$key]}#" <<< $term )
                changed=true
            done
        fi
    done
done

maxsize=70000000
minfree=30000000
startsize=${scores[root]}
startfree=$(($maxsize-$startsize))
currfree=$maxsize
result=0

for folder in "${scores[@]}"; do
    newfree=$(($maxsize-$startsize+$folder))
    [[ $newfree -ge $minfree && $newfree -lt $currfree ]] && currfree=$newfree && result=$folder
done
echo $result
