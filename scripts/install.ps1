# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git
scoop bucket add extras
scoop bucket add nerd-fonts

scoop install alacritty
scoop install neovim
scoop install gh
scoop install JetBrainsMono-NF
scoop install uutils-coreutils
scoop install vcredist2022
scoop install yazi
scoop install openssh

New-Item "$env:APPDATA\alacritty\alacritty.toml" -ItemType File -Force

@"
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
"@ | Add-Content -Path "$env:APPDATA\alacritty\alacritty.toml"

# git clone https://github.com/izzalDev/NvChad.git $ENV:USERPROFILE\AppData\Local\nvim
# nvim --headless "+Lazy! sync" +qa



