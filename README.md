# Newspark Docker

Creates an scalable enviroment for newspark applications.

## RUN './newspark mongo init'!!

### Docker Instalation

Linux installation is pretty straight foward, just run the following:

```
#!bash
curl -sSL https://get.docker.com/ | sh

# or:

wget -qO - https://get.docker.com/ | sh
```

If you're using Mac Os, follow these [instructions](https://github.com/Newspark-UTN/docker-utils/wiki).

If you're using Windows, install [Docker Tools](https://www.docker.com/docker-toolbox).

### docker-compose

Docker compose is a tool to orquestrate docker containers, to install it you
need to have [pip](https://pip.pypa.io/en/stable/installing/) previouslly installed.

```
#!bash
sudo pip install docker-compose
```

Mac Users could use brew intead of pip:

```
#!bash
brew install docker-compose
```

## Add user to docker group (only for linux users)

```
#!bash
sudo gpasswd -a ${USER} docker
```
You may need to reboot/logout to this change make effect.

## First-time use

###Repositories file structure

It's recommended to have the following file structure:

```
newspark:
    \docker-utils # This repository
```

Other repositories will be installed at the same level of docker-utils
repository.

###Installation and provision of the repositories is pretty simple

1- Create a custom docker-compose.yml (docker-compose.yml.example it´s a good start)

2- (OPTIONAL) Add the docker-utils directory to your $PATH in your .bashrc or .zshrc or whatever
```
export PATH=$PATH:/path/to/docker-utils
```

### List commands usage
```
./newspark
```
