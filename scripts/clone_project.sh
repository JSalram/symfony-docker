#!/bin/bash

## Si ejecutamos el script desde la raiz, subimos un directorio ##
if [[ ! "${PWD##*/}" =~ symfony-docker ]]; then
    cd ..
fi

## Clonamos el proyecto en la carpeta symfony ##
echo "Introduce la url del proyecto que deseas clonar:"
read git
if [[ ! -z "$git" ]] &&
    cd symfony &&
    git clone "$git"; then
    echo "Proyecto clonado con éxito."
fi

cd ..
