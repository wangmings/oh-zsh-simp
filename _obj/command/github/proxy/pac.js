/**
 * PAC脚本处理
 */

const fs = require('fs')
const $url = require('url')
const http = require('http')
const https = require('https')


// 获取PAC脚本数据
const getPAC = (path) => {
    let [num,json,name] = [0,null,[]]
    let node = fs.readFileSync(path, 'utf8')
    eval(`json=${node}`)
    
    for (let key in json) {
        let bo = /^\+/g.test(key)
        if(bo) name.push(key)
    }
    
    // 按字符串长度进行排序
    name.sort((a,b) => { return a.length - b.length })
    name = name.map(key => `序号: ${num++} | ${key}` )
    return { pac: json,name: name}
}







/**
 * http、https网络请求
 * @param {String} url
 * @returns
 */
const httpRequest = async (url) => {
    let protocol = url.split(':')[0].replaceAll(' ', '')
    // 通过URL判断使用[http|https]模块进行URL请求
    let HRequest = protocol == 'https' ? https : http
    return new Promise((resolve, reject) => {
        let req = HRequest.request(url, (res) => {
            if (res.statusCode == 200) {
                let buffs = []

                res.on('data', (data) => {
                    buffs.push(data)
                })

                res.on('end', () => {
                    resolve(buffs.join(''))
                })
            } else {
                console.log(`${protocol}请求状态码: ${res.statusCode}`)
            }
        })

        req.setTimeout(3000, () => { 
            console.log(`${protocol}请求超时了，请检查网络是否能正常使用!`) 
            process.exit(0) 
        }) 
        
        req.on('error', (e) => { console.error(`请求URL错误: ${e}`) })
        req.end()
    })
}








const FindProxyForURL = async (requestURL, pacScript) => {
    
    if(/^http/g.test(pacScript)){
        pacScript = await httpRequest(pacScript)
    }
    
    return new Function(`${pacScript};return FindProxyForURL`)()(requestURL, $url.parse(requestURL).host)
}











(async function() {
    
    let ip = null
    let keys = null
    let testURL = 'https://www.google.com'
    let {pac,name} = getPAC(__dirname + '/PAC/OmegaOptions.bak')

    
    // 获取命令输入参数
    let argv = process.argv.splice(2)
    if(argv.length > 1) keys = name[argv[1]].split('| ')[1]


    if (argv[0] == '-name') console.log(name.join('\n'))
    if (argv[0] == '-get' && argv.length > 1){
        ip = await FindProxyForURL(testURL, pac[keys].pacScript)  
    } 

    if (argv[0] == '-url' && argv.length > 1){
        ip = await FindProxyForURL(testURL, pac[keys].pacUrl)
    }

    if (argv[0] == '-get' || argv[0] == '-url'){
        let num = 0
        ip = ip.split('; ')
        ip = ip.map(add => `序号: ${num++} | ${add.replace('HTTPS','HTTPS:')}`)        
        console.log(`代理地址: ${keys} \n${ip.join('\n')}`)
    }



    

})()
    





