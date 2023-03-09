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

#################################
########### FUNCIONES ###########
#################################
function change_directory() {
    echo "Indica el nombre del proyecto:"
    read proyecto
    if [[ ! -z "$proyecto" ]] && \
    mv "../${PWD##*/}" "../$proyecto-docker"
    then
        echo "Nombre del proyecto modificado con éxito."
    fi
}
function clone_project() {
    echo "Introduce la url del proyecto que deseas clonar:"
    read git
    if [[ ! -z "$git" ]] && \
    git clone "$git" ./symfony
    then
        echo "Proyecto clonado con éxito."
    fi
}
function change_database() {
    echo "Indica el nombre de la base de datos que deseas inicializar:"
    read db
    if [[ ! -z "$db" ]] && \
    sed -i "s/DATABASE_NAME/$db/g" docker-compose.yml && \
    mv mysql/*.sql "mysql/$db.sql"
    then
        echo "Base de datos renombrada con éxito."
    fi
}

function import_database() {
    echo "Importando base de datos..."
    echo "Creando la base de datos..."
    if docker exec -i db mysql -uroot -proot -e "CREATE DATABASE $db;"
    then
        echo "Base de datos creada con éxito."
        echo "Importando los datos..."
        if docker exec -i db mysql -uroot -proot $db < ./mysql/$db.sql
        then
            echo "Base de datos importada con éxito."
        fi
    fi
}

function docker_compose_up() {
    echo "Levantando contenedores..."
    if docker compose up -d --build
    then
        echo "Finalizando..."
        echo "..."
        sleep 2
        echo "..."
        sleep 2
        echo "Contenedores levantados con éxito."
        printf "\n"
        
        read -p "¿Deseas importar la base de datos? (Y/n) " resp
        if [[ ! "$resp" =~ y|Y ]]
        then
            import_database
        fi
    fi
}

#################################
########### RECORRIDO ###########
#################################
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
    read -p "El directorio symfony ya tiene contenido. ¿Deseas eliminarlo? (y/N) " resp
    if [[ "$resp" =~ y|Y ]]
    then
        rm -rf symfony
        mkdir symfony
        clone_project
    fi
fi
printf "\n"

## Modificamos el nombre genérico de la base de datos ##
if grep -q DATABASE_NAME docker-compose.yml
then
    change_database
fi
printf "\n"

## Levantamos los contenedores e importamos la base de datos ##
read -p "El proyecto se encuentra preparado. ¿Deseas levantar los contenedores? (Y/n) " resp
if [[ ! "$resp" =~ y|Y ]]
then
    docker_compose_up
fi
printf "\n"

echo "RECUERDA actualizar las dependencias del proyecto y modificar el fichero '.env'"
echo "Ya puedes acceder a través del siguiente enlace: http://localhost:8080"