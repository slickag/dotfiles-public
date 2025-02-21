#!/bin/bash
#
# Clones dotfiles-public and dotfiles-private from github. Requires `git` and ssh
# keys for github.

set -xueEo pipefail

function clone_repo() {
  local repo=$1
  local git_dir="$HOME/.$repo"
  local uri="git@github.com:slickag/$repo.git"

  if [[ -e "$git_dir" ]]; then
    return 0
  fi

  git --git-dir="$git_dir" init -b darwin
  git --git-dir="$git_dir" config core.bare false
  git --git-dir="$git_dir" config status.showuntrackedfiles no
  git --git-dir="$git_dir" remote add origin "$uri"
  git --git-dir="$git_dir" fetch
  git --git-dir="$git_dir" reset origin/darwin
  git --git-dir="$git_dir" branch -u origin/darwin
  git --git-dir="$git_dir" checkout -- .
  git --git-dir="$git_dir" submodule update --init --recursive
}

if [[ "$(id -u)" == 0 ]]; then
  echo "bootstrap-dotfiles.sh: please run as non-root" >&2
  exit 1
fi

clone_repo dotfiles-public
clone_repo dotfiles-private

git --git-dir="$HOME"/.dotfiles-public \
  remote add upstream 'https://github.com/romkatv/dotfiles-public.git'
