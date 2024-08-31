#!/bin/bash
# 说明：Sublime Text3编辑器
# 作用：在终端通过自定义命令打开文件或目录，并创建不存在的文件或目录

# 检查是否提供了参数
if (( $# > 0 )); then
    files=()
    creation_files=()

    # 遍历参数，区分存在的文件/目录与需要创建的文件/目录
    for arg in "$@"; do
        if [[ -e $arg ]]; then
            files+=("$arg")
        else
            creation_files+=("$arg")
        fi
    done

    # 创建不存在的文件或目录
    if (( ${#creation_files[@]} > 0 )); then
        echo "以下文件或目录不存在: ${creation_files[*]}"
        echo "是否创建这些文件或目录？[创建输入：yes,y] [不创建：任意键]"
        read -r input

        if [[ $input == "yes" || $input == "y" ]]; then
            for item in "${creation_files[@]}"; do
                if [[ $item == *.* ]]; then
                    touch "$item"
                else
                    mkdir -p "$item"
                fi
                files+=("$item")
            done
        fi
    fi

    # 打开文件或目录
    if (( ${#files[@]} > 0 )); then
        /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl -a "${files[@]}"
    fi
else
    echo -e "[text:命令]:\n[<终端启动：Sublime Text3编辑器>]\n[参数:][file]:\n[<注意: 可以同时打开多个不同类型的文件>]"
fi
