#!/bin/bash


dirPath=$(cd `dirname $0`; pwd)

config_path="$dirPath/color_config.yaml"

# paths="$dirPath/../lib/config/dark_colors.yaml"
paths="$dirPath/../lib/config/light_colors.yaml"

rainbow_color="$dirPath/color_rainbow_x11.yaml"

color_name=$(cat $paths|sed '/^#/d;/^$/d'|awk '{print $2}'|sort|uniq)




color="
black   #090300
red     #db2d20
green   #FF1493
yellow  #ff9300
blue    #01a0e4
magenta #a16a94
cyan    #1E90FF
white   #a5a2a2
"



config=$(cat $paths)




for name in $color_name; do
    # echo 8$name
    hex=$(echo "$color"|grep "${name}"|head -n 1|awk '{print $2}')
    (( ${#hex} == 0 )) && hex=$(cat $rainbow_color|grep "^${name}:"|head -n 1|awk '{print $2}')
    config=$(echo "$config"|sed "s/ $name$/'$hex'/g")

done


length=$(echo "$config"|awk -F ':' '{print $1}'|awk '{ print length, $0}'|sort -rn|head -n 1|awk '{print $1}')

(( length = length + 10 ))


line_all=''

for line in $(echo "$config"|sed 's/ /*/g');do
    # echo 8$line
    line=$(echo $line|sed 's/*//g')
    hex=$(echo $line|awk -F ':' '{print $2}')
    key=$(echo $line|awk -F ':' '{print $1}')
    key=$(printf "%-${length}s" "$key:")

    if (( ${#hex} > 0 ));then
        line="$key $hex" 
    fi

    line_all+="$line\n"

done

echo -e "$(echo -e "$line_all"|sed 's/^#/\\n# /g')" > $config_path
























