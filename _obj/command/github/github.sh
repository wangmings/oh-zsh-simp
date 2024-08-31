

# 获取bash执行的脚本路径
path=$(cd `dirname $0`; pwd)


# 读取文件配置
readFileConfig(){
    local start=$1
    local end=${start/START/END}
    local config=$path/config.sh
    local startPos=$(gsed -n "/$start/=" $config)
    local endPos=$(gsed -n "/$end/=" $config)
    (( startPos++ )) && (( endPos-- ))
    [[ $2 == '-p' ]] && echo "$startPos,$endPos"
    gsed -n $startPos,$endPos'p' $config
}







# 获取配置
getConfig(){

    local option=$1
    local config=$path/config.sh

    if [[ $option == 'ip' ]];then

        # 去除重复的ip
        IPaddress=$(readFileConfig GITHUB-IP-START -p)
        pos=$(echo "$IPaddress"|gsed -n '1p')
        IPaddress=$(echo "$IPaddress"|gsed '1d'|sort|uniq)
    

        # 通过检测是否能ping通、来剔除无用的ip
        for ip in $IPaddress; do
            ping -c 3 -i 0.2 -W 3 $ip &> /dev/null
            (( $? != 0  )) && IPaddress=$(echo "$IPaddress"|gsed "/$ip/d" ) 
        done

        address=`echo $IPaddress`
        gsed -i $pos"c ${address//\ /\\n}" $config
        echo "$IPaddress"
        
    
    elif [[ $option == 'url' ]];then
        readFileConfig GITHUB-URL-START
    else
        readFileConfig USER-CONFIG-START
    fi


}






# github测速和替换hosts
githubHosts(){

    local hosts=/etc/hosts
    local context=$(gsed '/. github.com/d' $hosts)
    echo '' >> $hosts || sudo chmod 777 /etc/hosts

    echo -e "\033[4m请稍等正在处理IP地址...\033[0m\n"
    local github_ip=$(getConfig 'ip')
    # echo "$github_ip"
    echo -e "\033[4m请稍等正在检测IP地址是否可用...\033[0m\n"

    for ip in $github_ip; do

        local githubIP="$ip github.com"
        echo -e "$context\n\n$githubIP" > $hosts

        pings=0
        echo "网络测试: github.com --> $ip"

        for n in {1..4};do
            # local status=$(curl --connect-timeout 2 -sI https://github.com|grep HTTP/)
            local status=$(curl -m 2 -sI https://github.com | grep -m 1 HTTP/)
            local length=${#status}

            (( $n == 1 && $length == 0 )) && break

            if (( $length > 0 ));then
                ((pings++))
                echo "ping: $n"
            fi
        done


        if (( $pings == 4 ));then
            echo "请求成功: $status"
            break
        fi

    done


    if (( $pings == 4 ));then
        echo ''
        ping -c 4 github.com

    else
        echo -e "$context" > $hosts
    fi

}








# github镜像网站
githubImage(){
    
    local args=$*
    local option=$1
    local reps="/${args//$option /}"
    local imageURL=''
    echo "通过镜像网站访问GitHub仓库..."
    for url in $(getConfig 'url'); do
        local status=$(curl -sI -m 6 $url|grep HTTP/)
        local length=${#status}

        if (( $length > 0 ));then
            imageURL=$url
            # echo "请求成功: $status"
            break
        fi

    done

    
    (( $# == 1 )) && reps='?tab=repositories'
  

    if [[ $option == '-usr' ]];then
        userName=$(getConfig|grep name)
        userName=${userName#*:}
        userName=${userName//\ /}

        url="$imageURL/$userName$reps"
    elif [[ $option == '-url' ]];then
        url=$2
        url=${url#*com/}
        url="$imageURL/$url"

    fi


    printf "
    \e[32m
    如果打开网站显示: 403 Forbidden, 
    可能是镜像网站无法访问，或者你使用了代理、需要关闭代理!
    手动输入这个网站尝试一下:
    
    $url
    \e[0m\n"

    open -a 'Google Chrome' $url

}



# githubImage -usr
# githubImage -url "https://github.com/zhongyang219/TrafficMonitor"
# githubImage -url 'https://github.com/zhongyang219/TrafficMonitor.git'


(( $# == 0 )) && githubHosts || githubImage $*














