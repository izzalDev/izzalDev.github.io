#!/bin/bash
echo "Setting up environment..."

apt update
apt install -y curl git openssh-server gh neovim yazi
curl -sS https://starship.rs/install.sh | sh
git clone https://github.com/izzalDev/NvChad.git ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
echo 'eval "$(starship init bash)"' >> ~/.bashrc
echo "Environment setup complete"
