# Author: wang ming
# Date: 2024-08-31
# Description: zsh入口配置脚本

_init_cache(){
    
    export ZSH_SIMP_CACHE="$HOME/.oh-zsh-simp/cache"
    if [[ ! -d $ZSH_SIMP_CACHE ]]; then
        mkdir -p $ZSH_SIMP_CACHE
    fi

}



_init_zsh_simp() {


    export ZSH_SIMP=$(cd $(dirname $1);pwd)

    # 设置项目路径
    export SIMP_ZSHRC="$ZSH_SIMP/_obj/zshrc"
    export SIMP_THEMES="$ZSH_SIMP/_obj/themes"
    export SIMP_PROJECT="$ZSH_SIMP/_obj/project"
    export SIMP_COMMAND="$ZSH_SIMP/_obj/command"

    export SIMP_PLUGINS="$ZSH_SIMP/plugins"
    export SIMP_CONFIG="$ZSH_SIMP/config"


    # 自定义PATH
    export PATH="\
        $PATH:\
        $SIMP_PROJECT/zellij/bin:\
        $SIMP_PROJECT/iterm2:\
        $SIMP_PROJECT/colorls/ruby/bin:\
        /Applications/WezTerm.app/Contents/MacOS\
    "




    # 设置ColorLS的主题
    export ColorLS_THEME="logo"
    export GEM_PATH="$SIMP_PROJECT/colorls/ruby"

    # 设置Zellij的配置目录
    export ZELLIJ_CONFIG_DIR="$SIMP_PROJECT/zellij"



    # 引入核心文件
    source $ZSH_SIMP/lib/zsh-core.sh

    # 查看当前终端颜色命令：palette 、HEX_RGB
    source $ZSH_SIMP/_obj/colors/color.zsh


    
    # 激活ZSH插件
    source $SIMP_PLUGINS/extract/extract.plugin.zsh
    source $SIMP_PLUGINS/fzf-tab/fzf-tab.zsh
    source $SIMP_PLUGINS/z.lua/z.lua.plugin.zsh
    source $SIMP_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $SIMP_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # source $SIMP_PLUGINS/zsh-incr/incr.zsh


    # 激活自带配置：问题
    source $SIMP_CONFIG/git.zsh
    source $SIMP_CONFIG/hook.zsh
    source $SIMP_CONFIG/fzf-tab.zsh
    source $SIMP_CONFIG/fzf.zsh
    source $SIMP_CONFIG/history.zsh

    # 激活自定义ZSHRC配置
    source $SIMP_ZSHRC/alias.zsh
    source $SIMP_ZSHRC/export.zsh
    source $SIMP_ZSHRC/func.zsh





    # 激活starship主题
    eval "$(starship init zsh)"

    # 激活ruby的包管理工具
    eval "$(rbenv init -)"


}

_init_cache
_init_zsh_simp $0