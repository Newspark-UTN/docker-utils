#!/bin/bash

function artisan () {
    out "<32;1>Running artisan $1<0>"
    shift;
    docker-compose run --rm web sh -c "./artisan ${*}"
    out "<33;1>artisan $1 finished<0>"
}

function composer () {
    shift;
    out "<32;1>Running composer $*<0>"
    docker-compose run --rm web sh -c "composer $*"
    out "<33;1>composer $1 finished<0>"
}

function grunt () {
    out "<32;1>Running grunt $1<0>"
    shift;
    docker-compose run --rm web sh -c "grunt ${*}"
    out "<33;1>grunt $1 finished<0>"
}

function bower () {
    out "<32;1>Running bower $1<0>"
    shift;
    docker-compose run --rm web sh -c "bower ${*}"
    out "<33;1>bower $1 finished<0>"
}

function npm () {
    out "<32;1>Running npm $1<0>"
    shift;
    docker-compose run --rm web sh -c "npm ${*}"
    out "<33;1>npm $1 finished<0>"
}

function langjs () {
    out "<32;1>Running php artisan lang:js<0>"
    docker-compose run --rm web sh -c "php artisan lang:js app/frontend/javascript/packages/messages.js"
    out "<33;1>php artisan lang:js finished<0>"
}

function php-cs-fixer () {
    out "<32;1>Running php-cs-fixer $1<0>"
    shift;
    docker-compose run --rm web sh -c "/trocafone/vendor/bin/php-cs-fixer fix ${*}"
    out "<33;1>php-cs-fixer $1 finished<0>"
}

function tests () {
    shift;
    out "<32;1>Running phpunit --bootstrap bootstrap/test.php --no-coverage tests/unit ${*}<0>"
    docker-compose run --rm web sh -c "/trocafone/vendor/bin/phpunit --bootstrap bootstrap/test.php --no-coverage tests/unit ${*}"
    out "<33;1>PHP Unit finished<0>"
}

function tests_integration () {
    shift;
    out "<32;1>Running phpunit --bootstrap bootstrap/test.php --no-coverage tests/integration ${*}<0>"
    docker-compose run --rm web sh -c "/trocafone/vendor/bin/phpunit --bootstrap bootstrap/test.php --no-coverage tests/integration ${*}"
    out "<33;1>PHP Unit finished<0>"
}

function logs () {
    out "<32;1>Running logs<0>"
    docker-compose run --rm web sh -c "tail -f /trocafone/app/storage/logs/laravel.log"
    out "<33;1>End logs<0>"
}

function install_web () {
    out "<32;1>Installing Web<0>"
    out "<32;1>Changing Solr folder permissions<0>"
    sudo chmod -R 777 ../solr/collection1/data
    sudo chmod -R 777 ../solr/locations/data

    out "<32;1>Changing Web folder permissions<0>"
    sudo chmod -R 777 ../web/app/storage

    out "<32;1>Copying docker env configuration. DO NOT COMMIT THE .env.local.php!!!<0>"
    cp ../web/.env.local.php{.docker,}

    out "<32;1>Installing depedencies (composer, npm, bower and grunt) <0>"
    composer install
    npm -- install
    bower -- install --allow-root
    grunt -- build

    out "<32;1>Migrations<0>"
    artisan -- migrate

    out "<32;1>Indexing solr<0>"
    artisan -- solr:index
    artisan -- solr:locations

    out "<33;1>Web installation complete.<0>"
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>-i|--install<0>                  Perform a complete container provisioning.<0>
  <32;1>-a|--artisan<0>                  Artisan cli tasks.<0>
  <32;1>-c|--composer<0>                 Install composer depedencies.<0>
  <32;1>-g|--grunt<0>                    Run grunt tasks.<0>
  <32;1>-b|--bower<0>                    Run bower tasks.<0>
  <32;1>-n|--npm<0>                      NPM tasks.<0>
  <32;1>-t|--test<0>                     Run unit test suite.<0>
  <32;1>-ti|--tests_integration<0>       Run integration test suite.<0>
  <32;1>-cs|--php-cs-fixer<0>            Run php-cs-fixer.<0>
  <32;1>-j|--lang-js<0>                  Run php artisan lang:js.<0>
  <32;1>-l|--logs<0>                     Run tail -f logs.<0>
'
}

function run () {
    case $1 in
        -c|--composer)
            composer $*
            exit 0
        ;;
        -i|--install)
            install_web
            exit 0
        ;;
        -a|--artisan)
            artisan $*
            exit 0
        ;;
        -g|--grunt)
            grunt $*
            exit 0
        ;;
        -b|--bower)
            bower $*
            exit 0
        ;;
        -n|--npm)
            npm $*
            exit 0
        ;;
        -cs|--php-cs-fixer)
            php-cs-fixer $*
            exit 0
        ;;
        -t|--test)
            tests $*
            exit 0
        ;;
        -ti|--tests_integration)
            tests_integration $*
            exit 0
        ;;
        -j|--lang-js)
            langjs
            exit 0
        ;;
        -l|--logs)
            logs
            exit 0
        ;;
        *)
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
