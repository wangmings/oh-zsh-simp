# Author: wang ming
# Date: 2023-01-24
# Description: 命令简写配置



# 查看自定义开机守护进程任务
alias laun="$SIMP_COMMAND/launchctl/service.sh"

# grep只显示匹配到的内容
# alias grep="grep "$1"|grep -v 'grep'"

# 创建文件
alias ff="touch"

# w2命令重用
alias w2="$SIMP_COMMAND/whistle/w2.sh"


# github库管理
alias gits="$SIMP_COMMAND/github/gits.sh"


# 命令行打开vscode
alias code="open -a /Applications/Visual\ Studio\ Code.app"
alias text="/Users/mac/oh-zsh-simp/_obj/command/shell/text.sh"


# 查看文件大小
alias fs="du -sh"

# logo-ls替换ls
alias lss="colorls"

# 输出Noto Fonts icons
alias icon="$SIMP_PROJECT/colorls/colorls-1.4.6/color-zsh/icons/icon.sh"

# 微信双开
alias wx="nohup /Applications/WeChat.app/Contents/MacOS/WeChat /dev/null 2>81 &"





