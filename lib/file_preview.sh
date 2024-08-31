#! /usr/bin/env sh

# fzf-tab文件显示

file_path="$1"

if [[ -f $file_path || -d $file_path ]];then
    file_type=$(file -bL --mime-type $file_path)
else
    printf "\e[36m错误提示:\e[0m\n文件不存在!\n可能是文件名或者路径有问题!\n文件:$file_path"
    exit 0
fi


case $file_type in
    "image"*)
        printf '图片文件...'
    ;;
    "video"*)
        echo "$file_path is a video file."
    ;;
    "text"*|"application"*)
        (highlight -O ansi -j 0 -l $file_path || cat $file_path) 2> /dev/null
    ;;
    "inode/directory")

        if (( $(ls $file_path|wc -l) > 0 ));then
            logo-ls -1 $file_path
        else
            printf "空目录..."
        fi
        
    ;;
    
    *)
        echo "$file_path is a other type of file."  
    ;;
esac

# convert 1.jpeg -resize 160x160 ms.jpg
