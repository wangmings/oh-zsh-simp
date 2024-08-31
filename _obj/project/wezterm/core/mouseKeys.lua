-- keys.lua
-- 快捷键配置文件




-- 添加按键绑定
wezterm_configs.keys = {
  {
    dos = "显示调试日志",
    key = 'g',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(wezterm.action.ShowDebugOverlay, pane)
    end)
  },

  {
    dos = '查看快捷键',
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
   
      -- 获取所有快捷键、鼠标绑定
      local keysAll, mouseAll = {}, {}

      -- 循环遍历 键盘、鼠标绑定
      table.insert(keysAll, "#{{键盘快捷键}}#")
      table.insert(keysAll, "((KEYS DES))")
      table.insert(keysAll, "((---- ---))")
      for _, value in ipairs(wezterm_configs.keys) do
        local key = value.key:gsub('Arrow', '')
        local mods = value.mods:gsub('|', '+')
        mods = string.format("[[%s+%s ]]%s", mods, string.upper(key), value.dos)
        table.insert(keysAll, mods)
      end


      keysAll = table.concat(keysAll, "\n")
      local keys_cmd = string.format('echo "%s\n"|column -t', keysAll)
      local keys = shell_popen(keys_cmd)
      

      table.insert(mouseAll, "####{{鼠标快捷键}}#")
      table.insert(mouseAll, "((MOUSE CLICK DES))")
      table.insert(mouseAll, "((----- ----- ---))")
      for _, value in ipairs(wezterm_configs.mouse_bindings) do
        local mods = value.mods:gsub('|', '+'):gsub('SUPER', 'Command'):gsub('NONE', 'None')
        local event = value.event.Down
        if not event then
          event = value.event.Drag
        end

        local click = event.streak
        local button = event.button
        mods = string.format("[[%s->%s num:(%s) ]]%s", mods, button, click, value.dos)
        table.insert(mouseAll, mods)
      end

      mouseAll = table.concat(mouseAll, "\n")
      local mouse_cmd = string.format('echo "%s\n"|column -t', mouseAll)
      local mouse = shell_popen(mouse_cmd)

      -- 生成数据
      local data = string.format("%s%s", keys, mouse)
      data = data:gsub("#", "\n")
      :gsub("%(%(", "\\e[35m  ")
      :gsub("%)%)", "\\e[0m")
      :gsub("%[%[", "\\e[33m  ")
      :gsub("%]%]", "\\e[34m")
      :gsub("%{%{", "\\e[36m****** ")
      :gsub("%}%}", " ******\\e[0m")

      -- prints(data)
      writeFile(wezterm_home('.keys'), data)

      server_exec_shell('-b', 'echo "$(cat ~/.keys) > ~/ms.txt"', function(result, debug)
        prints(result)
      end)



      -- pane:send_text('echo "$(cat ~/.keys)";rm ~/.keys;\n')

    end)

  },

  {
    dos = '复制选择到剪贴板',
    key = 'b',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local ansi = window:get_selection_escapes_for_pane(pane)
      window:copy_to_clipboard(ansi)
    end)
  },

  {
    dos = "向左移动一个单词",
    key="o",
    mods="ALT",
    action= wezterm.action.SendString "\x1bi"
  },

  { dos = "向上滚动", key = 'UpArrow', mods = 'SHIFT', action = wezterm.action.ScrollByPage(-0.5) },
  { dos = "向下滚动", key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollByPage(0.5) },

  {
    dos = "将光标移动到字符串行尾",
    key = 's',
    mods = 'CTRL',
    action = wezterm.action.SendKey {
      key = 'e',
      mods = 'CTRL',
    },
  },
  {
    dos = "打开终端配置",
    key=",",
    mods="CMD",
    action = wezterm.action.SpawnCommandInNewTab {
      args = {"sh", "-c", "vim "..theme_config_path},
    },
  },

  {
    dos = "窗口最大化",
    key = 'Enter',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      window:toggle_fullscreen()
    end),
  },

  {
    dos = "新建窗口",
    key = 'n',
    mods = 'CMD',
    action = wezterm.action.SpawnCommandInNewTab,
  },

  {
    dos = "创建浮动窗口",
    key = 'n',
    mods = 'ALT',
    action=wezterm.action_callback(function(window,pane)
      wezterm.mux.spawn_window { }
    end)
  },

  {
    dos = "控制左移动面板",
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action {
      ActivateTabRelative = -1
    }
  },

  {
    dos = "控制右移动面板",
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action {
      ActivateTabRelative = 1
    }
  },

  {
    dos = "清屏",
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.Multiple {
      wezterm.action.SendKey { key = 'L', mods = 'CTRL'},
    }
  },

  {
    dos = "水平分屏",
    key="p",
    mods="ALT",
    action=wezterm.action{
      SplitHorizontal={domain="CurrentPaneDomain"}
    }
  },

  {
    dos = "垂直分屏",
    key="l",
    mods="ALT",
    action=wezterm.action{
      SplitVertical={domain="CurrentPaneDomain"}
    }
  },

  {
    dos = "关闭分屏",
    key="w",
    mods="ALT",
    action=wezterm.action{CloseCurrentPane={confirm=true}}
  },

  {
    dos = "缩放面板",
    key="=",
    mods="ALT",
    action=wezterm.action.TogglePaneZoomState
  },

  {
    dos = "向左移动一个单词",
    key="LeftArrow",
    mods="SHIFT",
    action= wezterm.action.SendString "\x1bb"
  },

  {
    dos = "向右移动一个单词",
    key="RightArrow",
    mods="SHIFT",
    action= wezterm.action.SendString "\x1bf"
  },

  {
    dos = "左切换面板",
    key="LeftArrow",
    mods="ALT",
    action=wezterm.action{ ActivatePaneDirection="Left" }
  },

  {
    dos = "右切换面板",
    key="RightArrow",
    mods="ALT",
    action=wezterm.action{ ActivatePaneDirection="Right" }
  },

  {
    dos = "上切换面板",
    key="UpArrow",
    mods="ALT",
    action=wezterm.action{ ActivatePaneDirection="Up" }
  },

  {
    dos = "下切换面板",
    key="DownArrow",
    mods="ALT",
    action=wezterm.action{ ActivatePaneDirection="Down" }
  },

  {
    dos = "切换主题++",
    key="t",
    mods="CMD",
    action=wezterm.action_callback(function(window,Panda)
      switch_themes(window,"+")
    end)
  },

  {
    dos = "切换主题--",
    key="y",
    mods="CMD",
    action=wezterm.action_callback(function(window,pane)
      switch_themes(window,"-")
    end)
  },

  {
    dos = "默认主题",
    key="u",
    mods="CMD",
    action=wezterm.action_callback(function(window,pane)
      switch_themes(window,"+",wezterm_theme_config.default_theme)
    end)
  },

  {
    dos = "白色主题",
    key="t",
    mods="CMD|SHIFT",
    action=wezterm.action_callback(function(window,pane)
      wezterm_themes_all = wezterm_themes_list.light
      switch_themes(window,"+",wezterm_themes_all[1])
    end)
  },

  {
    dos = "深色主题",
    key="y",
    mods="CMD|SHIFT",
    action=wezterm.action_callback(function(window,pane)
      wezterm_themes_all = wezterm_themes_list.dark
      switch_themes(window,"+",wezterm_themes_all[1])
    end)
  },

  {
    dos = "恢复全部主题",
    key="u",
    mods="CMD|SHIFT",
    action=wezterm.action_callback(function(window,pane)
      wezterm_themes_all = wezterm_themes_list.all
      switch_themes(window,"+",wezterm_themes_all[1])
    end)
  },

  {
    dos = "面板选择",
    key = 'P',
    mods = 'CTRL',
    action = wezterm.action.PaneSelect{ alphabet = '1234567890', mode =  'Activate' }
  }
}



-- 鼠标快捷键
wezterm_configs.mouse_bindings = {

  {
    dos = "双击左键会选中鼠标光标所在位置的单词",
    event = { Down = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.SelectTextAtMouseCursor("Word"),
  },

  {
    dos = "单击右键用于复制选中的字符",
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window,pane)
      local data = wezterm_right_style[2]
      update_right_status(window, 2, 'Copy')
      wezterm.action.CopyTo('ClipboardAndPrimarySelection')
      wezterm.sleep_ms(1)
      wezterm_right_style[2] = data
    end)
  },

  {
    dos = "三击左键会选中鼠标光标所在的单元格",
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.SelectTextAtMouseCursor 'Cell',
  },

  {
    dos = "按住(Command键)并拖动鼠标左键会启动窗口拖动操作",
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = wezterm.action.StartWindowDrag,
  },

  {
    dos = "按住Ctrl+Shift键并按住鼠标左键,拖动启动窗口",
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'CTRL|SHIFT',
    action = wezterm.action.StartWindowDrag,
  }



}





-- printf('调试数据：',wezterm_configs)
