# Author: wang ming
# Date: 2023-02-10
# Description: 颜色解析
# 说明: zsh主题使用十六进制颜色，解析成RGB颜色来使用






# 调色板
palette(){

  local tmp tmpz num code names tmpc_all tmps_all color_char color_name
  
  tmpc_all=''
  tmps_all=''

  color_char=(黑色 红色 绿色 黄色 蓝色 紫色 青色 白色)
  color_name=(black red green yellow blue magenta cyan white)

  tmp='\e[3{NUM}m {NAME}  3{NUM}  \e[0m \e[4{NUM}m %F{231}  4{NUM}   \e[0m \e[9{NUM}m {NAME} 9{NUM} \e[0m |'
  tmpz='\e[3{NUM}m{NAME}   {NAMES} \e[0m \e[4{NUM}m %F{231}  {NAMES}\e[0m |'

  for n in {1..8};do
    (( num = n - 1 ))

    name=${color_char[$n]}
    code=${color_name[$n]}
    names=$(printf "%-8s" $code)

    tmps=${tmp//\{NUM\}/"$num"}
    tmps_all+="${tmps//\{NAME\}/$name}\n"

    tmpc=${tmpz//\{NUM\}/"$num"}
    tmpc=${tmpc//\{NAME\}/"$name"}
    tmpc_all+="${tmpc//\{NAMES\}/"$names"}\n"
      
  done


  tmp=$(paste -d " " <(echo -e "$tmps_all") <(echo -e "$tmpc_all"))
  echo ""
  print "\e[34;1mASCII 前景    背景     明亮    | ZSH    前景        背景\e[0m"
  # print "\e[34;1mZSH  前景色     背景色      | ASCII  前景色  背景色   明亮色\e[0m"
  print -P "$tmp"
  
 
}


# 调色板256颜色
palette256(){
  echo -e "\n\e[32;1m256 颜色\n"
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done

}







# 十六进制颜色转换成RGB颜色数值: 
# 参数一: #ffa500
# 参数二: 前景色: -f，背景色: -b, RGB数: -n 
# 参数三: 输出格式: -c 
# ANSI转义print格式: \e[38;2;255;165;0m
# ANSI转义echo格式: \033[38;2;255;165;0m
HEX_RGB(){
  local R G B N RGB S=38 H=$1
  [[ $2 == '-b' ]] && S=48 || S=38
  R=$((16#${H:1:2}))
  G=$((16#${H:3:2}))
  B=$((16#${H:5:2}))
  RGB="$R;$G;$B"
  [[ $2 == '-n' ]] && print "$R $G $B" && return
  [[ $3 == '-c' ]] && print "\e[$S;2;${RGB}m Hello World \e[0m" || print -r "\e[$S;2;${RGB}m" && return

}






# RGB颜色数值转换十六进制颜色
RGB_HEX(){
  printf "#%02x%02x%02x\n" $1 $2 $3
}





# 将十六进制转换成RGB颜色数: 
# zsh主题格式: %{\e[38;2;255;165;0m%}
GET_RGB_NUM(){
  local H G S=$1 
  for H in $(echo "$S"|grep -oE "#[0-9a-fA-F]{6}"|sort|uniq);do
    G=$(HEX_RGB "$H")
    S=${S//$H/"%{$G%}"}
  done
  print -r "$S"
}




# 创建数组: 参数1: 数组名
CREATE_ARRAY(){
  local name=$1
  eval "$name=($(GET_RGB_NUM $2))"
}


# 创建数组: 参数1: 数组名
CREATE_ARRAY_S(){
  local name=$1 ansi=$2
  ansi=${ansi//\\/'\\'}
  ansi=${ansi//\ /'\n'}
  ansi=$(echo -e "$ansi"|sed '/^$/d;s/^/"%{/g;s/$/%}"/g;s/ //g;')
  eval "$name=($ansi)"
}


