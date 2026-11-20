# Ghostty — Linux

用于 Ubuntu / GNOME，配置从本机当前的 `config.ghostty` 原样收录。
已使用本机 Ghostty 1.4.0 校验。

## 外观与行为

- `TokyoNight Night` 内置主题，覆盖为暖深灰背景 `#262522`、柔白文字 `#dedbd2`。
- `JetBrainsMono Nerd Font Mono`，中文回退为 `Noto Sans Mono CJK SC`，字号 13。
- 初始窗口 120 列 × 34 行，不透明背景、竖线光标、64 MiB 滚动历史。
- 自动识别默认 shell，启用 shell integration。
- 复用 GTK 进程，最后一个窗口关闭后保留后台进程。

## 安装

先安装 [Ghostty](https://ghostty.org/docs/install/binary) 和配置指定的字体。
本机使用 Snap 版 Ghostty；本仓库只管理配置，不包含终端程序和字体文件。

在**仓库根目录**执行以下命令，先备份已有文件，再复制配置：

```bash
ghostty_dir="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
stamp="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$ghostty_dir"
# 同时备份旧版 config 文件；如存在，两份配置都应检查是否有重复设置。
for name in config config.ghostty; do
  if [ -e "$ghostty_dir/$name" ] || [ -L "$ghostty_dir/$name" ]; then
    cp -pL "$ghostty_dir/$name" "$ghostty_dir/$name.backup-$stamp"
  fi
done
cp ghostty/config.ghostty "$ghostty_dir/config.ghostty"
ghostty +validate-config
```

在运行中的 Ghostty 按 `Ctrl+Shift+,` 重新加载配置。
字体和窗口相关选项若未立即更新，可彻底退出后重新打开。

该文件只配置终端本身；本机 shell 的提示符和初始化仍由自己的 shell 配置管理。
Windows / WSL 的 Starship 主题单独保存在 [`wezterm/`](../wezterm/README.md)。

## 快捷键

| 按键 | 操作 |
| --- | --- |
| `Ctrl+Shift+D` | 向右分屏 |
| `Ctrl+Shift+E` | 向下分屏 |
| `Ctrl+Shift+方向键` | 切换分屏 |
| `Ctrl+Shift+Enter` | 切换当前分屏最大化 |
| `Ctrl+Shift+,` | 重新加载配置 |
| `Ctrl+Shift+Q` | 退出 Ghostty，包括后台进程 |

分屏快捷键在配置中显式定义，重新加载与退出使用 Ghostty 的默认绑定。

## 检查与同步

从仓库根目录检查待安装的文件：

```bash
ghostty +validate-config --config-file="$PWD/ghostty/config.ghostty"
```

若在本机调好配置后需要同步回仓库，在根目录执行：

```bash
cp "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config.ghostty" ghostty/config.ghostty
git diff -- ghostty/config.ghostty
```

只提交当前配置；`*.backup*` 等本机备份由根目录 `.gitignore` 排除。

参考：[Ghostty 配置文档](https://ghostty.org/docs/config)。
