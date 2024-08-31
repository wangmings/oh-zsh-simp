#!/bin/bash

# 监听鼠标键盘操作、来定时关机



echo "
My-Launchd-Logs: -------------------------- [`date "+%Y-%m-%d %H:%M:%S"`]
shutdown-task-run: shutdown-launchd(监听键盘鼠标任务|关机)
"|sed 's/^[ \t]*//; /^$/d'



# 设置超时时间为4分钟
setTime=4

# 分钟转换成秒
second=$((setTime*60))

# 第一次启动时，初始化状态
initStatus=0


# 检查键盘和鼠标的活动情况
while true; do

  # 第一次启动时，延迟30秒
  if (( $initStatus == 0 ));then
    sleep 30
    initStatus=1
  fi

  
  # 获取键盘和鼠标的活动状态
  # 注意，启动这个脚本的时间，必须大于5秒后，合上屏幕才能正常监听执行，小于5秒，合上屏幕，下面监听会一直输出0
  activity=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
  # echo $activity


  # 如果键盘和鼠标2分钟内没有操作，就执行关机操作
  if (( $activity > $second )); then
    
    # 消息提示
    display=$(osascript -e 'display dialog "用户离开'$second'秒，是否关机? 无任何操作，10秒后自动关闭" with title "Confirmation" buttons {"No","Yes"} default button "Yes" giving up after 10'|awk -F':' '{print $3}')
    
    if [[ $display == "true" ]];then
      sleep 1
      echo 'shutdown-task-run: shutdown-launchd(关机中...)'
      echo '0000'|sudo -S shutdown -h now >/dev/null 2>&1
      exit 0
    fi
  fi

  # 等待1秒钟，再检查键盘和鼠标的活动情况
  sleep 1

done

