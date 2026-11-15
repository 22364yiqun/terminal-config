# BEGIN WezTerm Dracula prompt
if ($env:TERM_PROGRAM -eq 'WezTerm' -or $env:WEZTERM_PANE) {
    if (Get-Command starship -CommandType Application -ErrorAction SilentlyContinue) {
        $env:STARSHIP_CONFIG = Join-Path $HOME '.config\wezterm-dracula\starship.toml'
        $env:CONDA_CHANGEPS1 = 'false'
        Invoke-Expression (&starship init powershell)
    }
}
# END WezTerm Dracula prompt
