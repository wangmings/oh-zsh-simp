# !/bin/bash

dir=$(cd `dirname $0`; pwd)
font_icons="$dir/icon.yaml"


if (( $# > 0  ));then
    
    grepStr=""
    
    for arg in $*; do
        grepStr+="|grep -i '$arg'"
    done

    grepStr=$(eval "cat $font_icons$grepStr")

    echo "$grepStr"|awk '{print "\033[34m" $1 " \033[0m    \033[32;1m" $2 "\033[0m    \033[34;1m" $3 "\033[0m"}'

else
    echo "
    icon:
        # 使用方法
        icon icon_name icon_type
        icon file type
    "

fi







# icons_path="$dir/icon2.yaml"

# icons=$(cat $font_icons|sed 's/\\u//g;s/ /*/g')

# echo "" >> $icons_path

# for line in $(echo "$icons");do
#     line=$(echo $line|sed 's/*/ /g')
#     icon_char=$(echo $line|awk '{print $1}'|sed 's/ //g')
#     icon_name=$(echo $line|awk '{print $2}')
#     line="\u$icon_char    @$icon_char   $icon_name"
#     echo "$line" 
#     echo "$line" >> $icons_path
# done

# gsed -i 's/@/\\u/g' $icons_path

# cat $font_icons










