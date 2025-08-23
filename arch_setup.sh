#!/bin/bash

mkdir ~/Developer

sudo pacman -Syu
sudo pacman -S --needed base-devel git

echo
echo
echo
echo "==============================================================================================================================================="
echo "Installing pacman packages"
echo "-----------------------------------------------------------------------------------------------------------------------------------------------"
echo

for pkg in $(cat pacman_packages.txt); do
  sudo pacman -S --noconfirm "$pkg"
done

echo
echo "==============================================================================================================================================="
echo

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

sudo systemctl enable --now NetworkManager

ssh-keygen -t ed25519 -C "miha.rijavec24@gmail.com"

git clone https://aur.archlinux.org/yay.git ~/Developer/yay
cd ~/Developer/yay || exit
makepkg -si

echo
echo
echo
echo "==============================================================================================================================================="
echo "Installing yay packages"
echo "-----------------------------------------------------------------------------------------------------------------------------------------------"
echo

cd ~/dotfiles
for pkg in $(cat yay_packages.txt); do
  yay -S --noconfirm "$pkg"
done

echo
echo "==============================================================================================================================================="
echo

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

cd ~/dotfiles || exit
stow -vt ~ alacritty
stow -vt ~ hypr
stow -vt ~ waybar
stow -vt ~ wallpapers

cd ~ || exit
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

rm -rf ~/Developer/yay
rm -rf ~/Developer/alacritty

echo
echo
read -p "PRESS ANY KEY TO CONTINUE"
