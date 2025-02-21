#!/bin/bash

set -xueEo pipefail

umask o-w

mkdir -m 700 -p ~/.ssh/s

# ssh_agent="$(ssh-agent -st 20h)"
# eval "$ssh_agent"
# trap 'ssh-agent -k >/dev/null' INT TERM EXIT
# ssh-add ~/.ssh/id_rsa

rm -rf ~/.cache

sudo apt-get update
sudo sh -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade -y'
sudo apt-get autoremove -y
sudo apt-get autoclean

sudo apt-get install -y curl git zsh
sudo chsh -s /bin/zsh "$USER"

tmpdir="$(mktemp -d)"
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" \
  git clone --depth=1 git@github.com:slickag/dotfiles-public.git -b main "$tmpdir"
bootstrap="$(<"$tmpdir"/bin/bootstrap-dotfiles.sh)"
rm -rf -- "$tmpdir"
bash -c "$bootstrap"

zsh -fec 'fpath=(~/dotfiles/functions $fpath); autoload -Uz sync-dotfiles; sync-dotfiles'

# bash ~/bin/setup-machine.sh

if [[ -f ~/bin/bootstrap-machine-private.zsh ]]; then
  zsh ~/bin/bootstrap-machine-private.zsh
fi

if [[ -t 0 && -n "${WSL_DISTRO_NAME-}" ]]; then
  read -p "Need to restart WSL to complete installation. Terminate WSL now? [y/N] " -n 1 -r
  echo
  if [[ ${REPLY,,} == @(y|yes) ]]; then
    wsl.exe --terminate "$WSL_DISTRO_NAME"
  fi
fi
