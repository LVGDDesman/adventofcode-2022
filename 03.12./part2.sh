#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

result=0
while read line1; read line2; read line3; do
    while read char; do
        if [[ "$line2" =~ .*"$char".* && "$line3" =~ .*"$char".* ]]; then
            res=$(LC_CTYPE=C printf '%d' "'$char")
            res=$([[ $res -ge 96 ]] && echo "$(($res-96))" || echo "$((res-38))")
            result=$(($result+$res))
            break
        fi
    done <<< $(sed -e 's/\(.\)/\1\n/g' <<< $line1)
done < $file
echo $result
