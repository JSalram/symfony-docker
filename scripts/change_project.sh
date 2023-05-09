#!/bin/bash

## Si ejecutamos el script desde la raiz, subimos un directorio ##
if [[ "${PWD##*/}" =~ scripts ]]; then
    cd ..
fi

function select_dir() {
    if [[ ! "$1" =~ [A-Za-z] ]]; then
        exit
    fi

    cd ..
    local_path='\.\/symfony\/'
    container_path='\/var\/www\/symfony\/'
    sed -i -E "s/($local_path).+($container_path)/\1$1\\/:\2/gmi" docker-compose.yml
    sed -i -E "s/($local_path).+($container_path)/\1$1\\/ \2/gmi" Dockerfile-php
    echo "Proyecto cambiado con éxito."
}

## Leemos todos los posibles proyectos ##
cd symfony
array=(*)
echo "Tienes ${#array[@]} proyectos en tu sistema:"
PS3="¿Qué proyecto deseas arrancar? "
select dir in "${array[@]}"; do
    select_dir "$dir"
    break
done

if [[ ! "$(basename -- "$0")" =~ "init.sh" ]]; then
    echo "Recuerda ejecutar el script 'start.sh' para levantar el nuevo proyecto."
fi
