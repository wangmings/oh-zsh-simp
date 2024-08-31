
#!/bin/bash
# github管理远程储存库
# api文档: 
# 基于api https://api.github.com
# 注意: 看文档参数说明
# https://docs.github.com/cn/rest/repos/repos#create-an-organization-repository
# https://docs.github.com/cn/rest/repos/repos#list-repositories-for-a-user
# 储存库管理: 创建 查看 删除 上传 下载 等等



# 获取bash执行的脚本路径
PATHS=$(cd `dirname $0`; pwd)

# 初始化代理
PROXY_ENABLE=0

# 帮助文档
help(){ bash $PATHS/help.sh;}


# api状态
apiStatus=0

# 参数处理
args=()
index=0
for ((i=1; i<=$#; i++));do
    eval get=\$$i
    args[$index]=$get
    ((index++))
done


# github库的名字
repositoryName=${args[1]}
repositoryDescription=${args[2]}







# 解析配置字段
getText(){
    local text=$1
    local keys=$2
    text=$(echo "$text"|grep $keys)
    text=${text#*:}
    text=${text//\ /}
    echo "$text"
}





# 读取文件配置
readFileConfig(){
    local start=$1
    local end=${start/START/END}
    local config=$PATHS/config.sh
    local startPos=$(gsed -n "/$start/=" $config)
    local endPos=$(gsed -n "/$end/=" $config)
    (( startPos++ )) && (( endPos-- ))
    gsed -n $startPos,$endPos'p' $config
}


# 输出提示
print(){
    printf "\e[7;35m$*\e[0m\n\n"
}





# 获取配置
getConfig(){

    local user=$(readFileConfig USER-CONFIG-START)
    userName=$(getText "$user" 'name')
    userEmail=$(getText "$user" 'email')
    timeout=$(getText "$user" 'timeout')
    token="Authorization: token "$(getText "$user" 'token')

    local proxy=$(readFileConfig PROXY-CONFIG-START)
    sshProxy=$(getText "$proxy" 'ssh-proxy')
    httpProxy=$(getText "$proxy" 'http-proxy')
    httpsProxy=$(getText "$proxy" 'https-proxy')



}






# 设置默认配置
gitConfig(){

    # 配置当前项目
    git config  user.name $userName     # 用户名
    git config  user.email $userEmail   # 用户邮箱

    # 配置全局
    git config --global user.name $userName                                # 用户名
    git config --global user.email $userEmail                              # 用户邮箱
    git config --global init.defaultBranch main                            # 设置默认分支
    git config --global remote.origin.url "git@github.com:$userName/$repositoryName.git" 

    # 配置全局代理|下载
    # git config --global url."$httpProxy/https://github.com".insteadOf "https://github.com"

    # 配置git代理
    # git config --global https.proxy $httpsProxy    

}



# 设置代理下载
setProxy(){

    # 配置全局代理|下载
    local proxy="$httpProxy/https://github.com"
    
    if (( $1 == 1 )); then 
        # 设置
        echo "设置Git下载全局代理"
        git config --global url."$proxy".insteadOf "https://github.com"
    else
        
        # 删除
        echo "删除Git下载全局代理"
        git config --global --unset url."$proxy".insteadOf

    fi
    


}











# githubAPi操作
gitAPI(){

    request(){

        local url="curl -s" 

        (( $PROXY_ENABLE > 0 )) && url="curl -s -x '$httpsProxy'"

        # 使用代理访问github的api
        args="$url -H '$token' -m $timeout $*"
        eval $args
    }



    repositoryURL="https://api.github.com/repos/$userName/$repositoryName"
    contentsURL="https://api.github.com/repos/$userName/$repositoryName/contents/$2"


    
    # 修改远程仓库描述说明
    [[ $1 == '-description' ]] && \
    request "
        -X PATCH
        -H 'Accept: application/vnd.github.v3+json'
        '$repositoryURL'
        -d '{\"name\":\"$repositoryName\",\"description\":\"$repositoryDescription\"}'
    "



    # 重新命名远程仓库名字
    [[ $1 == '-rename' ]] && \
    request "
        -X PATCH
        '$repositoryURL'
        -d '{\"name\": \"$2\"}'
    "


    
    # 创建远程仓库
    [[ $1 == '-create' ]] && \
    request " 
        -X POST 
        -H 'Accept: application/vnd.github.v3+json' 
        'https://api.github.com/user/repos' 
        -d '$2'
    "



    # 删除远程仓库
    [[ $1 == '-delete' ]] && \
    request " 
        -i -X DELETE 
        '$repositoryURL'   
    "



    # 下载远程仓库中的文件
    [[ $1 == '-downloadFile' ]] && \
    request " 
        -H 'Accept: application/vnd.github.v3.raw' -O 
        -L '$contentsURL'  
    "




    # 获取仓库SHA
    [[ $1 == '-sha' ]] && \
    request "'$contentsURL'"




    # 输出文件到远程仓库
    [[ $1 == '-uploadFlie' ]] && \
    request " 
        -X PUT
        -H 'application/vnd.github.v3+json'
        '$contentsURL'
        -d '$json'
    "

    

    
    # 删除远程仓库中的文件
    [[ $1 == '-deleteFile' ]] && \
    request " 
        -X DELETE
        -H 'Accept: application/vnd.github.v3+json'
        '$contentsURL'
        -d '{\"message\":\"delete $2\",\"sha\":$3}'
    "




    # 列出所有远程仓库
    [[ $1 == '-view' ]] && \
    request "'https://api.github.com/user/repos?per_page=100&page=1&direction=desc'"





    # 判断远程仓库是否存在
    [[ $1 == '-is' ]] && \
    request "'https://api.github.com/user/repos'"



}















# 下载存储库
downloadRepository(){

    print "下载GitHub远程储存库"

    local url=$repositoryName
    url=${url#*com/}
    url=${url//*.com:/}
    url=$(echo "$url"|sed 's/.git$//')    
    url=(${url//\//\ })

    local length=${#url[*]}
    if (( $length > 1 ));then
        userName=${url[0]}
        repositoryName=${url[1]}
    fi

    gsed -i '/url/d' ~/.gitconfig

    if [[ $1 == 'gh' ]];then
        gh repo clone "$userName/$repositoryName"
    elif [[ $1 == 'git' ]];then
        git clone "git@github.com:$userName/$repositoryName.git"
    elif [[ $1 == 'ssh' ]];then
        git clone "$sshProxy:$userName/$repositoryName.git" 
    fi
    
}









# 查看项目的改动
gitStatus(){

    printf "
        \e[30m($1) ---------------------------------[STA]\e[0m

        \e[33m`git status`\e[0m

        \e[30m--------------------------------------------[END]\e[0m

    "|sed 's/^[ \t]*//'
}







# 检测hosts文件是否存在GitHub IP地址
detectIp(){
    githubIP=$(cat /etc/hosts|grep -o "^[^ ]* github\.com")
    if (( ${#githubIP} == 0 ));then
        printf "\e[32mHosts文件: (github.com)不存在! DNS无法解析到(github.com)可能无法正常使用! 需要添加(github.com)\n\e[0m"
    fi
}









# 上传整个项目
uploadRepository(){


    if [[ $1 == 'name' ]];then
        local name="`pwd`"
        repositoryName=${name##*/}
    fi

    # 查看储存库是否存在
    (( $apiStatus == 0 )) && noRepositoryExists

    printf "\n上传整个项目到远程仓库中...\n"

    # 初始化当前项目、会生成一个.git文件
    [[ ! -f README.md ]] && echo '# hello world' > README.md
    [[ ! -d .git ]] && git init

    gitConfig
    gitStatus '初始化'

    # 添加当前的文件到本地的git储存库配置中
    git add .
    gitStatus '加入文件'

    # 提交已经添加的文件到本地git储存库中, 添加描述说明
    git commit -m "upload: $(date '+%Y-%m-%d %H:%M:%S')"
    gitStatus '本地仓库'

    # 创建一个名为main分支
    git branch -M main

    # 给本地储存库添加远程储存库地址
    # git remote add origin git@github.com:$userName/$repositoryName.git
    # 上传本地储存库到远程储存库的main分支下
    printf "\e[30m(开始上传): --------------------------------[$repositoryName]\e[0m\n"
    printf "\e[7;31m注意: 上传时卡住，请更新GitHub-IP, 执行命令: gits -sp\e[0m\n\n"
    detectIp
    git push -u origin main

    # 去除全局远程仓库连接
    gsed -i '/url = /d' ~/.gitconfig

}








# 修改储存库名字
renameRepository(){

    print "重新命名远程存储库名.."
    local length=${#args[*]}
    local name=${args[2]}
    local status=$(gitAPI -rename $name|jq .name)

    status=${status//\"/}
    if [[ $status == $name ]];then
        echo "修改储存库名成功!"
    else
        echo "修改储存库名失败成功、请检查是否存在储存库!"
    fi


}







# 创建储存库
createRepository(){

    local att=('公共' 'false')
    [[ $1 == "-p" ]] && att=('私有' 'true')
    
    des="新创建${att[0]}库"
    (( ${#args[2]} > 0 )) && des="${args[2]}"

    json="{\"name\":\"$repositoryName\",\"description\":\"$des\",\"private\":${att[1]}}"

    print "创建${att[0]}GitHub远程储存库"
    create=$(gitAPI -create "$json"|jq .name)
    [[ $create == 'null' ]] && echo "创建GitHub远程库失败!" || echo "创建库成功: $create"

}









# 查看所有储存库
viewAllRepository(){

    print "查看所有远程储存库.."

    local num=0
    local name=''
    local repositoryAll=''
    local repository=$(gitAPI -view)
 
    local name=$(echo "$repository"|jq '.[]|.name'|sed 's/"//g')
    local visibility=$(echo "$repository"|jq '.[]|.visibility'|sed 's/"//g')
    local description=$(echo "$repository"|jq '.[]|.description'|sed 's/"//g')
    local created_at=$(echo "$repository"|jq '.[]|.created_at'|sed 's/"//g; s/T/ /; s/Z//')


    if [[ $1 == 'ms' ]];then
        
        reps=$(paste -d " " <(echo "$created_at") <(echo "$name") |sort -rn|awk '{ print "\\e[97m" $1 " \\e[95m" $2 "\\e[0m --> \\e[32m" $3 "\\e[0m" }')
        repsNum=$(echo "$reps"|wc -l)
        echo "远程仓库: $repsNum"
        printf "\n$reps\n"

    elif [[ $1 == 'des' ]];then
        
        visibility=$(echo "$visibility"|sed 's/^public/\\e[40mpublic\\e[0m/g; s/^private/\\e[44mprivate\\e[0m/g;')
        name=$(echo "$name"|awk '{print "\\e[32m"$1"\\e[0m"}'|sed 's/$/\\n/')
        description=$(echo "$description"|sed 's/$/\\n/')
        repos=$(paste -d " " <(echo "$created_at") <(echo "$visibility") <(echo "$name") <(echo "$description")|sort -rn|cut -d ' ' -f 3-)
        printf "$repos"|sed 's/^ //g'
    

    elif [[ $1 == 'edit' ]];then
        
        visibility=$(echo "$visibility"|sed 's/^public/#/g; s/^private/#/g;')
        name=$(echo "$name"|awk '{print $1}'|sed 's/$/\\n/')
        description=$(echo "$description"|sed 's/$/\\n/')
        repos=$(paste -d " " <(echo "$created_at") <(echo "$visibility") <(echo "$name") <(echo "$description")|sort -rn|cut -d ' ' -f 3-)
        printf "$repos"|sed 's/^ //g' > ./description.md
        printf "已经在当前目录下输出一个: description.md 文件?"
    
    else
        
        reps=$(paste -d " " <(echo "$created_at") <(echo "$name") |sort -rn|awk '{print $3}')
        repsNum=$(echo "$reps"|wc -l)
        echo "远程仓库: $repsNum"
        printf "\n\e[32m$reps\e[0m\n"


    fi



}





# 查看是否存在储存库
noRepositoryExists(){

    printf "查看远程储存库是否存在?\n"
    
    local repository=$(gitAPI -is|jq ".[]|.name"|grep "$repositoryName")
    local len=${#repository}

    if (($len == 0));then
        read -p "github库不存在是否创建:[yes|y:no]: " libs
        if [[ $libs == 'yes' || $libs == 'y' ]];then
            createRepository
            if [[ -d .git ]];then
                rm -rf .git
            fi
        else
            exit
        fi
    else
        printf "\e[35m储存库: [$repositoryName] 存在\e[0m\n"
    fi
}







# 删除存储库
deleteRepository(){

    print "删除GitHub远程储存库"

    local length=${#args[*]}

    for ((i=1; i<$length; i++));do  
        repositoryName=${args[i]}
        statusCode=$(gitAPI -delete|grep 'HTTP/1.1'|awk -F ' ' '{print $2}')
        [[ $statusCode == '200' ]] && echo "删除库成功: $repositoryName" || echo "删除库失败: $repositoryName"
    done


}












# 下载储存库中的文件
downloadRepositoryFlie(){

    local length=${#args[*]}

    if [[ $length > 2 ]];then
        local num=0
        local arr=()

        print "下载GitHub远程储存库中的文件"
   
        
        for ((i=2; i<$length; i++));do
            fileName="${args[$i]}"
            {
                gitAPI -downloadFile $fileName
            }&

            arr[num]=$fileName
            ((num++))

        done

        wait
        
        echo "下载文件:  [ ${arr[*]} ]"

    else 
        help
    fi
}
 









# 删除储存库中的文件
deleteRepositoryFlie(){
   
    if (( ${#args[*]} > 2 ));then

        print "删除GitHub远程储存库中的文件" 
        local logs=delete.log

        if [[ ${args[2]} == '.' ]];then
            local fileAll=$(find . -type f -maxdepth 10)
            fileAll=${fileAll//\.\//}
            args=${args[*]}
            args=(${args//\./} $fileAll)
        fi


        for ((i=2; i<${#args[*]}; i++));do

            fileName="${args[$i]}"
   
            sha=$(gitAPI -sha "$fileName"|jq .sha)

            if [[ $sha == 'null' ]];then
                echo "不存在: [ $fileName ] 文件"
            else
                gitAPI -deleteFile "$fileName" "$sha" >/dev/null 2>&1
                echo -n "$fileName " >> $logs
            fi
       
            

        done


        [[ -f $logs ]] && echo "删除: [ $(cat $logs) ] 文件" && rm $logs
        

    else
        help
    fi
}










# 上传文件到储存库中
uploadRepositoryFlie(){

    local length=${#args[*]}

    if [[ $length > 2 ]];then

        local logs=upload.log
        local option=${args[2]}
        
        if [[ $option == '.' ]];then
            filePath="$(find .)"
            filePath=${filePath//\ /\*}

            pathAll=''
            for paths in $(echo "$filePath");do
                [[ -f $paths ]] && pathAll="$pathAll\n$paths"
            done

            local args=${args[*]}
            args=${args//\./}

            args=($args $(echo -e "$pathAll"))
            length=${#args[*]}

        fi


        # 判断远程仓库是否存在
        noRepositoryExists
    
        print "上传文件到远程GitHub储存库"

        local input='null'

        for ((i=2; i<$length; i++));do
            
            fileName="${args[$i]}"

            sha=$(gitAPI -sha $fileName|jq .sha)

            [[ $sha != 'null' && $input == 'null' ]] && read -p "文件已经存在: [是,否] (覆盖) 请输入: [yes,no]: " input
           
            if [[ $sha == 'null' || $input == 'yes' || $input == 'y' ]];then

                FName=${fileName//\.\//}
                FData=$(cat $fileName|base64)

                if [[ $sha == 'null' ]];then
                    json="{\"message\": \"uploadFlie $FName \", \"content\": \"$FData\"}"
                else     
                    json="{\"message\": \"uploadFlie $FName \", \"content\": \"$FData\", \"sha\":$sha}" 
                fi
                
                state=$(gitAPI -uploadFlie "$fileName" "$json"|jq .documentation_url)

                if [[ $state == 'null' ]];then
                    echo "上传成功: $fileName"
                else
                    echo -n "$fileName " >> $logs
                fi

            fi

                   

        done




        
        if [[ -f $logs ]];then 
            echo "上传失败: [ $(cat $logs) ] " && rm $logs

        fi



    else
        help
    fi
}







# 更新储存库描述说明
updateDescription(){

    print "更新远程储存库的描述说明..."
   
    local status=$(gitAPI -description |jq .description)

    status=${status//\"/}

    if [[ $status == $repositoryDescription ]];then
        echo '更新描述说明成功!'
    else
        echo '更新描述说明失败!'
    fi


}






# 通过文件更新所有储存库描述说明
updateFileDescription(){

    local name=""
    local description=""

    if [[ ! -f ./description.md ]];then
        echo "当前路径下: description.md文件不存在! 获取description.md文件! 执行命令: gits -desf"
        exit 
    fi

    # 获取修改的储存库内容
    awk '/^\*/,/^$/' ./description.md > file.md


    while read -r line; do
        # 判断当前行是否为空行
        if [[ -z $line ]]; then
            # 当前行是空行，打印空行

            printf "更新: $name\n$description\n"

            repositoryName=$name
            repositoryDescription=$description

            local status=$(gitAPI -description |jq .description)

            status=${status//\"/}

            if [[ $status == $repositoryDescription ]];then
                printf '更新描述说明成功!\n'
            else
                printf '更新描述说明失败!\n'
            fi

        else

            # 当前行不是空行，打印当前行
            if [[ ${line:0:1} == '*' ]];then
                name=$(echo "$line"|sed 's/^* //g')
            else
                description="$line"
            fi 
            
        fi
    done < file.md

}




# 检查VPN网络代理是否启用
checkProxyEnabled(){
    # 通过查看本机IP地址判断网络是否启用
    
    if [[ $1 == "-p" ]];then
        curl cip.cc
    else
        curl -s cip.cc|grep '中国'|wc -l
    fi


}












# 执行主方法
main(){


    if (( $# > 0 )); then

        # print "等待检测是否启用VPN网络代理..."

        # PROXY_ENABLE=$(checkProxyEnabled)

        # (( PROXY_ENABLE == 0 )) && print "工作模式: VPN代理..." || print "工作模式: PAC代理..."

        # 获取用户配置
        getConfig


        case $1 in


            '-c') # 创建仓库
            createRepository 
            ;;

            '-p') # 创建私有仓库
            createRepository "-p"  
            ;;

            '-up') 
            uploadRepository  
            ;;

            '-gh') 
            downloadRepository 'gh'  
            ;;
            
            '-uf') 
            uploadRepositoryFlie  
            ;;

            '-df') 
            downloadRepositoryFlie  
            ;;
            
            '-delf') 
            deleteRepositoryFlie  
            ;;


            '-del') 
            deleteRepository  
            ;;

            '-name') 
            renameRepository  
            ;;


            '-git') 
            downloadRepository 'git'  
            ;;

            '-ssh') 
            downloadRepository 'ssh'  
            ;;

            '-des') 
            updateDescription  
            ;;

            '-url') 
            bash $PATHS/github.sh '-url' $2             
            ;;

            '-l') 
            viewAllRepository
            ;;

            '-ls') 
            viewAllRepository 'ms'  
            ;;

            '-ld') 
            viewAllRepository 'des'  
            ;;

            '-desf') 
            viewAllRepository 'edit'  
            ;;

            '-upDesf') 
            updateFileDescription  
            ;;

            '-gu') 
            git config -e  
            ;;

            '-gg') 
            git config --global -e 
            ;;

            '-g-s-proxy') 
            # gitConfig
            setProxy 1
            ;;

            '-g-d-proxy') 
            setProxy 0
            ;;

            '-vpn') # 查看网络代理是否启用
            checkProxyEnabled '-p'
            ;;


            '-sp') 
            bash $PATHS/github.sh 
            ;;

            '-fg') 
            vim $PATHS/config.sh 
            ;;

            '-up') 
            uploadRepository 'name' 
            ;;

            '-usr') 
            bash $PATHS/github.sh '-usr' "${args[1]}" 
            ;;

            '-AP') 
            bash $PATHS/proxy/proxy.sh '-p' 
            ;;

            '-SP') 
            bash $PATHS/proxy/proxy.sh '-g'
            ;;

            
            *)  
            echo "选项: [ $1 ] 不存在!"
            ;;


        esac

        

    else
        help
    fi



    


}



main $*











