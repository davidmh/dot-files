# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd notify menucomplete
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select

autoload -Uz compinit
compinit -D
# End of lines added by compinstall

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

alias ll="ls -lpG"

alias vim="nvim"

function mov2gif() {
  MOVNAME=$1
  GIFNAME="${MOVNAME//.mov/.gif}"
  ffmpeg -ss 00:00:00.000 -i "$MOVNAME" -pix_fmt rgb24 -r 10 -t 00:00:10.000 "$GIFNAME"
}

MNML_PROMPT=(custom_left_prompt)
MNML_RPROMPT=(custom_right_prompt)
MNML_USER_CHAR="❯❯"
MNML_OK_COLOR=5

# prompts
function fish_style_pwd {
    echo $(pwd | perl -pe '
        BEGIN {
            binmode STDIN,  ":encoding(UTF-8)";
            binmode STDOUT, ":encoding(UTF-8)";
        }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
    ')
}

function git_stat {
    local git_branch=$(mnml_git)
    if [ -n "$git_branch" ]; then
        local gstat="$(git diff --shortstat 2> /dev/null | \
            sed -E 's/^\ //g' | \
            sed -E 's/\ files?\ changed/±/g' | \
            sed -E 's/insertions?//g' | \
            sed -E 's/deletions?//g' | \
            sed 's/[(),]//g' | \
            sed 's/\ +/+/g' | \
            sed 's/\ -/-/g')"
        if [ -n "$gstat" ]; then
            echo -n "[$(mnml_git) %{\e[0;3${MNML_ERR_COLOR}m%}$gstat%{\e[0m%}]"
        else
            echo "[$git_branch]"
        fi
    fi
}

function custom_left_prompt {
  echo "$(fish_style_pwd) $(mnml_status)"
}

function custom_right_prompt {
    if [ -z "$INSIDE_EMACS" ]; then
        git_stat
    fi
}

function fzf-git-branch-checkout {
  git branch | grep -v "*" | fzf | sed 's/\ *//g' | xargs git checkout
}

# https://unix.stackexchange.com/a/250700
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-flow-avh", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/dirhistory", from:oh-my-zsh
zplug "plugins/chruby", from:oh-my-zsh
zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

# Load "emoji-cli" if "jq" is installed in this example
zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq

zplug "b4b4r07/emoji-cli", \
    on:"stedolan/jq"

 zplug "mafredri/zsh-async", from:github

zplug "subnixr/minimal", as:theme, use:minimal.zsh

zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-completions"

zplug "g-plane/zsh-yarn-autocompletions", hook-build:"./zplug.zsh", defer:2

zplug load

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^ ' autosuggest-accept

export NVIM_LISTEN_ADDRESS=/tmp/nvim.sock

eval "$(pyenv init -)"

export EDITOR="nvim"
export TERM=xterm-256color
export MANPAGER="nvim -c 'set ft=man' -"

