const fs = require('fs').promises
const path = require('path')
const TOML = require('@ltd/j-toml')
const YAML = require('yaml')

// 获取命令行参数
const args = process.argv.slice(2)


// 异步获取目录中的文件列表
async function getFiles(dir) {
    const files = await fs.readdir(dir)
    const filePaths = await Promise.all(files.map(async file => {
        const filePath = path.join(dir, file)
        const stat = await fs.stat(filePath)
        if (stat.isFile() && file !== '.DS_Store') return filePath
    }))
    return filePaths.filter(Boolean) // 过滤掉任何 null 值

}



// 根据文件扩展名解析主题文件
async function parseTheme(filePath) {
    const extname = path.extname(filePath)
    const data = await fs.readFile(filePath, 'utf8')
    const parse = {
        '.json': (e) => JSON.parse(e),
        '.yml': (e) => YAML.parse(e),
        '.toml': (e) => TOML.parse(e).colors
    }

    return parse[extname](data)

}



// 确定颜色的对比度
function lightOrDark(e) {
    let t, r, s;
    return e.match(/^rgb/) ? (t = (e = e.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+(?:\.\d+)?))?\)$/))[1], r = e[2], s = e[3]) : (t = (e = +("0x" + e.slice(1).replace(e.length < 5 && /./g, "$&$&"))) >> 16, r = e >> 8 & 255, s = 255 & e), Math.sqrt(t * t * .299 + r * r * .587 + s * s * .114) > 127.5 ? "light" : "dark"
}

// console.log(lightOrDark('#DB2D20'))





// 获取主题列表及其对比度
async function getThemesList(themeDir) {
    const files = await getFiles(themeDir)
    const colors = {themes: args[1], light: [], dark: [], all: [] }
    for (const file of files) {
        const theme = await parseTheme(file)
        if (theme) {
            const contrast = lightOrDark(theme.background)
            const themeName = theme.name || path.basename(file, path.extname(file))
            colors.all.push(themeName)
            colors[contrast].push(themeName)
        }
    }

    console.log(JSON.stringify(colors))


}






// 获取特定主题的颜色
async function getThemesColors(themeDir, themeName) {
    const files = await fs.readdir(themeDir)
    const matchingTheme = files.find(file => file.startsWith(`${themeName}.`))
    
    const themePath = path.join(themeDir, matchingTheme)
    let theme = await parseTheme(themePath)

    if (theme.color_01) {
        const colors = {
            foreground: theme.foreground,
            background: theme.background,
            cursor_bg: theme.cursor,
            cursor_border: theme.cursor,
            selection_fg: theme.color_04,
            selection_bg: theme.color_09,
            ansi: [],
            brights: []
        }
        for (let i = 1; i <= 16; i++) {
            const colorKey = i.toString().padStart(2, '0')
                ; (i < 9 ? colors.ansi : colors.brights).push(theme[`color_${colorKey}`])
        }

        theme = colors

    }
    
    delete theme.indexed
    console.log(JSON.stringify(theme))
}





// 主函数根据命令行参数执行不同的操作
async function main() {

    const themeDir = path.join(__dirname, '/../themes/', args[1])
    if (args[0] === '-list') {
        getThemesList(themeDir)
    } else if (args[0] === '-colors' && args.length === 3) {
        getThemesColors(themeDir, args[2])
    } else {
        console.error('Invalid arguments.')
    }



}

main() 
