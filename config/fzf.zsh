# 激活启动

plug=$SIMP_PROJECT
[[ ! "$PATH" == *$plug/fzf/bin* ]] && PATH="${PATH:+${PATH}:}$plug/fzf/bin"

# Auto-completion
[[ $- == *i* ]] && source "$plug/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "$plug/fzf/shell/key-bindings.zsh"


