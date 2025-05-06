#!/bin/bash

mkdir ~/Developer

sudo pacman -Syu
sudo pacman -S --needed base-devel git
sudo pacman -S htop neofetch ufw sl wget curl zip unzip cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python neovim lazygit wl-clipboard fzf ripgrep fd discord zsh stow nodejs npm hyprland wofi waybar
yay -S hyprshot swaync hyprlock hypridle hyprpaper

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

sudo pacman -S fail2ban

git clone https://aur.archlinux.org/yay.git ~/Developer/yay
cd ~/Developer/yay || exit
makepkg -si

yay -Sy brave-bin steam

cd ~/Downloads || exit
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ./new_fonts
sudo mv new_fonts/*.ttf /usr/share/fonts/
fc-cache -vf

cd ~/Developer || exit
git clone https://github.com/alacritty/alacritty.git
cd alacritty || exit
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"
rustup override set stable
rustup update stable
cargo build --release
if ! infocmp alacritty; then
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
fi
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

cd ~/dotfiles || exit
rm ~/.zshrc
stow -vt ~ zsh
stow -vt ~ alacritty
stow -vt ~ hypr
stow -vt ~ waybar
stow -vt ~ wallpapers

cd ~ || exit
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

rm -rf ~/Developer/yay
rm -rf ~/Developer/alacritty
