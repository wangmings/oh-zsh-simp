zmodload -i zsh/complist

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*:*:*:*:*' menu select 
zstyle ':completion:*:*:*:*:*' list-colors '=(#b) #([0-9]#)*=38;5;4:([0-9a-z-]#)*=38;5;246'


autoload -Uz compinit 
zle -N self-insert self-input-char
zle -N self-delete-char
zle -N self-tab-choice
zle -N self-input-char
compinit



bindkey -M emacs ' ' self-input-char
bindkey -M emacs '^h' self-delete-char
bindkey -M emacs '^?' self-delete-char
bindkey -M emacs '^i' self-tab-choice
bindkey -M viins '^i' self-tab-choice








# 输入字符触发
self-input-char(){
 
    if zle .self-insert; then
        # echo "$BUFFER $MARK $CURSOR" > ~/cc.txt
        if (( $#BUFFER > 1 ));then
		    zle expand-or-complete
            if [[ ${BUFFER: -1} == '/' ]];then
                zle expand-or-complete
            fi
        fi
	fi
    
}






# 删除字符触发
self-delete-char(){
    if zle vi-backward-delete-char; then
        zle -M ""
	fi
}





# Tab键选择命令
self-tab-choice(){
    zle expand-or-complete-prefix
}




