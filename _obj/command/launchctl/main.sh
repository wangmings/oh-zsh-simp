#! /bin/bash

# launchctl是一个统一的服务管理框架
# 启动、停止和管理守护进程、应用程序、进程和脚本
# 下面讲述一下如何在Mac上使用launchctl执行定时任务
# https://www.jianshu.com/p/b65c1d339eec


# 获取当前路径
path=$(cd `dirname $0`; pwd)


# ------- 开机启动任务配置 ------- #


# 启动Mac系统相关配置
bash $path/taskList/shutdown.sh&
bash $path/taskList/gpu.sh
