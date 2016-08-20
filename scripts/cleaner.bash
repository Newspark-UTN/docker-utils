#!/bin/bash

function run_command () {
    out "<32;1>Running command: $*<0>"
    docker-compose run --rm cleaner sh -c "${*}"
    out "<33;1>Command finished<0>"
}

function sbt () {
    run_command "sbt ${*}"
}

function cleaner () {
    run_command "spark-submit --class org.edu.utn.newspark.lsa.LSA target/scala-2.11/lsa.jar"
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>c|command<0>                Run a command in the container. (Eg: /bin/bash).<0>
  <32;1>s|sbt<0>                    Run a SBT command. (Eg: run).<0>
  <32;1>r|run<0>                    Execute spark.<0>
'
}

function run () {
    case $1 in
        c|command)
            shift;
            run_command $*
            exit 0
        ;;
        s|sbt)
            shift;
            sbt $*
            exit 0
        ;;
        r|run)
            cleaner
            exit 0
        ;;
        *)
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
