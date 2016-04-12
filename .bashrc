# Load system bash configurations
if [ -f /etc/bashrc ]; then
    . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

##########
# Colors #
##########

# Upgrade xterm session to use colors.
# This will make tmux display the correct colors.
TERMINFO_LOCATIONS=(${HOME}/.terminfo /etc/terminfo /lib/terminfo /usr/share/terminfo)
if [ "$TERM" = "xterm" ]; then
    for terminfo in ${TERMINFO_LOCATIONS[@]}; do
        if [ -e $terminfo/x/xterm-256color ]; then
            export TERM=xterm-256color
        elif [ -e $terminfo/x/xterm-color ]; then
            export TERM=xterm-color
        fi
    done
fi
if [ "$TERM" = "screen" ]; then
    for terminfo in ${TERMINFO_LOCATIONS[@]}; do
        if [ -e $terminfo/s/screen-256color ]; then
            export TERM=screen-256color
        fi
    done
fi

# GNU ls supports colors!
# See dircolors to customize colors
export LS_OPTS='--color=auto'
alias  ls='ls ${LS_OPTS}'
alias  ll='ls ${LS_OPTS} -la'

# Get color support for 'less'
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS="--RAW-CONTROL-CHARS"

# Use colors for less, man, etc.
[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP

export GREP_OPTIONS="--color=auto"

##############
# Networking #
##############

#  To set a proxy add the file ~/.bash_proxy and insert your proxy url

function proxy()
{
    proxy_url="$(head -n 1 ~/.bash_proxy)"
    export  http_proxy="$proxy_url"
    export https_proxy="$proxy_url"
    export   ftp_proxy="$proxy_url"
}

function noproxy()
{
    export http_proxy=""
    export https_proxy=""
    export ftp_proxy=""
}

if [ -f ~/.bash_proxy ]; then
    proxy
else
    noproxy
fi


###########
# Aliases #
###########

# copy a stream in the X clipboard, e.g. "cat file | xcopy"
alias xcopy="xclip -i -selection clipboard"
# downgrade terminal to xterm in case the remote does not support colors
alias ssh='TERM=xterm ssh'

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
    . ~/.liquidpromptrc
    . ~/.liquidprompt
fi

###########
# Exports #
###########

if [ -f ~/.bash_exports ]; then
    . ~/.bash_exports
fi

##########
# Checks #
##########

#  Check if there are updates for the dofiles on a tracked master branch
#  Only check once after each reboot
if [ ! -f /tmp/bashrc_check ]; then
    cd $(dirname $(readlink -e ~/.bashrc))
    git fetch --all 2>&1 >/dev/null
    for remote in $(git remote show);
    do
        for branch in $(git branch --all --list);
        do
            if [[ $branch == *"${remote}/HEAD" ]]; then # true if tracking
                if [[ ! $(git rev-parse HEAD) == $(git rev-parse $remote/master) ]]; then
                    echo $(git rev-list HEAD...$remote/master --count)" new updates available for dotfiles from ${remote}/master!"
                fi
            fi
        done
    done
    touch /tmp/bashrc_check
    cd - 2>&1 >/dev/null
fi
