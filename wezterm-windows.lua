
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Default to PowerShell 7; keep Windows PowerShell available.
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- 单击标签栏的 +，选择要在当前窗口打开的终端。
config.launch_menu = {
  { label = "PowerShell 7", domain = { DomainName = "local" } },
  {
    label = "Windows PowerShell",
    args = { "powershell.exe", "-NoLogo" },
    domain = { DomainName = "local" },
  },
  { label = "Ubuntu (WSL)", domain = { DomainName = "WSL:Ubuntu" } },
}

local shell_menu = act.ShowLauncherArgs({
  flags = "LAUNCH_MENU_ITEMS",
  title = "Open a terminal",
})
wezterm.on("new-tab-button-click", function(window, pane, button)
  if button == "Left" or button == "Right" then
    window:perform_action(shell_menu, pane)
    return false
  end
end)

-- Prefer the Nerd Font and use Microsoft YaHei for Chinese text.
config.font_dirs = { wezterm.home_dir .. '/.config/wezterm-dracula/fonts' }
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font Mono',
  'Microsoft YaHei',
  'JetBrains Mono',
  'Consolas',
}
config.font_size = 13
config.line_height = 1.15
config.initial_cols = 120
config.initial_rows = 34
config.window_padding = { left = 12, right = 12, top = 10, bottom = 10 }
config.window_background_opacity = 1.0
config.default_cursor_style = 'SteadyBar'

-- Warm charcoal background, soft white text, and explicit ANSI colors.
config.colors = {
  tab_bar = {
    inactive_tab_edge = '#201f1d',
    active_tab = { bg_color = '#302e2a', fg_color = '#bd93f9' },
    inactive_tab = { bg_color = '#201f1d', fg_color = '#bcb8af' },
    inactive_tab_hover = { bg_color = '#37342f', fg_color = '#dedbd2' },
    new_tab = { bg_color = '#201f1d', fg_color = '#bcb8af' },
    new_tab_hover = { bg_color = '#37342f', fg_color = '#dedbd2' },
  },
  background = '#262522',
  foreground = '#dedbd2',
  cursor_bg = '#c0caf5',
  cursor_fg = '#1a1b26',
  cursor_border = '#c0caf5',
  selection_bg = '#283457',
  selection_fg = '#c0caf5',
  ansi = {
    '#15161e', '#f7768e', '#9ece6a', '#e0af68',
    '#7aa2f7', '#bb9af7', '#7dcfff', '#a9b1d6',
  },
  brights = {
    '#414868', '#f7768e', '#9ece6a', '#e0af68',
    '#7aa2f7', '#bb9af7', '#7dcfff', '#c0caf5',
  },
}

-- Keep the title bar neutral as well.
config.window_frame = {
  active_titlebar_bg = '#201f1d',
  inactive_titlebar_bg = '#201f1d',
  active_titlebar_fg = '#dedbd2',
  inactive_titlebar_fg = '#bcb8af',
  active_titlebar_border_bottom = '#262522',
  inactive_titlebar_border_bottom = '#262522',
}

-- Keep the integrated Windows buttons and tabs in the same top row.
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

-- 滚动历史：方便查看 Codex 输出
config.scrollback_lines = 10000

-- SSH / Linux 兼容性
config.term = "xterm-256color"

-- 快捷键
config.keys = {
  -- 在当前窗口打开 Ubuntu（WSL）或 Windows PowerShell。
  {
    key = "u",
    mods = "CTRL|ALT",
    action = act.SpawnTab({ DomainName = "WSL:Ubuntu" }),
  },
  {
    key = "p",
    mods = "CTRL|ALT",
    action = act.SpawnCommandInNewTab({
      args = { "powershell.exe", "-NoLogo" },
      domain = { DomainName = "local" },
    }),
  },

  -- 左右分屏
  {
    key = "d",
    mods = "ALT",
    action = act.SplitHorizontal({
      domain = "CurrentPaneDomain",
    }),
  },

  -- 上下分屏
  {
    key = "d",
    mods = "ALT|SHIFT",
    action = act.SplitVertical({
      domain = "CurrentPaneDomain",
    }),
  },

  -- 新建标签页
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = act.SpawnTab("CurrentPaneDomain"),
  },

  -- 切换分屏
  {
    key = "LeftArrow",
    mods = "ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "RightArrow",
    mods = "ALT",
    action = act.ActivatePaneDirection("Right"),
  },

  -- 关闭当前窗格
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = act.CloseCurrentPane({
      confirm = true,
    }),
  },
}

-- Keep DPI fixed across monitors to avoid cross-DPI resize loops.
config.dpi = 120.0

return config
