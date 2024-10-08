[[ $- == *i* ]] || return  # non-interactive shell

HISTCONTROL=ignoreboth
HISTSIZE=1000000000
HISTFILESIZE=1000000000
HISTFILE="$HOME"/.bash_history

export LS_COLORS='rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:'
LS_COLORS+='pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:'

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

if command -v lesspipe &>/dev/null; then
  export LESSOPEN="| /usr/bin/env lesspipe %s 2>&-"
fi

alias diff='diff --color=auto'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
# alias clang-format='clang-format -style=file'
# alias ls='ls --color=auto --group-directories-first'
# alias tree='tree -aC -I .git --dirsfirst'
# alias gedit='gedit &>/dev/null'

# alias x='xclip -selection clipboard -in'          # cut to clipboard
# alias v='xclip -selection clipboard -out'         # paste from clipboard
# alias c='xclip -selection clipboard -in -filter'  # copy clipboard

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

if [[ -d ~/gitstatus ]]; then
  GITSTATUS_LOG_LEVEL=DEBUG
  source ~/gitstatus/gitstatus.prompt.sh
else
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\] '           # green user@host
  PS1+='\[\033[01;34m\]\w\[\033[00m\]'              # blue current working directory
  PS1+='\n\[\033[01;$((31+!$?))m\]\$\[\033[00m\] '  # green/red (success/error) $/# (normal/root)
  PS1+='\[\e]0;\u@\h: \w\a\]'                       # terminal title: user@host: dir
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    [ "${PATH#*$HOME/.cargo/bin:}" == "$PATH" ] && export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    [ "${PATH#*$HOME/.local/bin:}" == "$PATH" ] && export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    [ "${PATH#*$HOME/bin:}" == "$PATH" ] && export PATH="$HOME/bin:$PATH"
fi

[ -f /usr/share/fzf/key-bindings.bash ] && . /usr/share/fzf/key-bindings.bash

# Eliminate duplicate PATH entries if any.
# export PATH=$(echo $PATH | awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}' | sed -e 's|.*:$||')
export QT_QPA_PLATFORM=wayland

PROMPT_DIRTRIM=3

[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"

[ -d "$HOME/.nvm" ] && export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
