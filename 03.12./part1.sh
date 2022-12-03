#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1

result=0
while read line; do
    half=$(($(wc -c <<< $line)/2))
    first=${line:0:$half}
    second=${line:$half}
    while read char; do
        if [[ "$second" =~ .*"$char".* ]]; then
            res=$(LC_CTYPE=C printf '%d' "'$char")
            res=$([[ $res -ge 96 ]] && echo "$(($res-96))" || echo "$((res-38))")
            #res=$(LC_CTYPE=C printf '%d' "'$(tr 'a-zA-Z' '\01-\64' <<< $char)")
            #[[ $res -lt 1  || $res -gt 52 ]] && echo "ERROR, $res, $char" && result=$(($result+9))
            # sadly doesn't work since j is translated to \t and another character to a wrong number :C
            result=$(($result+$res))
            break
        fi
    done <<< $(sed -e 's/\(.\)/\1\n/g' <<< $first )
done < $file
echo $result
