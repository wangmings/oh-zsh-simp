-- statusBar.lua
-- 状态栏配置
-- 图标参考：https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html

local icons = wezterm.nerdfonts
local hostname = wezterm.hostname()
local username = os.getenv("USER")




-- 获取屏幕大小 (MacOS)
local function get_screen_size()
  local main_screen = wezterm.gui.screens().main
  return main_screen.width, main_screen.height
end




-- 设置终端窗口位置
local function set_wezterm_window_position(window)
  local screen_width = get_screen_size()
  local width = window:get_dimensions().pixel_width
  window:set_position(screen_width - width, 0)
end






-- 获取电池信息
local function get_battery_power()

  local icon = icons.md_battery_alert
  local battery = wezterm.battery_info()[1]
  -- local power = math.floor(battery.state_of_charge * 100) + 5
  local power = shell_popen("pmset -g batt | grep -Eo '[0-9]+%' | cut -d% -f1")
  local index = math.floor(power / 10) * 10


  -- 电池图标
  local battery_icons = {
    Discharging = {
      [0] = icons.md_battery_outline,
      [10] = icons.md_battery_10,
      [20] = icons.md_battery_20,
      [30] = icons.md_battery_30,
      [40] = icons.md_battery_40,
      [50] = icons.md_battery_50,
      [60] = icons.md_battery_60,
      [70] = icons.md_battery_70,
      [80] = icons.md_battery_80,
      [90] = icons.md_battery_90,
      [100] = icons.md_battery
    },
    Charging = {
      [0] = icons.md_battery_charging_outline,
      [10] = icons.md_battery_charging_10,
      [20] = icons.md_battery_charging_20,
      [30] = icons.md_battery_charging_30,
      [40] = icons.md_battery_charging_40,
      [50] = icons.md_battery_charging_50,
      [60] = icons.md_battery_charging_60,
      [70] = icons.md_battery_charging_70,
      [80] = icons.md_battery_charging_80,
      [90] = icons.md_battery_charging_90,
      [100] = icons.md_battery_charging_100,
    },
    Full = { [100] = icons.md_battery },
    Empty = { [0] = icons.md_battery_outline },
  }

  
  -- 获取电池图标
  icon = battery_icons[battery.state][index]

  -- 获取图标失败
  if not icon then
    icon = icons.md_battery_unknown
  end

  -- print(battery.state, index, power)

  return string.format('%s %d%%', icon, power)

end








-- 获取电脑状态
local function get_pc_status()
  local status_parts = {
    icons.md_laptop, hostname, '|',
    icons.cod_account, username, '|',
    icons.md_select_inverse, shell_popen('cat ~/.cpu.txt'), '|',
    get_battery_power(), '|',
    icons.md_clock, wezterm.strftime('%m-%d %H:%M:%S'), ' '
  }
  return table.concat(status_parts, '  ')
end





-- 更新右边状态栏显示
wezterm_right_style = {}
function update_right_status(window, index, string)
  wezterm_right_style[index] = string
  local array = array_sort(wezterm_right_style)
  local status_text = table.concat(array, '  |  ')
  window:set_right_status(wezterm.format {{ Text = status_text }})
end




-- 添加更新事件:每一秒执行
local update_status = 0
wezterm.on('update-right-status', function(window, pane)
  if update_status == 0 then
    set_wezterm_window_position(window)
    update_status = 1
    switch_themes(window, "+", wezterm_theme_config.theme_name, 0)
  end

  local pc_status = get_pc_status()
  update_right_status(window, 1, pc_status)

end)
