# Author: wang ming
# Date: 2023-02-10
# Description: zsh主题配置





CF="
'#00aba9  #2196f3%m' 
'#1E90FF  #e91e63%n'
'#4169E1  #4a4543%c' 
'#ff9800  #4a4543%c'    
'#292F33'
'#e3a21a'
"






TS="
'#DB7093'
'#00A1F1'
'#FFBB00'
'#F65314'
'#ff9800'
'#292F33'
"



ANSI="\e[4:1m \e[92m \e[0m \e[1m \e[3m"

CREATE_ARRAY 'CF' $CF
CREATE_ARRAY 'TS' $TS
CREATE_ARRAY_S 'ANSI' $ANSI
END=$ANSI[3]
SP="$TS[5]$ANSI[1]"



# Git info
ZSH_THEME_GIT_PROMPT_PREFIX="$ANSI[4]$TS[6]  $TS[2]git:($TS[1]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$END"
ZSH_THEME_GIT_PROMPT_DIRTY="$TS[2]) $TS[4]✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$TS[2])"




GIT_INFO='$(git_prompt_info)'
EXIT_CODE="%(?,, code: $TS[3]%?$END)"
STATE="$GIT_INFO$EXIT_CODE"
INPUT="$CF[6] $END"
SPLIT="$SP\${(l.\$COLUMNS.. .)}$END"

PSP="\n$SPLIT\n$CF[1] $CF[2] $CF[5]  {HOME}$END$STATE \n$INPUT"

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






 











