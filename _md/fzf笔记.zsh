# 学习笔记


fzf-tab-complete() {

    bash $ZSH_SIMP/lib/get_cursor.sh
    local -i _ftb_continue=1 _ftb_continue_last=0 _ftb_accept=0 ret=0
    local code=$(cat $ZSH_SIMP/lib/file_preview_1.sh)
    echoti civis >/dev/tty 2>/dev/null

    while (( _ftb_continue )); do
        _ftb_continue=0
        local IN_FZF_TAB=1
        {
            local result commandNum inputNum inputChar
            # echo "$BUFFER $MARK $CURSOR" > ~/cc.txt

            inputNum=$(echo $BUFFER|awk '{print NF}')
            commandNum=$(compgen -c|grep "^$BUFFER"|wc -l)


            if (( $inputNum > 1 || $commandNum == 0 ));then
                
                if (( $inputNum > 1 ));then 
                    inputChar=$(echo $BUFFER|awk '{print $NF}')
                    result=$(logo-ls -1|fzf -0 --ansi --exact --multi --preview "$code" --query "$inputChar") 
                else    
                    result=$(logo-ls -1|fzf -0 --ansi --exact --multi --preview "$code")
                fi

                result=$(echo "$result"|xxd -p|awk -F 'e2a080' '{print $2}'|xxd -r -p)
                result=$(echo "$result"|sed "s/ *$//g")

                if [[ -n $result ]]; then
                    [[ -n $inputChar ]] && BUFFER=${BUFFER/$inputChar/}
                    BUFFER+=$result
                    CURSOR=${#BUFFER}
                
                fi

            else
                # say 2
                # complete-word
                # delete-char-or-list
                # expand-or-complete
                # expand-or-complete-prefix
                # list-choices
                # menu-complete
                # menu-expand-or-complete
                # reverse-menu-complete
                # zle .fzf-tab-orig-$_ftb_orig_widget
                # echo "66 $ZLE_LINE" > ~/cc.txt
                zle expand-or-complete

            fi

            ret=$?
        } always {
            IN_FZF_TAB=0
        }

        if (( _ftb_continue )); then
            say 12
            zle .split-undo
            zle .reset-prompt
            zle -R
            zle fzf-tab-dummy
        fi
    done

    echoti cnorm >/dev/tty 2>/dev/null
    zle .redisplay
    (( _ftb_accept )) && zle .accept-line

    return $ret
}




zle -N fzf-tab-complete
bindkey -M emacs '^I' fzf-tab-complete
bindkey -M viins '^I' fzf-tab-complete











# fzf-tab文件显示

file_path=$(echo {}|xxd -p|awk -F "e2a080" "{print \$2}"|xxd -r -p)
file_path=$(echo "$file_path"|sed "s/ *$//g")
file_path=${file_path%\*}

if [[ -f $file_path || -d $file_path ]];then
    file_type=$(file -bL --mime-type $file_path)
else
    printf "\e[36m错误提示:\e[0m\n文件不存在!\n可能是文件名或者路径有问题!\n文件:$file_path"
    exit 0
fi


case $file_type in
    "image"*)
        cat $file_path
    ;;
    "video"*)
        echo "$file_path is a video file."
    ;;
    "text"*|"application"*)
        (highlight -O ansi -j 0 -l $file_path || cat $file_path) 2> /dev/null
        # (bat -p --color=always $file_path || cat $file_path) 2>/dev/null | head -1000
    ;;
    "inode/directory")
        logo-ls -1 $file_path
    ;;
    
    *)
        echo "$file_path is a other type of file."  
    ;;
esac
