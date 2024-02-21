PATH=/opt/bin:/opt/go/bin:/sp/bin:/usr/lib/go-1.13/bin:$PATH
export LANG=en_US.utf8
export LANGUAGE=en_US.utf8
export LC_ALL=en_US.utf8
export COLUMNS
export LINES
export EDITOR=nano

alias ..='cd ..'
alias beep='echo -e '\''\a\c'\'
alias ll='ls -Fla'
alias rm='rm -i'
alias mc='. /usr/share/mc/bin/mc-wrapper.sh'
alias path='echo $PATH | perl -p -e "s/:/\n/g"'

PS1='[docker:'"$(< /etc/issue.net)"'] \u:\w\$ '

umask 002

cd /opt
