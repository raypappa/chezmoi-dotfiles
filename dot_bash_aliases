alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias sync-to-main='git pull origin main --no-edit && git push'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias npm-exec='PATH=$(npm bin):$PATH'


alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color=auto -a'
function start-rdp {
    local instance_id=$1
    ssm-port $instance_id 3389 3389
}

function ssm-port {
    local target=$1
    local localport=$2
    local remoteport=$3
    aws ssm start-session \
        --target "$target" \
        --document-name AWS-StartPortForwardingSession \
        --parameters '''{"portNumber":["'$remoteport'"],"localPortNumber":["'$localport'"]}'
}

function start-session {
    local instance_id=$1
    aws ssm start-session --target "$instance_id"
}
function ssm {
  aws ssm start-session --target "${2}" --profile "${1}" --region us-east-1
}

fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
alias vim=nvim
