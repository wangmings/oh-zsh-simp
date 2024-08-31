# Author: wang ming
# Date: 2023-02-10
# Description: zsh主题配置






# 自动执行
function update_prompt(){

  local ansi git_info exit_code icons fonts homeIcon K  hostName userName dirPath inputIcon PS


  # Git info
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} git:(%{$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[green]%}✗"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  git_info='$(git_prompt_info)'
  exit_code="%(?,,CODE:%{$fg[red]%}%?%{$reset_color%})"

  ansi=(
    '\e[4:2m'
    '\e[92m'
  )

  icons=(
    '%{$fg[blue]%} '
    '%{$fg[blue]%} '
    '%{$fg[blue]%} '
    '%{$fg[yellow]%} '
    '%{$fg[yellow]%} '
    '%{$fg[green]%} '
    # '%{$terminfo[blink]$fg[black]%} '
  )

  fonts=(
    '%{$fg[cyan]%}%m'
    "%{$ansi[2]%}%n"
    '%{$fg[cyan]%}%~'
    '%{$fg[cyan]%}%c'
  )


  homeIcon=${icons[4]}
  [[ "$PWD" == "$HOME" ]] && homeIcon="${icons[3]}"

  K='%{$reset_color%}'
  hostName="\n$icons[1] $fonts[1]"
  userName="$icons[2] $fonts[2]"
  dirPath="$homeIcon $fonts[4]"
  inputIcon="\n$icons[5]"
 
 
  
  

  PS="$ansi[1]$hostName $userName $icons[6] $dirPath $K$git_info$exit_code $inputIcon$K"
  # echo -e "$PS"
  # echo $userName

  # RPROMPT="${icons[2]}"
  PROMPT=$(echo -e "$PS")



}


precmd_functions+=(update_prompt)

