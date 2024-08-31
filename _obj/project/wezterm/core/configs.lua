-- configs.lua
-- wezterm 配置


wezterm_configs = {

  -- 设置字体
  font_size = 16,

  font = wezterm.font_with_fallback {
    -- {family = 'JetBrains Mono'},
    -- { family = 'JetBrains Mono', weight = 'Bold', italic = false },
    { family = 'Zed Mono' },
    { family = 'QingLianShiXianCangShengGeLiangWan'},
    'Noto Color Emoji'
  },


  -- cell_width = 1.1,
  -- line_height = 1.2,
  -- tab_bar_at_bottom = true,

  -- 设置下划线
  -- underline_position = '1px',
  underline_thickness = "3px",
  custom_block_glyphs = true,

  -- 关闭更新提醒
  check_for_updates = false,

  -- 关闭默认按键分配
  -- disable_default_key_bindings = true,


  -- 设置滚动条
  enable_scroll_bar = true,

  -- 设置光标模式
  default_cursor_style = 'BlinkingBlock',

  -- 设置光标闪烁频率
  cursor_blink_rate = 600,

  -- 设置窗口大小
  initial_cols = 79,
  initial_rows = 25,

  -- 设置窗口边距
  window_padding = {
    left = 6,
    right = 6,
    top = 6,
    bottom = 6,
  },


  -- 设置快捷键
  keys = {},

  -- 设置鼠标快捷键
  mouse_bindings = {},



  -- 设置终端显示颜色
  colors = {

    tab_bar = {

      active_tab = {
        bg_color = '#F8F8FF',
        fg_color = '#444444',
      },

      inactive_tab_hover = {
        bg_color = '#ff9300',
        fg_color = '#ffffff',
        italic = true,
      },

      inactive_tab = {
        bg_color = '#01a0e4',
        fg_color = '#ffffff',
      }

    }

  }


}
  