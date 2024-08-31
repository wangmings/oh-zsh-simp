#!/bin/bash

fifo_server="/tmp/fifo_server"
fifo_client="/tmp/fifo_client"
timeout_duration=10  # 设置超时时间（秒）

# 创建命名管道的函数
create_fifo() {
    local fifo="$1"
    if [ ! -p "$fifo" ]; then
        if ! mkfifo "$fifo"; then
            echo "failed to create FIFO: $fifo"
            exit 1
        fi
    fi
}

# 创建所需的命名管道
create_fifo "$fifo_server"
create_fifo "$fifo_client"

# 打开文件描述符，并设置为非阻塞模式
exec 3<>"$fifo_server"

# 监控文件描述符的输入
while true; do
    if read -r message <&3; then
        # 解码数据
        message=$(echo "$message" | base64 --decode)
        # echo "Received message: $message"

        output="script running in the background!"
        option=$(echo "$message" | awk '{print $1}')
        message=${message/$option\ /}

        case $option in
            # 后台运行脚本
            "-b") bash -c "$message"& ;;
            
            # 使用超时机制执行命令，并将输出同时写入 fifo_server 和标准输出
            "-c") output=$(timeout "$timeout_duration" bash -c "$message" 2>&1) ;;
        esac

        if [[ $? -eq 124 ]]; then
            # echo "Command timeout or blocking: $message"
            echo "command timeout or blocking!" | base64 > "$fifo_client"
        else
            if (( ${#output} > 0 )); then
                # echo "$output"
                # 编码数据
                output=$(echo -e "$output" | base64)
                echo "$output" > "$fifo_client"
            fi
        fi
    fi
done

# 关闭文件描述符
exec 3>&-
