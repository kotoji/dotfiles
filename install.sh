#!/usr/bin/env bash

set -u

HOSTNAME=$(hostname)

function create_symlink() {
  src=$1
  dst=$2

  if [ ! -e $dst ]; then
    ln -sv "$src" "$dst"
  else
    echo "$dst already exists!"
  fi
}

function install_fish() {
  dst="$HOME/.config/fish"

  create_symlink "$PWD/.config/fish" "$dst"

  # env.fish はホストごとに設定を用意する
  env_template="$dst/conf.d/template/env.fish.$HOSTNAME"
  if [ ! -e "$env_template" ]; then
    touch "$env_template"
  fi
  if [ ! -e "$dst/conf.d/env.fish" ]; then
    ln -sv "$env_template" "$dst/conf.d/env.fish"
  fi
}

function install_git() {
  create_symlink "$PWD/.config/git" "$HOME/.config/git"
}

function install_spacevim() {
  create_symlink "$PWD/.SpaceVim.d" "$HOME/.SpaceVim.d"
}

function install_ideavimrc() {
  create_symlink "$PWD/.ideavimrc" "$HOME/.ideavimrc"
}

install_fish
install_git
install_spacevim
install_ideavimrc
