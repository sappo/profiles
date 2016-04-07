# Upgrade xterm session to use colors.
# This will make tmux display the correct colors.
if [ "$TERM" = "xterm" ]; then
    if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM=xterm-256color
    elif [ -e /usr/share/terminfo/x/xterm-color ]; then
        export TERM=xterm-color
    fi
fi
if [ "$TERM" = "screen" ]; then
    if [ -e /usr/share/terminfo/s/screen-256color ]; then
        export TERM=screen-256color
    fi
fi

# Load system bash configurations
if [ -f /etc/bashrc ]; then
    . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

##############
# Networking #
##############

function proxy()
{
    proxy_url="$(~/proxy.sh)"
    export  http_proxy="$proxy_url"
    export https_proxy="$proxy_url"
    export   ftp_proxy="$proxy_url"
    echo ${proxy_url##*@}
}

function noproxy()
{
    export http_proxy=""
    export https_proxy=""
    export ftp_proxy=""
}

###########
# Aliases #
###########

# copy a stream in the X clipboard, e.g. "cat file | xcopy"
alias xcopy="xclip -i -selection clipboard"
# downgrade terminal to xterm in case the remote does not support colors
alias ssh='TERM=xterm ssh'
alias ls='ls --color'
alias ll='ls --color -la'

###########
# History #
###########

# do not permits to recall dangerous commands in bash history
export HISTIGNORE='&:[bf]g:exit:*>|*:*rm*-rf*:*rm*-f*'
# append history rather than overwrite
shopt -s histappend
# one command per line
shopt -s cmdhist
unset HISTFILESIZE
HISTSIZE=1000000
# ignore commands that start with a space AND duplicate commands
HISTCONTROL=ignoreboth
# add the full date and time to lines
HISTTIMEFORMAT='%F %T '

#########
# Other #
#########

# Use liquidprompt only if in an interactive shell
if [[ $- == *i* ]]; then
    ## Super nice prompt
    source ~/.liquidpromptrc
    source ~/.liquidprompt
fi

###########
# Exports #
###########

export PATH=/home/ksapper/Workspace/esp-open-sdk/xtensa-lx106-elf/bin:$PATH
