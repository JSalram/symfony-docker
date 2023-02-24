#!/bin/bash

echo "######################################"
echo "### Asistente automático de docker ###"
echo "######################################"
printf "\n"

## Eliminamos los ficheros innecesarios ##
rm -rf .git .gitignore symfony/.gitkeep mysql/.gitignore

## Recogemos el nombre del directorio ##
result=${PWD##*/}
result=${result:-/}

## Declaramos las funciones necesarias para la ejecución ##
function change_directory() {
    echo "Indica el nombre del proyecto:"
    read proyecto
    if [[ ! -z "$proyecto" ]] && mv "../${PWD##*/}" "../$proyecto-docker"
    then
        echo "Nombre del proyecto modificado con éxito."
    fi
}
function clone_project() {
    echo "Introduce la url del proyecto que deseas clonar:"
    read git
    if [[ ! -z "$git" ]] && git clone "$git" ./symfony
    then
        echo "Proyecto clonado con éxito."
    fi
}
function change_database() {
    echo "Indica el nombre de la base de datos que deseas inicializar:"
    read db
    if [[ ! -z "$db" ]] && sed -i "s/DATABASE_NAME/$db/g" docker-compose.yml && mv mysql/*.sql "mysql/$db.sql"
    then
        echo "Base de datos renombrada con éxito."
    fi
}

## Modificamos el nombre del proyecto de docker ##
if [[ "${PWD##*/}" =~ symfony-docker ]]
then
    change_directory
else
    read -p "El proyecto ya ha sido modificado. ¿Deseas cambiarle el nombre? (y/N) " resp
    if [[ "$resp" =~ y|Y ]]
    then
        change_directory
    fi
fi
printf "\n"

## Clonamos el proyecto en la carpeta symfony ##
if [ -z "$(ls -A ./symfony)" ]
then
    clone_project
else
    read -p "El directorio symfony ya tiene contenido. ¿Deseas eliminarlo (y/N)?" resp
    if [[ "$resp" =~ y|Y ]]
    then
        rm -rf symfony
        mkdir symfony
        clone_project
    fi
fi
printf "\n"

## Modificamos el nombre genérico de la base de datos ##
change_database