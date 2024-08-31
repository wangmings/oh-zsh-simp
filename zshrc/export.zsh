# Author: wang ming
# Date: 2023-01-24
# Description: 设置全局变量

# 设置系统语言是中文
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8


# 关闭bash的提示:`chsh -s /bin/zsh` 
export BASH_SILENCE_DEPRECATION_WARNING=1

# 添加meag-cmd命令
export PATH=$PATH:/Applications/MEGAcmd.app/Contents/MacOS



# 配置ruby
export PATH=$PATH:/usr/local/opt/ruby/bin
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"






# pnpm
export PNPM_HOME=~/Library/pnpm
export PATH=$PATH:$PNPM_HOME
# pnpm end




# esp编译工具配置
export PATH=$PATH:~/esp/xtensa-lx106-elf/bin
export IDF_PATH=~/esp/ESP8266_RTOS_SDK
#export NODE_OPTIONS=--max_old_space_size=8000



# java环境变量设置
export JAVA_HOME=~/Library/Java/JavaVirtualMachines/corretto-1.8.0_342/Contents/Home
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:



# android studio SDK工具箱: adb命令 
# 下载地址: https://developer.android.google.cn/studio/releases/platform-tools
export PATH=$PATH:~/Library/Android/sdk/platform-tools




# python Pyenv包管理工具配置
export ARCHFLAGS="-arch x86_64"
export PATH=$PATH:~/.pyenv/shims:~/Library/Python/3.8/bin
python(){ eval "$(pyenv init --path)"; eval "$(pyenv init -)"; command python $*}




# nodejs NVM包管理工具配置
# export NVM_DIR=~/.nvm
# export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
# export PATH=$PATH:$NVM_DIR/versions/node/v16.13.2/bin
# nvm(){ . "$NVM_DIR/nvm.sh" ; nvm $@ ; }




# nvm
# 加载并配置 nvm
loads_nvm() {
    # 设置变量和环境
    local default
    export NVM_DIR="$HOME/.nvm"
    local nvm_loaded=0  # 标志是否已经加载了 nvm

    # 加载提示代码补全 
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  

    # 设置默认版本
    if ! command -v node &> /dev/null; then
        default="$NVM_DIR/alias/default"
        if [ -s "$default" ]; then
            # 如果默认版本文件存在，则将其添加到 PATH 中
            export PATH=$PATH:"$NVM_DIR/versions/node/$(< "$default")/bin"
        else
            # 如果默认版本文件不存在，则输出警告信息
            echo "Node.js not found. Please make sure Node.js is installed or set a default version."
        fi
    fi

    # 定义并重载 nvm 命令 
    nvm() {
        if (( nvm_loaded == 0 )); then
            # 如果尚未加载 nvm，则加载 nvm 并标记已加载
            \. "$NVM_DIR/nvm.sh"
            nvm_loaded=1
        fi
        nvm "$@"
    }
}

# 调用函数以加载并配置 nvm
loads_nvm




# Homebrew包管理器相关设置:
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_NO_INSTALL_CLEANUP=true
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles








































