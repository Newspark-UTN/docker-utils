#!/bin/bash

function run_command () {
    out "<32;1>Running command: $*<0>"
    docker-compose run --rm api sh -c "${*}"
    out "<33;1>Command finished<0>"
}

function npm () {
    run_command "npm ${*}"
}

function logs () {
    docker logs -f api
}

function restart () {
    docker-compose stop api && docker-compose rm -f api && docker-compose up -d api
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>c|command<0>                Run a command in the container. (Eg: /bin/bash).<0>
  <32;1>l|logs<0>                   Show logs.<0>
  <32;1>n|npm<0>                    Run a npm command. (Eg: install).<0>
  <32;1>r|restart<0>                Restart process.<0>
'
}

function run () {
    case $1 in
        c|command)
            shift;
            run_command $*
            exit 0
        ;;
        n|npm)
            shift;
            npm $*
            exit 0
        ;;
        l|logs)
            logs
            exit 0
        ;;
        r|restart)
            restart
            exit 0
        ;;
        *)
            out "los metodos son: '${*}'"
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
