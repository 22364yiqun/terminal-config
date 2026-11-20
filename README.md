# Terminal config

个人终端配置：**Windows 使用 WezTerm，Linux 使用 Ghostty**。

| 目录 | 主要平台 | 内容 |
| --- | --- | --- |
| [wezterm/](wezterm/README.md) | Windows / WSL | WezTerm 配置、Dracula Starship 提示符、PowerShell 与 WSL zsh 初始化片段 |
| [ghostty/](ghostty/README.md) | Linux（Ubuntu / GNOME） | 本机正在使用的 Ghostty 配置与安装说明 |

```text
.
├── README.md
├── wezterm/
│   ├── README.md
│   ├── wezterm.lua                   # 自动选择 WezTerm 平台配置
│   ├── wezterm-windows.lua           # Windows 主配置
│   ├── wezterm-linux.lua             # 旧 Linux 配置，作为备用保留
│   ├── starship.toml                 # Windows / WSL 提示符主题
│   ├── powershell-profile-snippet.ps1
│   └── zshrc-snippet.zsh
└── ghostty/
    ├── README.md
    └── config.ghostty                # Linux 主配置
```

## 使用

- **Windows / WSL**：按 [WezTerm 安装说明](wezterm/README.md) 操作。该说明中的命令在仓库的 `wezterm/` 子目录执行。
- **Linux**：按 [Ghostty 安装说明](ghostty/README.md) 操作。该说明中的命令在仓库根目录执行。

两个终端的配置分别维护，保留各自现有的配色与快捷键。
Ghostty 配置来自本机 `${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config.ghostty`，未收录历史备份和桌面启动器。

## 从旧仓库布局迁移

原根目录下的 WezTerm 配置、Starship 主题和 shell 片段全部移入 `wezterm/`，内容保持不变。
如果此前直接引用了仓库内的文件（例如符号链接或脚本），请在原路径中加入 `wezterm/`。
此前复制到用户配置目录的文件可以继续使用。

建议仓库名为 `terminal-config`。远端仓库若完成改名，可更新本地地址：

```bash
git remote set-url origin https://github.com/22364yiqun/terminal-config.git
```

以上命令仅更新本地 remote，不会重命名 GitHub 仓库。
