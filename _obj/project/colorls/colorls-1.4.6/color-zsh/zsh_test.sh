#!/bin/zsh


dirPath=$(cd `dirname $0`; pwd)
icons_path="$dirPath/color_font_icons.yaml"
paths="$dirPath/char_file_icons.yaml"

echo '' > $icons_path

length=$(cat $paths|awk '{print $1}'|sed '/^$/d'|awk '{ print length, $0}'|sort -rn|head -n 1|awk '{print $1}')
(( length= length + 10 ))

icon_data=$(cat $paths|sed 's/\\u//g;/^$/d;s/\ /*/g')


for line in $(echo "$icon_data");do
    
    name=$(echo $line|sed 's/\*/ /g'|awk -F ' ' '{print $1}')
    icons=$(echo $line|sed 's/\*/ /g'|awk -F ' ' '{print $2}')
    
    icons_char=$(echo "$icons"|awk -F '|' '{print $1}')
    icons_color=$(echo "$icons"|awk -F '|' '{print $2}'|sed 's/\;/ /g')

    # echo $#icons_char
    if (( $#icons_char == 1 ));then
        icons_char=$(wezterm ls-fonts --text $icons_char|awk '{print $3}'|sed 's/\\u{//g;s/}//g;/^$/d')
    fi


    char=$(bash -c "printf \"%-4s\" $icons_char") 
    hex=$(bash -c "printf \"#%02x%02x%02x\n\" $icons_color")
    name=$(bash -c "printf \"%-${length}s\" $name")
    

    echo "$name \u$icons_char|@$char|$hex" >> $icons_path
    
done

gsed -i 's/@/\\u/g' $icons_path
