#!/bin/bash

# 脚本说明:
# 开机时切换到独立显卡
# 开机时关闭睡眠

# pmset: 使用请查看以下网站
# https://sspai.com/post/61379
# https://blog.csdn.net/weixin_41103006/article/details/113539487
# https://www.jianshu.com/p/976b74e56e4b



# 获取执行路径
path=$(cd `dirname $0`; pwd)



# trap: 监听指定信号量 触发命令或者函数
shutdown() {
    printf "
    gpu-task-run: gpu-launchd(关机|任务关闭)
    My-Launchd-Logs: -------------------------- [END]
    "|sed 's/^[ \t]*//; /^$/d'

    echo ""
    
    exit 0
}






# 启动时运行设置
startup() {

    echo "
    gpu-task-run: gpu-launchd(开机|任务启动)
    "|sed 's/^[ \t]*//; /^$/d'


    # 切换到独立显卡
    echo $1|sudo -S pmset -a gpuswitch 0 && sudo pmset -a gpuswitch 1
    
    # 关闭睡眠
    sudo pmset -a disablesleep 1
    # sudo pmset -a disablesleep 1 && sudo pmset -a disablesleep 0
    
    tail -f /dev/null&
    # $!: 表示上个子进程的进程号，wait等待一个子进程结束后，退出
    wait $!

}





# -------------- main -----------------
trap shutdown SIGTERM
trap shutdown SIGKILL
startup '0000'







