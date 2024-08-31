#!/bin/bash
# 安装launchctl任务

# 获取当前路径
path=$(cd `dirname $0`; pwd)


# LaunchAgents文件|plist文件名
plistFileName='com.users.daemons.plist'
plistFilePath=~/Library/LaunchAgents/$plistFileName


# launchctl任务|日志log
exeScript="$path/main.sh"
outputLog="$path/log/launchctl.log"



# plist文本格式
plistText='
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Label</key>
<string>'$plistFileName'</string>
<key>ProgramArguments</key>
<array>
  <string>'$exeScript'</string>
</array>
<key>RunAtLoad</key>
<true/>
<key>StandardOutPath</key>
<string>'$outputLog'</string>
<!-- <key>StandardErrorPath</key>
<string>{err}</string> -->
</dict>
</plist>
'


if [[ $1 == '-path' ]];then
  echo $plistFilePath
elif [[ $1 == '-name' ]];then
  echo $plistFileName
else
  echo "$plistText" > $plistFilePath
fi











































