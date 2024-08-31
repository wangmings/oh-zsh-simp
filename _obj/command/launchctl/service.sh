#! /bin/bash

# launchctl任务查看
# 启动守护进程

# 参考示例
# launchctl list | grep "boot-shutdown"
# launchctl load -w ~/Library/LaunchAgents/com.boot.shutdown.plist
# launchctl unload ~/Library/LaunchAgents/com.boot.shutdown.plist


# 获取当前路径
path=$(cd `dirname $0`; pwd)


help="
启动守护进程:
\e[32m    
[launchctl: 查看任务]

    0 --- 查看所有服务
    1 --- 查看用户服务
    2 --- 启动用户服务
    3 --- 关闭用户服务
    4 --- 安装用户服务
    5 --- 卸载用户服务
    6 --- 退出
    
\e[0m    
"

printf "$help"



plistPath=$(bash $path/install.sh -path)
plistName=$(bash $path/install.sh -name)


while true; do

    echo ""
    read -p "输入序号: " input

    case $input in

        0) 
            printf "\n\e[32m查看所有服务: \e[0m\n\n"
            launchctl list
        ;;

        1) 
            printf "\n\e[32m查看用户服务: $plistName \e[0m\n"
            loadOK=$(launchctl list | grep "users")
            if (( ${#loadOK} > 0 ));then
                echo "$loadOK"
            else
                echo "没有启动的服务..."
            fi
        ;;

        2) 
            printf "\n\e[32m启动用户服务: $plistName \e[0m\n"
            launchctl load $plistPath && echo "已经启动($plistName)服务"
        ;;

        3) 
            printf "\n\e[32m关闭用户服务: $plistName \e[0m\n"
            launchctl unload $plistPath >/dev/null 2>&1
            echo "已经关闭($plistName)服务"
        ;;


        4) 
            printf "\n\e[32m安装用户服务: $plistName \e[0m\n"
            bash $path/install.sh && echo "已经安装($plistName)服务"

        ;;


        5) 
            printf "\n\e[32m卸载用户服务: $plistName \e[0m\n"
            rm -rf $plistPath && echo "已经卸载($plistName)服务"

        ;;


        6)   
            echo '退出'
            break
        ;;



        *)  
            echo "ERR:不存在这个服务..." 
            break
        ;;


    esac


done








