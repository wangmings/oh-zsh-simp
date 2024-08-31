
// 站长之家输入网站获取ip 复制到githubIP文件上
// http://ping.chinaz.com/www.github.com


let node = (nodeName) =>{
    return document.querySelectorAll(nodeName)
}

let unique = (arr) => {
    return Array.from(new Set(arr))
}

let setStyle = (nodeName, style) => {
    document.styleSheets[0].addRule(nodeName, style)
}


let ipString = ''

let timing = setInterval(()=>{

    let ipAll = node('.row.listw.tc.clearfix')
    let ipNum = ipAll.length - 1
    let ipState = ipAll[ipNum].innerText.split('\n')

    if(ipState[3] != '-' && ipState[4] != '-'){
        clearInterval(timing)

        ipAll.forEach((node)=>{
            let context = node.innerText.split('\n')
            if(context.length >= 5 && context[1] != '系统异常'){
                if(context[3] != '超时' && context[3] != '超时'){
                    ipString += '\n'+context[1]
                }
            }
            
        })


        ipString = ipString.split('\n')
        ipString = unique(ipString)
        let printIP = ipString.toString().replaceAll(',','\n')

        console.log(printIP)


        let strIP = ''
        ipString.forEach((ip)=>{
            strIP += `<a href="javascript:">${ip}</a>`
        })

        let iplist = node('#ipliststr')
        
        
        setStyle('#ipliststr', 'height: 100%')
        setStyle('#ipliststr a', 'display:block; color: #4caf50; font-size:18px;')
        node('.cdn-list')[0].style = 'border: 8px solid #2196f3'

        iplist[0].innerHTML = strIP

        try {
            node('#copyip')[0].id = 'copyip2'
        }catch(err){
            console.log('')
        }


        node('#copyip2')[0].onclick = () => {
            copyTextFormat('#ipliststr')
        }


        

    }else{

        console.log('等待检测...')
    }

},2000)










// 直接把文本通过输入进行复制
function copyText(text) {
    let input = document.createElement('input');
    input.setAttribute('id', 'input_for_copyText');
    input.value = text;
    document.getElementsByTagName('body')[0].appendChild(input);
    document.getElementById('input_for_copyText').select();
    document.execCommand('copy');
    document.getElementById('input_for_copyText').remove();
}



// 通过节点复制带格式的文本
function copyTextFormat(nodeName) {

    let range = document.createRange();
    let nodes = document.querySelectorAll(nodeName)[0];  
    
    window.getSelection().removeAllRanges();
    range.selectNode(nodes);
    window.getSelection().addRange(range);
    document.execCommand('copy');
    window.getSelection().removeAllRanges();

}


























