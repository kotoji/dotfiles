#!/usr/bin/env bash

set -u

HOSTNAME=$(hostname)

function install_fish() {
  fishd="$HOME/.config/fish"

  # 設定ファイルを symlink
  if [ ! -e "$fishd" ]; then
    ln -sv "$PWD/.config/fish" "$fishd"
  else
    echo "$fishd already exists"
  fi

  # env.fish はホストごとに設定を用意する
  env_template="$fishd/conf.d/template/env.fish.$HOSTNAME"
  if [ ! -e "$env_template" ]; then
    touch "$env_template"
  fi
  if [ ! -e "$fishd/conf.d/env.fish" ]; then
    ln -sv "$env_template" "$fishd/conf.d/env.fish"
  fi
}

function install_git() {
  gitd="$HOME/.config/git"

  # 設定ファイルを symlink
  if [ ! -e "$gitd" ]; then
    ln -sv "$PWD/.config/git" "$gitd"
  else
    echo "$gitd already exists"
  fi
}


install_fish
install_git
