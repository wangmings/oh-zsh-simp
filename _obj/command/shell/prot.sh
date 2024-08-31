#!/bin/bash
# 说明: 端口
# 作用: 快速查看端口情况


# lsof -n -P -i TCP -s TCP:ESTABLISHED| awk '{print $1,$2,$8,$9}'|nl -w 4
# awk '{print $1,$2,$8,$9}' 查看列表
# lsof命令可以列出当前的所有网络情况， 此命令的解释如下：
# -n 表示主机以ip地址显示
# -P 表示端口以数字形式显示，默认为端口名称
# -i 意义较多，具体 man lsof, 主要是用来过滤lsof的输出结果
# -s 和 -i 配合使用，用于过滤输出


port(){

	protFn(){
		num=$(lsof -n -P -i TCP -s TCP:$1|nl|wc -l)
		echo -e "\n所查找的端口类型:《$1》《$2》"
		echo -e "端口量:"`expr $num - 1`" (cm)\n"
		echo "$(lsof -n -P -i TCP -s TCP:$1)"
		echo ""
	}



	if [ $# -eq 0 ]
	then
		
		var=`lsof -n -P -i|nl|wc -l `
		echo "\n所有端口的使用情况:"
		echo "端口量:"$var" (cm)\n"
		echo "\033[36;9m`lsof -n -P -i`\033[32;0m"
		echo ""

	else

		
		if [ $1 == e ]; then

			protFn "ESTABLISHED" "通信建立正在传输数据"

		elif [ $1 == l ]; then

			protFn "LISTEN" "侦听远方TCP端口的连接请求"
		
		elif [ $1 == c ]; then
			protFn "CLOSE_WAIT" "等待从本地用户发来的连接中断请求"

		elif [ $1 == cl ]; then
			protFn "CLOSED" "被动关闭端在接受到ACK包后、就进入了closed的状态、连接结束、没有任何连接状态"

		else
			echo "没有查询的状态！请输入状态简写码：e:建立连接 l:监听端口 c:请求中断连接  cl:连接结束 :没输入返回全部状态"
		fi

	fi
}

 
read -p "请输入查询的网络状态码:" protType

port $protType















