# Alpino in Docker

Running Alpino inside Docker.

About Alpino: http://www.let.rug.nl/vannoord/alp/Alpino/

**Windows**

If you are using *Docker for Windows* you need `alpino.cmd`.
In the examples below substitute `alpino.cmd` for `alpino.bash`.

If you are using *Docker Toolbox* you need `alpino.bash`.

**Linux, Mac**

You need `alpino.bash`.


## Upgrade

If you have been using an older version of `alpino.bash`, you may need
to update the Docker image:

    alpino.bash -u


## Starting Docker

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


## Running Alpino inside Docker

Inside Docker, you can run Alpino (the actual application) interactively.

If you have access to an X11 server, this will start the Alpino GUI:

    Alpino


This starts and interactive version of Alpino without the GUI:

    Alpino -notk


But mostly you will use Alpino as a command line tool, along with a
number of other tools for doing things with corpora.

There are a lot of things you can do, beyond tokenizing en parsing text.

- there are tools for editing, searching, transforming and visualizing
  parsed documents
- you can view [Universal Dependencies](https://universaldependencies.org/)
- you can save whole or partial parse trees, as well as Universal
  Dependencies, as bitmap or vector images

For a step by step introduction, run:

    info
