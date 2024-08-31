# Author: wang ming
# Date: 2023-01-24
# Description: 通过函数定义简写命令配置



zellij(){
    command zellij $*
    clear
}


# 清除homebrew: brew下载缓存
unbrew(){

    load logs caches clears
    logs=~/Library/Logs/Homebrew 
    caches=~/Library/Caches/Homebrew
    
    printf "Homebrew: 查看缓存文件大小"
    du -sh $logs $caches
    printf "\n清理缓存文件输入: [y,yes] " && read clears
    
    if [[ $clears == 'yes' || $clears == 'y' ]]; then
        brew cleanup
        rm -rf $caches/*
        printf "清理缓存文件成功!"
    else
        printf "不清理缓存文件!"
    fi
}



_ascii_code(){
    # echo -e "\e[94m$(figlet -f slant "Eav  $1  zsh")\e[0m"
    figlet -f slant " Eav  $1  zsh"
}


