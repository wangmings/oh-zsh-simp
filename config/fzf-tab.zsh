
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



export RUNEWIDTH_EASTASIAN=0
export FZF_DEFAULT_OPTS="--height 12 --layout=reverse --history=$ZSH_SIMP_CACHE/fzfhistory"



# 231白色
# export FZF_DEFAULT_OPTS="--color=query:0,fg+:201,bg+:226,hl+:20 $FZF_DEFAULT_OPTS"

export FZF_DEFAULT_OPTS="--color=query:0,gutter:231,info:3,pointer:3,fg:4,hl:2,fg+:15,bg+:8,hl+:2 $FZF_DEFAULT_OPTS"

# export FZF_DEFAULT_OPTS="--color=query:0,gutter:231,info:9,pointer:9,hl:2,fg+:20,bg+:250,hl+:2 $FZF_DEFAULT_OPTS"
export FZF_DEFAULT_commandNum="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"
export FZF_PREVIEW_commandNum='bash $ZSH_SIMP/lib/file_preview.sh {}'


# zstyle ':completion:*:descriptions' format "[%d]"

zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*:*:*:*:processes' commandNum "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[ "$group" = "process ID" ] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:yay:*' fzf-preview 'yay -Qi $word || yay -Si $word'
zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'pacman -Qi $word || pacman -Si $word'
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '[ -f "$realpath" ] && git diff --color=always $word || git log --color=always $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=12



export LESSOPEN='| bash $ZSH_SIMP/lib/file_preview.sh %s'


