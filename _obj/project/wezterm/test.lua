-- node /Users/mac/.config/wezterm/toml/main.js -list "iTerm2-s"
-- node /Users/mac/.config/wezterm/toml/main.js -colors "iTerm2-s" "Aci"
local wezterm = require 'wezterm'


local wezterm_themes_all = nil
local wezterm_themes_list = nil
local wezterm_themes_colors = nil

local themes_path = wezterm_config_join('themes')


-- 解析主题文件
local function parseTheme(theme_file)
  -- 提取文件扩展名
  local ext = theme_file:match("^.+(%..+)$"):sub(2)
  local theme_data = shell_popen(string.format('cat "%s"', theme_file))
  
  -- 根据文件扩展名选择解析器
  local parse = {
    json = wezterm.serde.json_decode,
    toml = wezterm.serde.toml_decode,
    yaml = wezterm.serde.yaml_decode,
    yml = wezterm.serde.yaml_decode
  }

  local parser = parse[ext]
  if not parser then
    log("Unsupported file format: " .. ext)
    return nil
  end

  -- 解析数据并捕获错误
  local status, data = pcall(parser, theme_data)
  if status then
    -- log("Parsed data:", data)

    if data.colors then
      data = data.colors
    end

    return data
  else
    log("Error parsing data:", data)
    return nil
  end
end






-- 判断颜色是浅色还是深色
local function lightOrDark(color)
  local r, g, b

  if color:match("^rgb") then
      r, g, b = color:match("rgba?%((%d+),%s*(%d+),%s*(%d+)")
      r, g, b = tonumber(r), tonumber(g), tonumber(b)
  else
      local hex = color:gsub("#", "")
      if #hex < 6 then
          hex = hex:gsub("(.)(.)", "%1%1")
      end
      r = tonumber("0x" .. hex:sub(1, 2))
      g = tonumber("0x" .. hex:sub(3, 4))
      b = tonumber("0x" .. hex:sub(5, 6))
  end

  local brightness = math.sqrt(r * r * 0.299 + g * g * 0.587 + b * b * 0.114)
  return brightness > 127.5 and "light" or "dark"
end





-- 获取主题颜色
local function get_themes(option, theme_dirs, theme_name)
  
  local theme_cmd = string.format('find %s/%s -type f', themes_path, theme_dirs)
  local theme_all = shell_popen(theme_cmd)


  if option == '-list' then
    -- 主题模板
    local theme_list = {themes = theme_dirs, light = {}, dark = {}, all = {}, paths = {}}
    
    -- 使用 string.gmatch 按行分割并输出
    for theme_file in theme_all:gmatch("[^\r\n]+") do
      
      -- 解析主题
      local theme = parseTheme(theme_file)
      local light_dark = lightOrDark(theme.background)
      local themeName = theme.name or theme_file:match("([^/]+)%..+$")
      local theme_path = {}
      theme_path[themeName] = theme_file:match(".+/([^/]+)$")
      table.insert(theme_list.paths, theme_path)
      table.insert(theme_list.all, themeName)
      table.insert(theme_list[light_dark], themeName)
      
    end

    log(theme_list)

    return theme_list

  
  elseif option == '-colors' then
    
    local theme_file = nil
    local searchString = string.format('/%s.', theme_name)
    for line in theme_all:gmatch("[^\r\n]+") do
      if line:find(searchString) then
        -- log(line)
        theme_file = line
        break
      end
    end

    -- 文件不存在结束返回
    if not theme_file then
      log('ERR: ','The theme file does not exist: ', theme_name)
      return nil
    end

    -- 解析主题
    local theme_colors = parseTheme(theme_file)

    if theme_colors.color_01 then
      local colors = {
        foreground = theme_colors.foreground,
        background = theme_colors.background,
        cursor_bg = theme_colors.cursor,
        cursor_border = theme_colors.cursor,
        selection_fg = theme_colors.color_04,
        selection_bg = theme_colors.color_09,
        ansi = {},
        brights = {}
      }
  
      for i = 1, 16 do
        local colorKey = string.format("%02d", i)
        if i < 9 then
          table.insert(colors.ansi, theme_colors["color_" .. colorKey])
        else
          table.insert(colors.brights, theme_colors["color_" .. colorKey])
        end
      end
  
      theme_colors = colors

    end
  
    -- Lua中用nil来删除表中的键值对
    theme_colors.indexed = nil

    log(theme_colors)
  
    



  end
  
end




wezterm.on("gui-startup", function()
  log("协程1开始执行")
  -- wezterm_themes_list = get_themes('-list', 'gogh-s')
end)

log('hello--32')
-- get_themes('-list', 'iTerm2-s')
-- get_themes('-list', 'gogh')
-- wezterm_themes_list = get_themes('-list', 'gogh-s')

-- get_themes('-colors', 'iTerm2-s', "Aci")
-- get_themes('-colors', 'gogh-s', "3024 Day")





