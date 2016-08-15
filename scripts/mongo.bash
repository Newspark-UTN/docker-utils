#!/bin/bash

function run_command () {
    out "<32;1>Running command: $*<0>"
    docker exec -it mongo_database sh -c "${*}"
    out "<33;1>Command finished<0>"
}

function cli () {
    if [ -z "$1" ]; then
        run_command "mongo -u newspark -p newspark newspark"
    else
        run_command "mongo $*"
    fi
}

function init () {
    out "<32;1>Initializing database<0>"
    docker exec -it mongo_database mongo newspark /opt/defaults/init.js
    out "<33;1>Command finished<0>"
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>m|cmd|command<0>            Run a command in the container. (Eg: /bin/bash).<0>
  <32;1>c|cli<0>                    Run mongo CLI. If no database is specify will use: newspark with defaul login.<0>
  <32;1>init<0>                     Init database. Run only once.<0>
'
}

function run () {
    case $1 in
        init)
            init
            exit 0
        ;;
        m|cmd|command)
            shift;
            run_command $*
            exit 0
        ;;
        c|cli)
            shift;
            cli $*
            exit 0
        ;;
        *)
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
