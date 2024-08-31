


# 验证sudo密码
function verifyPassword() {
    sudo -k; echo $1|sudo -lS &>/dev/null
    (( $? == 0 )) && echo 'true'
}










# 设置代理IP端口
function proxy(){

    local proxyIP='127.0.0.1:8899'
    local IP=${proxyIP//\:/\ }
    

    local pass=$(verifyPassword '0000')

    if [[ $pass == 'true' ]]; then

        if [[ $1 == 'start' ]]; then
            echo -e "启动系统代理:  http://$proxyIP\n"             
            sudo networksetup -setwebproxy 'Wi-Fi' $IP
            sudo networksetup -setsecurewebproxy 'Wi-Fi' $IP

        else
            echo -e "关闭系统代理:  http://$proxyIP\n"
            sudo networksetup -setwebproxystate 'Wi-Fi' off
            sudo networksetup -setsecurewebproxystate 'Wi-Fi' off

        fi

    else
        echo "密码验证失败!"
        exit;
    fi 


}









# 监听: SIGINT 进程终端, CTRL+C
function monitor() {
    echo ''
    proxy end
}






# -------------------------[[ 执行 ]]--------------------------->



# 获取whistle代理启动状态
whistleState=$(ps -e|grep "bootstrap.js"|grep -v "grep"|wc -l|sed 's/\ //g')
printf "\nwhistle运行状态:  $whistleState  "






if [[ $1 == 'run' ]]; then

    if (( $whistleState == 0 ));then
        proxy start
        trap monitor SIGINT
        command w2 $*
    else
        echo "whistle: 代理服务已启动!"
    fi

elif [[ $1 == 'start' ]]; then

    if (( $whistleState == 0 ));then
        proxy start
        command w2 $*
    else
        echo "whistle: 代理服务已启动!"
    fi


elif [[ $1 == 'stop' ]]; then

    proxy end
    
    if (( $whistleState > 0 ));then
        command w2 $*
    else
        echo "whistle: 代理服务没有启动!"
    fi



elif [[ $1 == 'help' ]]; then

    echo "
whistle: 代理服务
前台启动: w2 run
后台启动: w2 start
关闭后台: w2 stop
查看帮助: w2 help
    "

else
    command w2 $*
    
fi















