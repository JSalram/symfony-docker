#!/bin/bash

## Si ejecutamos el script desde la raiz, subimos un directorio ##
if [[ "${PWD##*/}" =~ scripts ]]; then
    cd ..
fi

local_path='\.\/symfony\/'
container_path='\/var\/www\/symfony\/'
project=$(grep -oP "(?<=COPY $local_path).+(?=\\/ $container_path)" Dockerfile-php)

## Instalamos las dependencias del proyecto ##
cd "symfony/$project"
sudo rm -rf composer.lock package-lock.json symfony.lock vendor node_modules
docker exec -it php composer install --ignore-platform-reqs
npm install --legacy-peer-deps
npm run build

if [[ "$(basename -- "$0")" =~ "init.sh" ]]; then
    cd ../..
fi
