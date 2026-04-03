Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
oh-my-posh init pwsh --config "$env:USERPROFILE\.config\ohmyposh\tokyonight_storm.omp.json" | Invoke-Expression  # use --config "path to config" for themes, I use tokyonight_storm
#dotfiles come with few of them preinstalled, mainly the cleaner ones out there

Invoke-Expression (& { (zoxide init powershell | Out-String) })  # zoxide, via author
