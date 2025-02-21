#!/bin/bash

set -xueEo pipefail

umask o-w

mkdir -m 700 -p ~/.ssh/s

# ssh_agent="$(ssh-agent -st 20h)"
# eval "$ssh_agent"
# trap 'ssh-agent -k >/dev/null' INT TERM EXIT
# ssh-add ~/.ssh/id_rsa

# rm -rf ~/.cache

tmpdir="$(mktemp -d)"
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" \
  git clone --depth=1 git@github.com:slickag/dotfiles-public.git -b darwin "$tmpdir"
bootstrap="$(<"$tmpdir"/bin/bootstrap-dotfiles.sh)"
rm -rf -- "$tmpdir"
bash -c "$bootstrap"

zsh -fec 'fpath=(~/dotfiles/functions $fpath); autoload -Uz sync-dotfiles; sync-dotfiles'

# bash ~/bin/setup-machine.sh

if [[ -f ~/bin/bootstrap-machine-private.zsh ]]; then
  zsh ~/bin/bootstrap-machine-private.zsh
fi
