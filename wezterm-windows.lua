
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- 默认使用 PowerShell
config.default_prog = { "powershell.exe", "-NoLogo" }

-- 单击标签栏的 +，选择要在当前窗口打开的终端。
config.launch_menu = {
  { label = "Windows PowerShell", domain = { DomainName = "local" } },
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

-- 字体：需要先安装 JetBrains Mono
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Consolas",
})
config.font_size = 12.5
config.line_height = 1.15

-- Catppuccin Mocha · 单行顶部，窗口按钮与标签共用一行。
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 1.0
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
config.window_padding = {
  left = 14,
  right = 14,
  top = 12,
  bottom = 10,
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.window_frame = {
  active_titlebar_bg = "#181825",
  inactive_titlebar_bg = "#181825",
  active_titlebar_border_bottom = "#1e1e2e",
  inactive_titlebar_border_bottom = "#1e1e2e",
}
config.colors = {
  tab_bar = {
    inactive_tab_edge = "#181825",
    active_tab = { bg_color = "#352a46", fg_color = "#cba6f7" },
    inactive_tab = { bg_color = "#181825", fg_color = "#a6adc8" },
    inactive_tab_hover = { bg_color = "#313244", fg_color = "#cdd6f4" },
    new_tab = { bg_color = "#181825", fg_color = "#a6adc8" },
    new_tab_hover = { bg_color = "#313244", fg_color = "#cdd6f4" },
  },
}

-- 窗口大小
config.initial_cols = 90
config.initial_rows = 24

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
    action = act.SpawnTab({ DomainName = "local" }),
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
