#!/bin/bash
# ESP 命令行烧写 
#esptool.py 
# --chip esp8266                    芯片
# --port /dev/cu.wchusbserial410    串口
# --baud 115200                     波特率
# --before default_reset 
# --after hard_reset write_flash -z 
# --flash_mode dout                 下载模式
# --flash_freq 80m                  下载速度
# --flash_size 4MB                  内存大小
# 0x00000 ./bin/eagle.flash.bin     烧录地址
# 0x10000 ./bin/eagle.irom0text.bin 
# 0x3fb000 ./bin/blank.bin 
# 0x3fc000 ./bin/esp_init_data_default_v08.bin 
# 0x3fe000 ./bin/blank.bin
# 




# 烧写:注意修改
function EspBurn(){
    echo "ESP开始烧录..........."
    esptool.py --chip esp8266 --port /dev/cu.wchusbserial* --baud 115200 --before default_reset --after hard_reset write_flash -z --flash_mode dout --flash_freq 80m --flash_size 4MB 0x0 ./bin/eagle.flash.bin 0x10000 ./bin/eagle.irom0text.bin 0x3fb000 ./bin/blank.bin 0x3fc000 ./bin/esp_init_data_default_v08.bin 0x3fe000 ./bin/blank.bin
    echo "ESP烧录成功..........."
}


# 自动擦除 flash 上所有内容,即所有数据将是 0xFF
function EspErase(){
    echo "ESP自动擦除全部数据..........."
    esptool.py erase_flash   
    echo "ESP全部数据擦除成功..........."
}

function hello(){
    echo "ESP烧录:"
    echo "   esp -b  [Flash烧写]"
    echo "   esp -r  [自动擦除全部]\n"
}



if [[ $# > 0 ]]; then
    if [[ $1 == "-b" ]]; then
        EspBurn
    elif [[ $1 == "-r" ]]; then
        EspErase
    else
        hello
    fi
else
    hello
fi





















