alias ll='ls -Fla'
alias rm='rm -i'
PS1='[Alpino] \w '
HOME=/work
cd ~/data
echo
echo Run \'info\' to get help
echo
if [ "$ADVERSION" != "3" ]
then
    echo "There is a new version of 'alpino.bash' and 'alpino.cmd'"
    echo Download the new version from https://github.com/rug-compling/alpino-docker
    echo
fi
