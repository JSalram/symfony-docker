#!/bin/bash

echo "####################################################################"
echo "################## Asistente automático de docker ##################"
echo "####################################################################"
printf "\n"

## Eliminamos los ficheros innecesarios ##
rm -rf .git .gitignore symfony/.gitkeep mysql/.gitignore

## Variables ##
GREEN='\033[0;42m'
WHITE='\033[1;97m'
RESET='\033[0m'

## Recogemos el nombre del directorio ##
result=${PWD##*/}
result=${result:-/}

#######################################################
###################### FUNCIONES ######################
#######################################################
function change_directory() {
    echo "Indica el nombre del proyecto:"
    read proyecto
    if [[ ! -z "$proyecto" ]] && \
    mv "../${PWD##*/}" "../$proyecto-docker"
    then
        echo "Nombre del proyecto modificado con éxito."
    fi
    printf "\n"
}
function clone_project() {
    echo "Introduce la url del proyecto que deseas clonar:"
    read git
    if [[ ! -z "$git" ]] && \
    git clone "$git" ./symfony
    then
        echo "Proyecto clonado con éxito."
    fi
    printf "\n"
}
function change_database() {
    echo "Indica el nombre de la base de datos que deseas inicializar:"
    read db
    if [[ ! -z "$db" ]] && \
    sed -i "s/DATABASE_NAME/$db/g" docker-compose.yml
    then
        mv mysql/*.sql "mysql/$db.sql"
        echo "Base de datos renombrada con éxito."
        printf "\n"
        echo "Creando el fichero .env.local..."
        rm symfony/.env.local
        touch symfony/.env.local
        echo "DATABASE_URL=mysql://root:root@db:3306/$db" > symfony/.env.local
        echo "Fichero creado con éxito"
    fi
    printf "\n"
}

function import_database() {
    echo "Creando la base de datos..."
    if sudo docker exec -i db mysql -uroot -proot -e "CREATE DATABASE $db;"
    then
        echo "Base de datos creada con éxito."
        echo "Importando los datos..."
        if sudo docker exec -i db mysql -uroot -proot $db < ./mysql/$db.sql
        then
            echo "Base de datos importada con éxito."
        fi
    fi
    printf "\n"
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
        if [[ ! "$resp" =~ n|N ]]
        then
            import_database
        fi
    fi
    printf "\n"
}

#######################################################
###################### RECORRIDO ######################
#######################################################
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

## Modificamos el nombre genérico de la base de datos ##
if grep -q DATABASE_NAME docker-compose.yml
then
    change_database
fi

## Levantamos los contenedores e importamos la base de datos ##
read -p "El proyecto se encuentra preparado. ¿Deseas levantar los contenedores? (Y/n) " resp
if [[ ! "$resp" =~ n|N ]]
then
    docker_compose_up
fi

## Actualizamos las dependencias del proyecto ##
read -p "El proyecto está casi listo. ¿Deseas actualizar las dependencias? (Y/n) " resp
if [[ ! "$resp" =~ n|N ]]
then
    echo "Instalando las dependencias..."
    source install_dependencies.sh
fi

echo -e "$GREEN"
echo ""
echo -e " Si todo ha ido bien, ya puedes acceder a través del siguiente enlace:\n$WHITE http://localhost:8080"
echo -e "$RESET"