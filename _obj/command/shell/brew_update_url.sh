
# brew包管理器下载包时卡死，或者其他问题!
# 问题: 一直提示Running `brew update --auto-update`...
# 解决: 更新brew下载源
# 参考地址: https://blog.csdn.net/CaptainJava/article/details/109132783

# 名称               说明
# brew              Homebrew 源代码仓库
# homebrew-core     Homebrew 核心软件仓库
# homebrew-bottles  Homebrew 预编译二进制软件包
# homebrew-cask     提供 macOS 应用和大型二进制文件



RUN=false

case $1 in

    '-a')
        # 阿里源: brew|homebrew-core|homebrew-cask源|brew bintray镜像
        git -C "$(brew --repo)" remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git
        git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-cask.git
        git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git
        echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.zshrc
        RUN=true
    ;;


    '-z')
        # 中科源: brew|homebrew-core| homebrew-cask源|brew bintray镜像
        git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
        git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
        git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
        echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew/homebrew-bottles' >> ~/.zshrc
        RUN=true
    ;;


    '-q')
        # 清华源: brew|homebrew-core| homebrew-cask源|brew bintray镜像
        git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
        git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
        git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
        echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
        RUN=true
    ;;


    '-g')
        # 官方源: brew|homebrew-core| homebrew-cask源|brew bintray镜像
        git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
        git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
        git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask
        echo "
        export HOMEBREW_BOTTLE_DOMAIN=''
        export HOMEBREW_NO_AUTO_UPDATE=true
        export HOMEBREW_NO_INSTALL_CLEANUP=true
        " >> ~/.zshrc

        RUN=true
    ;;


    '-r')
        # 查看设置的brew下载源
        printf "
        # 查看brew.git 当前源
        \e[32m`cd "$(brew --repo)" && git remote -v`\e[0m

        # 查看homebrew-core.git 当前源
        \e[32m`cd "$(brew --repo homebrew/core)" && git remote -v`\e[0m

        # 查看homebrew-cask.git 当前源
        \e[32m`cd "$(brew --repo homebrew/cask)" && git remote -v`\e[0m
        
        "|sed 's/^[ \t]*//g'

    ;;



    '-d')
        # 清空brew下载缓存
        echo "清空brew下载缓存..."
        rm -rf ~/Library/Caches/Homebrew/downloads/*
    ;;


    *)  
        echo "
        更换 [brew] 下载源:
            -a 阿里源
            -q 清华源
            -z 中科源
            -g 官方源
            -r 查看源
            -d 清空下载缓存
        "

        exit
    ;;


esac






if [[ $RUN == 'true' ]];then

    # 默认清理下载缓存
    rm -rf ~/Library/Caches/Homebrew/downloads/*

    printf "
    # 手动激活或者重新启动终端
    source ~/.zshrc

    # 更新brew包
    brew update
    
    "

fi

