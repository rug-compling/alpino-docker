# Alpino in Docker #

Runing Alpino inside Docker.

About Alpino: http://www.let.rug.nl/vannoord/alp/Alpino/

**Windows**

If you are using *Docker for Windows* you need `alpino.cmd`.
In the examples below substitute `alpino.cmd` for `alpino.bash`.

If you are using *Docker Toolbox* you need `alpino.bash`.

**Linux, Mac**

You need `alpino.bash`.


## Upgrade ##

If you have been using an older version of `alpino.bash`, you may need
to update the Docker image:

    alpino.bash -u


## Starting Alpino in Docker ##

There are two ways of starting Alpino in Docker.

**1—** This brings you into a bash shell inside Docker, where you can run
Alpino itself:

    alpino.bash $HOME/alpino

Inside the shell, there is a virtual directory `~/data` that corresponds
to the real directory you gave as an argument to the script, in this
case `$HOME/alpino`. You use it to save and access data on your regular
file system.

**2—** You can also run a single command, without going to the shell first:

    alpino.bash $HOME/alpino Alpino

In this case, there is no directory `~/data` in Docker, but there is
`/work/data` with the same purpose.


## Examples of running Alpino inside Docker ##

Inside Docker, you can run Alpino interactively, or as a command line
tool.


### Interactive use ###

If you have access to an X11 server, then this starts the Alpino GUI:

    Alpino


This starts and interactive version of Alpino without the GUI:

    Alpino -notk


### Use as a command line tool ###

This tokenizes and parses the text from `~/voorbeelden/weerbericht.txt`
and saves the results in the directory `~/data/xml`:

    cd ~/data
    mkdir xml
    partok ~/voorbeelden/weerbericht.txt | Alpino -flag treebank xml debug=1 end_hook=xml user_max=900000 -parse

If you have access to an X11 server, you can view the generated trees:

    dtview xml/*.xml

... or edit the trees:

    dttred xml/*.xml

Create a corpus in the DACT format:

    cd xml
    mkcorpus ../weer.dact *.xml
    cd ..

... and inspect the corpus with the dact program:

    dact weer.dact

