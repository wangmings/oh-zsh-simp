-- themes.lua
-- 主题相关的配置


theme_config_path = wezterm_config_join('config/theme.json')

local nodejs = wezterm_home('.nvm/versions/node/v16.13.2/bin/node')
local main = wezterm_config_join('toml/main.js')



-- 定义wezterm主题配置
wezterm_theme_config = { 
  default_theme = '3024 Day', 
  theme_name = '3024 Day', 
  color_dirs = 'iTerm2' 
}










-- 读取主题配置
local configs = readFile(theme_config_path)
if #configs > 0 then
  wezterm_theme_config = wezterm.serde.json_decode(configs)  
end




-- 获取wezterm主题
local function get_wezterm_themes(option)
  local cmds
  local config = wezterm_theme_config

  local function generate_cmds(base_cmd, ...)
    local args = {...}
    for i, v in ipairs(args) do
      args[i] = string.format('"%s"', v)
    end
    local args_str = table.concat(args, " ")
    return string.format('%s %s %s %s', nodejs, main, base_cmd, args_str)
  end



  if option == "-colors" then
    cmds = generate_cmds("-colors", config.color_dirs, config.theme_name)
  elseif option == "-list" then
    cmds = generate_cmds("-list", config.color_dirs)
  end



  -- print(cmds)
  local theme_colors = shell_popen(cmds)
  return wezterm.serde.json_decode(theme_colors)

end


-- 获取所有主题
wezterm_themes_list = get_wezterm_themes("-list")
wezterm_themes_colors = get_wezterm_themes('-colors')
wezterm_themes_all = wezterm_themes_list.all
wezterm_configs.colors = wezterm_themes_colors



-- 切换主题
local themes_index = 0
function switch_themes(window, operate, name, state)
  state = state or 1
  themes_index = operate == '+' and themes_index + 1 or themes_index - 1
  themes_index = themes_index > #wezterm_themes_all and 1 or themes_index
  themes_index = themes_index == 0 and #wezterm_themes_all or themes_index
  themes_index = name ~= nil and array_index(wezterm_themes_all,name) or themes_index

  local color_name = wezterm_themes_all[ themes_index ]
  local style = string.format("%s  ( %s / %s | %s ) ", color_name, tostring(themes_index), #wezterm_themes_all, operate)
  
  -- 更新状态栏
  update_right_status(window, 2, style)
  
  
  -- 存储主题
  wezterm_theme_config.theme_name = color_name
  writeFile(theme_config_path, wezterm.serde.json_encode_pretty(wezterm_theme_config))


  -- 覆盖主题配置
  if state ~= 0 then
    local theme_colors = get_wezterm_themes('-colors')
    theme_colors.tab_bar = wezterm_configs.colors.tab_bar
    window:set_config_overrides({ colors = theme_colors })
  end

end

