#!/bin/bash

bundle=GoogleSoftwareUpdate.bundle
google_update=~/Library/Google/GoogleSoftwareUpdate
google_update_bak="$google_update/update_bak/$bundle"
google_bundle="$google_update/$bundle"


# 关闭谷歌更新
google_update_off(){
    option=$1
    hosts=/etc/hosts
    lines=("# 关闭google游览器更新" "127.0.0.1 update.googleapis.com" "127.0.0.1 tools.google.com")
    
    sudo chown -R mac:staff "$hosts" "$google_update"

    if [ -d $google_update ]; then

        if [ $option == "off" ]; then
            bak=$(dirname $google_update_bak)
            [ ! -d $bak ] && mkdir $bak
            mv $google_bundle $bak

        else

            [ -d $google_update_bak ] && mv "$google_update_bak" "$google_update"

        fi
    fi

    


    for line in "${lines[@]}"; do
    
        if [ "$option" == "off" ] && ! grep -q "$line" "$hosts"; then
            echo "$line"
            echo "$line" >> "$hosts"
        elif [ "$option" != "off" ] && grep -q "$line" "$hosts"; then
            sudo gsed -i "/$line/d" "$hosts"
        fi

    done
    
    

    [ "$option" == "off" ] && sudo chown -R root:wheel "$hosts" "$google_update"
}





if (( $# > 0  )); then
    google_update_off $*

else
    echo "Usage:  [on|off]"
    exit 1

fi
