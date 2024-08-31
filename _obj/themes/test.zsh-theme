# Author: wang ming
# Date: 2023-02-10
# Description: zsh主题配置



# 十六进制颜色转换成RGB颜色数值: 
# 参数1: 前景色 -f，背景色 -b, 参数2:输出颜色 -c  
HEX_RGB_NUM(){
  local R G B C S=38 H=$1
  [[ $2 == '-b' ]] && S=48 || S=38
  R=$((16#${H:1:2}))
  G=$((16#${H:3:2}))
  B=$((16#${H:5:2}))
  C="$S;2;$R;$G;$B"m
  [[ $3 == '-c' ]] && print "\e[$C Hello World" || print -r "\e[$C"
}




# 将十六进制转换成RGB颜色数
GET_RGB_NUM(){
  local H G S=$1 
  for H in $(echo "$S"|grep -oE "#[0-9a-fA-F]{6}"|sort|uniq);do
    G=$(HEX_RGB_NUM "$H")
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









CF="
'#00aba9  #2d89ef%m' 
'#00aba9  #ff0097%n'
'#4169E1  #66757F%c' 
'#FBBC05  #66757F%c'    
'#292F33'
'#e3a21a'
"


TS="
'#DB7093'
'#00A1F1'
'#FFBB00'
'#F65314'
"



ANSI="\e[4:1;3m \e[92m \e[0m \e[1m"

CREATE_ARRAY 'CF' $CF
CREATE_ARRAY 'TS' $TS
CREATE_ARRAY_S 'ANSI' $ANSI
END=$ANSI[3]




# Git info
ZSH_THEME_GIT_PROMPT_PREFIX="$ANSI[4]$TS[2] git:($TS[1]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$END"
ZSH_THEME_GIT_PROMPT_DIRTY="$TS[2]) $TS[4]✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$TS[2])"



WEZ_PIPE='/tmp/wezterm'
echo '78' > $WEZ_PIPE
cat $WEZ_PIPE >/dev/null 2>&1



split_char(){
  # set -x  # 开启调试模式

  local cols=$(cat $WEZ_PIPE)

  (( $COLUMNS < $cols )) && print '\e[3A\e[K'

  echo $COLUMNS > $WEZ_PIPE

  echo "${(l.$COLUMNS..-.)}"
}






GIT_INFO='$(git_prompt_info)'
EXIT_CODE="%(?,, code: $TS[3]%?$END)"
STATE="$GIT_INFO$EXIT_CODE"
INPUT="$CF[6] $END"
SPLIT='$(split_char)'

PSP="\n$SPLIT\n$ANSI[1]$CF[1] $CF[2] $CF[5]  {HOME}$END$STATE \n$INPUT"

# print -r "$PSP"
# echo "$PSP"





# 自动更新
update_prompt(){
  local PS
  [[ $PWD == $HOME ]] && HOME_PATH=$CF[3] || HOME_PATH=$CF[4]
  PS=${PSP//\{HOME\}/"$HOME_PATH"}
  # print -r $PS
  # print $COLUMNS

  PROMPT=$(print "$PS")
  # RPROMPT="hello"
}

precmd_functions+=(update_prompt)






 











