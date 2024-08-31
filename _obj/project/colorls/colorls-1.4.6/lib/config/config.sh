#!/bin/bash

dirPath=$(cd `dirname $0`; pwd)

config="$dirPath/dark_colors.yaml"
template="$dirPath/color.yaml"

color_hex=$(cat $config|sed '/^#/d;/^$/d'|awk '{print $2}'|sort|uniq|sed "s/'//g")

HEX_RGB(){
  local R G B H
  H=$1
  R=$((16#${H:1:2}))
  G=$((16#${H:3:2}))
  B=$((16#${H:5:2}))
  echo "$R;$G;$B"
  
}

num=1
for hex in $(echo $color_hex)
do
    # echo 8$hex
    # HEX_RGB $hex
    echo -e "\033[38;2;$(HEX_RGB $hex)m $hex \033[0m $num"
    ((num++))
done




