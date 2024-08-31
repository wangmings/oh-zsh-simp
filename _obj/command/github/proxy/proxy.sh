# 设置代理

# node -p -viewProxy
# node -g -getProxyAddress

RunPath=$(cd `dirname $0`; pwd)

PAC="$RunPath/pac.js"
COM="$RunPath/../config.sh"


[[ $1 == '-p' ]] && echo -e "查看代理地址: \n" && node $PAC -name

if [[ $1 == '-g' ]];then

    name=$(node $PAC -name)
    echo -e "查看代理地址: \n$name\n"

    read -p "选择序号: " num
    proxyAddress=$(node $PAC -get $num)
    echo -e "\n$proxyAddress\n"

    read -p "选择序号: " num
    ipAddress=$(echo "$proxyAddress"|grep "\ $num\ "|awk '{print $NF}')
    setIPAddress=$ipAddress
    echo "代理IP地址: $ipAddress"

    echo -e "\n测试代理地址是否可用:"
    ipAddress=$(echo $ipAddress|awk -F ':' '{print $1}')
    ping -c 3 -i 0.2 -W 3 $ipAddress &> /dev/null
    if (( $? == 0  ));then
        echo "代理地址可用: $ipAddress"
        gsed -i '/curl-proxy:/c\curl-proxy: https://'$setIPAddress  $COM
    else
        echo "代理地址不可用: $ipAddress"
    fi 


fi