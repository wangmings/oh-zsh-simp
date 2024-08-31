
# fg : 前景颜色
# bg : 背景颜色
# hl : 高亮前景颜色
# fg : 高亮突出部分前景颜色
# bg+: 高亮突出部分背景颜色
# hl+: 高亮突出部分前景颜色
# hl+:underline:-1 设置下划线
# hl:0:reverse 翻转颜色

# query: 输入搜索颜色
# gutter: 侧边栏颜色
# header: 标题栏颜色
# info: 信息栏颜色
# pointer: 指针颜色
# marker: 标记颜色
# spinner: 旋转加载栏颜色
# header-fg: 标题栏前景颜色
# header-bg: 标题栏背景颜色
# border:边框颜色
# preview-bg 预览窗口的背景颜色设置
# --prompt fzf输入提示符





# zle -N searchHistory
# bindkey -M emacs 'L' searchHistory



# 搜索历史

searchHistory(){
    # say 1
    local color="--color=border:3,query:0,gutter:231,info:3,pointer:3,fg:4,hl:2,fg+:15,bg+:8,hl+:2"
    
    history| \
    awk '{for (i=2; i<=NF; i++) printf("%s ", $i); print ""}'| \
    sed '/^$/d'|sort|uniq| \
    fzf -0 $color --height 12 --layout=reverse --ansi --exact --multi --preview-window=':wrap:35:right' --preview '
        result={}
        echo {} > ~/.shistory.sh
        highlight -O ansi -W ~/.shistory.sh
        CURSOR=${#BUFFER}
        BUFFER+=$result
        # eval "$result"
    '
    

}






