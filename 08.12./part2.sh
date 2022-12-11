#!/bin/bash

file=$1
[[ ! -f $file || $file == "" ]] && echo "File not found" && exit 1
#echo "Running this script on the problem takes ~15 minutes!"

result=0
lines=()
linecount=0

while read line; do
    lines[$linecount]=$line
    linecount=$(($linecount+1))
done < $file

xmax=$((${#lines}-1))
ymax=${#lines[0]}

for x in $(seq 0 $xmax); do
    for y in $(seq 1 $ymax); do
        char=${lines[$x]:y-1:1}
        
        #echo "test $char ($x:$y)"
        
        currresult=1
        stack=("+1:+0" "-1:+0" "+0:+1" "+0:-1")
        # this algorithm is pretty inefficient, since it tests tree aisles multiple times 
        # some more logic would speed this up very much, too 
        count=0
        while [[ ${#stack[@]} -ne 0 ]] ; do 
            count=$(($count+1))
            element=${stack[0]}
            stack=("${stack[@]:1}")
            nx=$(($x$(sed 's/\(.*\):.*/\1/g' <<< $element)))
            ny=$(($y$(sed 's/.*:\(.*\)/\1/g' <<< $element)))
            nchar=${lines[$nx]:ny-1:1}
            [[ $nchar -ge $char || $nx -le 0 || $nx -ge $xmax || $ny -le 1 || $ny -ge $ymax ]] && 
                currresult=$(($currresult*$count)) && count=0 && continue #found something
            [[ $element =~ (.*[^0-9])([1-9][0-9]?)(.*)$ ]] && stack=("${BASH_REMATCH[1]}$((${BASH_REMATCH[2]} + 1))${BASH_REMATCH[3]}" ${stack[@]})
            # TLDR: regex match the non 0 part; increment and put at start of stack -> depth first
        done
        [[ $currresult -gt $result ]] && result=$currresult
    done
done
echo $result
