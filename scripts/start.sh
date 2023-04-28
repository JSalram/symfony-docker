#!/bin/bash

## Si ejecutamos el script desde la raiz, subimos un directorio ##
if [[ ! "${PWD##*/}" =~ symfony-docker ]]; then
    cd ..
fi

## Variables ##
GREEN='\033[0;42m'
WHITE='\033[1;97m'
RESET='\033[0m'

function docker_compose_up() {
    echo "Levantando contenedores..."
    if docker compose up -d --build; then
        echo "Contenedores levantados con éxito."

        if [[ ! "$(basename -- "$0")" =~ "init.sh" ]]; then
            printf "\n"
            echo -e "$GREEN"
            echo ""
            echo -e " Ya puedes acceder a través del siguiente enlace:\n$WHITE http://localhost:8080"
            echo -e "$RESET"
        fi
    else
        echo "Conflictos encontrados. Corrigiendo..."
        source scripts/reset_docker.sh
        docker compose up -d --build
    fi
}

if [ "$(docker ps -a -q)" ]; then
    echo "Tienes contenedores levantados. Finalizando los contenedores..."
    docker compose down
    echo "Contenedores finalizados con éxito."
    printf "\n"
fi

docker_compose_up
