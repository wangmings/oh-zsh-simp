#!/bin/bash


fifo_server="/tmp/fifo_server"
fifo_client="/tmp/fifo_client"
fifo_timeout=10  # 设置超时时间（秒）



# 清除文件描述符
cleanup() {
    exec 4>&-
    exit 0
}



main_exec() {

    local option=$1
    local string=$2

    if (( ${#string} > 0 )); then

        # 编码数据
        encoded_data=$(echo -e "$option $string" | base64)
        
        # 发送编码后的数据
        echo "$encoded_data" > "$fifo_server"

        # 打开文件描述符，并设置为非阻塞模式
        exec 4<>"$fifo_client"

        # 捕捉终止信号以清理资源
        trap cleanup SIGINT SIGTERM

        # 监控文件描述符的输入
        while true; do
            if read -r -t "$fifo_timeout" message <&4; then
                if (( ${#message} > 0 )); then
                    message=$(echo "$message" | base64 --decode)
                    echo "$message"
                    cleanup
                fi
            else
                echo "command timeout or blocking!"
                cleanup
            fi
        done
    fi
}




# 检测服务端是否启动
is_server=$(ps -ef|grep -v grep|grep server.sh|wc -l|awk '{print $1}')
if (( $is_server == 0 )); then
    echo "server.sh is not running!"
    exit 1
fi




main_exec "$@"

# while getopts ":b:c" opt; do
#     case ${opt} in
#         b) shift; main_exec "$@" ;;   
#         c) shift; main_exec "" ;;  
#     esac
# done