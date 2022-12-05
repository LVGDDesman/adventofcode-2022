#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

score=0
while read line; do
    n=($(sed 's/\(.*\)-\(.*\),\(.*\)-\(.*\)/\1 \2 \3 \4/g' <<< $line))
    s1=($( [[ ${n[0]} -lt ${n[1]} ]] && echo "${n[0]} ${n[1]}" || echo "${n[1]} ${n[0]}"))
    s2=($( [[ ${n[2]} -lt ${n[3]} ]] && echo "${n[2]} ${n[3]}" || echo "${n[2]} ${n[3]}"))
    s=($( [[ ${s1[0]} -lt ${s2[0]} ]] && echo "${s1[@]} ${s2[@]}" || echo "${s1[@]} ${s2[@]}"))
    
    if [[ ${s[1]} -ge ${s[2]} && ${s[0]} -le ${s[3]} ]]
    then
        score=$(($score+1))
    fi
done < $file

echo $score

