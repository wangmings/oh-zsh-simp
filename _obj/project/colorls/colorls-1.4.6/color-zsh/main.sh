#!/bin/zsh

# 查看调色板

dirPath=$(cd `dirname $0`; pwd)
yaml="$dirPath/../lib/config/dark_colors.yaml"
color_yaml="$dirPath/color_yaml.rb"
color_rainbow="$dirPath/color_rainbow.rb"


# Rainbow模块支持的颜色
color_name_str="aliceblue, antiquewhite, aqua, aquamarine, azure, beige, bisque, blanchedalmond, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflower, cornsilk, crimson, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, greenyellow, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrod, lightgray, lightgreen, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightsteelblue, lightyellow, lime, limegreen, linen, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navyblue, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, rebeccapurple, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, webgray, webgreen, webmaroon, webpurple, wheat, whitesmoke, yellowgreen"
color_name_str=$(echo -e "${color_name_str//\,/\\n}"|sed 's/^ //g'|awk '{ print length, $0}' |sort -rn)

# 获取colorls配置颜色
color_name_yaml=$(cat $yaml|sed '/^#/d'|awk -F' ' '{print $2}'|sed '/^$/d'|sort|uniq|awk '{ print length, $0}' |sort -rn)


# 输出ruby文件
function getColor(){

    local  color_name name_length length str_name ruby_file

    ruby_file=$2
    color_name=$1
    name_length=$(echo "$color_name"|head -n 1|awk -F' ' '{print $1}')
    color_name=$(echo "$color_name"|awk '{ print length, $0}'|sort -n|awk -F' ' '{print $3}')

    echo "require 'rainbow'" > $ruby_file

    for name in $color_name; do
        length=${#name}
        str_name=$name
        if (( $name_length > $length ));then
            (( length=name_length - length ))
            sp=$(zsh -c "echo \"\${(l.$length.. .)}\"")
            str_name="$name$sp"
        fi

        echo "puts \"\e[36m$str_name\e[0m |  \" + Rainbow(\"$str_name\").$name + \" |  \" + Rainbow(\"$str_name\").bg(:$name) + \" |  \" + Rainbow(\"bright 明亮\").$name.bright"  >> $ruby_file
    done
}


# 分割符
function str_sp(){
    local str=$1
    str=$(zsh -c "echo \"\${(l.((\$COLUMNS - ${#str} - $2 )).._.)}\"")
    echo -e "\n\n\033[32;1m$1\033[30;1m$str\033[0m"
}


# getColor "$color_name_yaml" "$color_yaml"

[[ ! -f $color_rainbow ]] && getColor "$color_name_str" "$color_rainbow"
# getColor "$color_name_str" "$color_rainbow"


# str_sp "ColorLS配置颜色" 4
# ruby $color_yaml

str_sp "Rainbow颜色" 2
ruby $color_rainbow


