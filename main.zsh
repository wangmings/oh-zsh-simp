# Author: wang ming
# Date: 2024-08-31
# Description: zsh入口配置脚本

_init_zsh_simp() {


    local simp=$(cd $(dirname $1);pwd)

    # 设置项目路径
    local colors="$simp/_obj/colors"
    local themes="$simp/_obj/themes"
    local project="$simp/_obj/project"
    local command="$simp/_obj/command"

    local plugins="$simp/plugins"
    local config="$simp/config"
    local zshrc="$simp/zshrc"


    # 自定义PATH
    local paths="\
        $project/zellij/bin:\
        $project/iterm2:\
        $project/colorls/ruby/bin:\
        /Applications/WezTerm.app/Contents/MacOS"

    # 设置PATH
    export ZSH_SIMP=$simp
    export SIMP_COMMAND=$command
    export SIMP_PROJECT=$project
    export PATH="$PATH:$paths"


    # 设置ColorLS的主题
    export ColorLS_THEME="logo"
    export GEM_PATH="$project/colorls/ruby"

    # 设置Zellij的配置目录
    export ZELLIJ_CONFIG_DIR="$project/zellij"



    # 引入核心文件
    source $simp/lib/zsh-core.sh

    # 查看当前终端颜色命令：palette 、HEX_RGB
    source $colors/color.zsh


    
    # 激活ZSH插件
    source $plugins/extract/extract.plugin.zsh
    source $plugins/fzf-tab/fzf-tab.zsh
    source $plugins/z.lua/z.lua.plugin.zsh
    source $plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # source $plugins/zsh-incr/incr.zsh


    # 激活自带配置：问题
    source $config/git.zsh
    source $config/hook.zsh
    source $config/fzf-tab.zsh
    source $config/fzf.zsh
    source $config/history.zsh

    # 激活自定义ZSHRC配置
    source $zshrc/alias.zsh
    source $zshrc/export.zsh
    source $zshrc/func.zsh





    # 激活starship主题
    eval "$(starship init zsh)"

    # 激活ruby的包管理工具
    eval "$(rbenv init -)"


}


_init_zsh_simp $0