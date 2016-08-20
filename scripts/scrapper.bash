#!/bin/bash

function run_command () {
    out "<32;1>Running command: $*<0>"
    docker-compose run --rm scrapper sh -c "${*}"
    out "<33;1>Command finished<0>"
}

function npm () {
    run_command "npm ${*}"
}

function scrapper () {
    run_command "node app.js"
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>c|command<0>                Run a command in the container. (Eg: /bin/bash).<0>
  <32;1>n|npm<0>                    Run a npm command. (Eg: install).<0>
  <32;1>r|run<0>                    Execute scrapping.<0>
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
        r|run)
            scrapper
            exit 0
        ;;
        *)
            out "los metodos son: '${*}'"
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
