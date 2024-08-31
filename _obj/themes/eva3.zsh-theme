# Author: wang ming
# Date: 2023-02-10
# Description: zsh主题配置


black=('%{\e[30m%}' '%{\e[90m%}')
red=('%{\e[31m%}' '%{\e[91m%}')
green=('%{\e[32m%}' '%{\e[92m%}')
yellow=('%{\e[33m%}' '%{\e[93m%}')
blue=('%{\e[34m%}' '%{\e[94m%}')
magenta=('%{\e[35m%}' '%{\e[95m%}')
cyan=('%{\e[36m%}' '%{\e[96m%}')
white=('%{\e[37m%}' '%{\e[97m%}')
line='%{\e[4:1m%}' 
end='%{\e[0m%}'
back='%{\e[40m%}'




# Git info
ZSH_THEME_GIT_PROMPT_PREFIX="$black[2] $blues[1] git:($red[2]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$end"
ZSH_THEME_GIT_PROMPT_DIRTY="$blues[1]) $magenta[2]✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$blues[1])"



line="$blue[1]\${(l.\$COLUMNS..-.)}$end"
info="$blue[1]$back $black[1]\ue635 $end $blue[1]%m $black[1]  $yellow[1]%n $green[1] "
paths="$black[1]{HOME} $black[1]%c$end"
git="\$(git_prompt_info)%(?,, code: $red[1]%?$end)"
input="$black[1]󰧚 $end"

# PSP="\n$line\n$info $paths $git \n$input"

PSP="%{\e[40m%}\ue635"



# 自动更新
update_prompt(){
  local PS
  [[ $PWD == $HOME ]] && icon=' ' || icon=' '
  PS=${PSP//\{HOME\}/"$icon"}
  # print -r $PS

  PROMPT=$(print "$PS")
  # RPROMPT="hello"
}

precmd_functions+=(update_prompt)






 











