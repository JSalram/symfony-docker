#!/bin/bash

## Si ejecutamos el script desde la raiz, subimos un directorio ##
if [[ "${PWD##*/}" =~ scripts ]]; then
    cd ..
fi

function switch_version() {
    if [[ ! "$1" =~ [A-Za-z] ]]; then
        exit
    fi

    sed -i '1,2d' Dockerfile-php
    if [[ "$1" =~ 7 ]]; then
        sed -i '1s/^/FROM php:7.4-fpm\nRUN pecl install xdebug-3.1.5\n/' Dockerfile-php
    else
        sed -i '1s/^/FROM php:8.2-fpm\nRUN pecl install xdebug-3.2.1\n/' Dockerfile-php
    fi
}

if [[ ! "$(basename -- "$0")" =~ "init.sh" ]]; then
    printf "Versión actual: PHP "
    sed -n "1p" Dockerfile-php | grep -Eo "[7-8]\.[0-9]"
fi
PS3="Selecciona la versión de PHP que deseas arrancar: "
versions=("PHP 7.4" "PHP 8.2")
select version in "${versions[@]}"; do
    switch_version "$version"
    break
done
