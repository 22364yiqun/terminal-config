# WezTerm config

Windows uses a warm charcoal palette with a Dracula Starship prompt for
PowerShell 7, Windows PowerShell 5.1, and Ubuntu (WSL). The standalone Linux
configuration uses Catppuccin Mocha. Both configurations use a compact tab bar, system window
controls, and 10,000 lines of scrollback.
Inspired by [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config).

## Files

| File | Platform | Purpose |
| --- | --- | --- |
| `wezterm-windows.lua` | Windows | PowerShell 7, JetBrainsMono Nerd Font Mono, and a warm charcoal palette |
| `wezterm-linux.lua` | Linux | `$SHELL -l` (or `/bin/bash -l`), JetBrains Mono, and Catppuccin Mocha |
| `wezterm.lua` | Auto-detect | Loads the matching platform file from the same directory |
| `starship.toml` | Windows and WSL | Two-line Dracula prompt with directory, Git, and environment information |
| `powershell-profile-snippet.ps1` | Windows | Loads the Starship prompt in WezTerm sessions for PowerShell 7 and Windows PowerShell 5.1 |
| `zshrc-snippet.zsh` | WSL | Loads the same Starship prompt in Ubuntu zsh sessions |

Both platform Lua files are standalone. Back up any existing configuration
before copying the matching file to `.wezterm.lua`.

## Install on Windows

1. Install [WezTerm](https://wezterm.org/install/windows.html) and PowerShell 7.
   Install Starship if you want the Dracula prompt.

   ```powershell
   winget install --id Microsoft.PowerShell --exact
   winget install --id Starship.Starship --exact
   ```

2. Install the `JetBrainsMonoNerdFontMono-*.ttf` faces from the
   [JetBrains Mono Nerd Font release](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip),
   or place them in `%USERPROFILE%\.config\wezterm-dracula\fonts\` so WezTerm
   can load them directly.

3. From this repository directory, run:

   ```powershell
   $weztermConfig = Join-Path $HOME '.wezterm.lua'
   if (Test-Path -LiteralPath $weztermConfig) {
     Copy-Item -LiteralPath $weztermConfig -Destination "$weztermConfig.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
   }
   Copy-Item -LiteralPath '.\wezterm-windows.lua' -Destination $weztermConfig
   ```

4. For the Starship prompt, copy the shared theme once:

   ```powershell
   $themeDir = Join-Path $HOME '.config\wezterm-dracula'
   New-Item -ItemType Directory -Force -Path $themeDir | Out-Null
   Copy-Item -LiteralPath '.\starship.toml' -Destination $themeDir
   ```

5. PowerShell 7 and Windows PowerShell 5.1 each load a separate profile. Run
   the following in each shell you use, opening it from WezTerm's `+` menu:

   ```powershell
   $profilePath = $PROFILE.CurrentUserCurrentHost
   New-Item -ItemType Directory -Force -Path (Split-Path -Parent $profilePath) | Out-Null
   notepad $profilePath
   ```

   Add the contents of `powershell-profile-snippet.ps1` once to each profile.
   Keep your existing profile and merge any existing prompt initialization.
   Open a new tab in each shell to load the prompt.

### Open PowerShell and Ubuntu

Click `+` to choose PowerShell 7, Windows PowerShell, or Ubuntu (WSL). The
Ubuntu entry requires a WSL distribution named `Ubuntu`. It uses the same
WezTerm window theme and its own Ubuntu shell prompt.

In Windows Explorer, right-click a folder or its background and select
**Show more options → Open WezTerm here** to start in that directory. This
entry comes from the Windows WezTerm installer.

The configuration sets `dpi = 120.0` for the current multi-monitor setup.
Adjust it if you use different display scaling.

### Set up the Dracula prompt in WSL

Use the Windows WezTerm configuration above, then open **Ubuntu (WSL)** from
the `+` menu. The Windows app provides the colors and fonts for the window.
Install Starship inside Ubuntu to apply the same prompt to zsh.

1. In Ubuntu with zsh, install Starship using its
   [official installer](https://starship.rs/guide/).

   ```bash
   mkdir -p "$HOME/.local/bin"
   curl -fsSL https://starship.rs/install.sh | sh -s -- -b "$HOME/.local/bin"
   ```

2. From the repository directory in Ubuntu, copy the shared theme and back
   up your zsh configuration. If the repository is on your Windows desktop,
   open it from `/mnt/c/Users/<Windows-user>/Desktop/wezterm-config`.

   ```bash
   theme_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
   stamp="$(date +%Y%m%d-%H%M%S)"
   mkdir -p "$theme_dir"
   if [ -e "$theme_dir/starship.toml" ]; then
     cp -p "$theme_dir/starship.toml" "$theme_dir/starship.toml.backup-$stamp"
   fi
   cp starship.toml "$theme_dir/starship.toml"
   if [ -e "$HOME/.zshrc" ]; then
     cp -p "$HOME/.zshrc" "$HOME/.zshrc.backup-$stamp"
   fi
   ```

3. If you use Conda, add this block above `# >>> conda initialize >>>` in
   `~/.zshrc` so Starship displays the active environment.

   ```zsh
   if [[ -x "$HOME/.local/bin/starship" ]]; then
       export CONDA_CHANGEPS1=false
   fi
   ```

4. Add the contents of `zshrc-snippet.zsh` to the end of `~/.zshrc` once.
   If the file already initializes Starship, keep a single initialization
   block. Open a new Ubuntu tab to load the prompt.

## Install on Linux

1. Install [WezTerm](https://wezterm.org/install/linux.html).
2. On Ubuntu/Debian, install the fonts:

   ```bash
   sudo apt install fonts-jetbrains-mono fonts-noto-cjk fonts-noto-color-emoji
   ```

3. From this repository directory, install the standalone Linux configuration:

   ```bash
   if [ -e "$HOME/.wezterm.lua" ]; then
     cp "$HOME/.wezterm.lua" "$HOME/.wezterm.lua.backup-$(date +%Y%m%d-%H%M%S)"
   fi
   cp wezterm-linux.lua "$HOME/.wezterm.lua"
   ```

The Linux configuration uses your current `$SHELL`, so no zsh installation is required.

## Automatic platform selection (optional)

Instead of the standalone installation above, copy **all three Lua files** into
`~/.config/wezterm/` on Linux, or `%USERPROFILE%\.config\wezterm\` on Windows.
Keep their filenames unchanged. `wezterm.lua` selects the platform automatically.
Move an existing `~/.wezterm.lua` / `%USERPROFILE%\.wezterm.lua` aside after backing
it up, because that file takes precedence over the configuration directory.

## Key bindings

The shortcuts below apply to both platforms unless marked Windows only.

| Keys | Action |
| --- | --- |
| `Alt+D` | Split left/right |
| `Alt+Shift+D` | Split top/bottom |
| `Ctrl+Shift+T` | New tab in the current shell domain |
| `Ctrl+Alt+U` | Open an Ubuntu tab (Windows only) |
| `Ctrl+Alt+P` | Open a Windows PowerShell tab (Windows only) |
| `Alt+Left` / `Alt+Right` | Move between panes |
| `Ctrl+Shift+W` | Close current pane, with confirmation |

Other WezTerm shortcuts keep their defaults. See the
[default key assignments](https://wezterm.org/config/default-keys.html).
Configuration reloads automatically; press `Ctrl+Shift+R` to reload manually.

## Reference

- [WezTerm configuration file locations](https://wezterm.org/config/files.html)
- [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)
