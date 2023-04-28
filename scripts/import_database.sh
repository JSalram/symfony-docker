#!/bin/bash

## Si ejecutamos el script desde la raiz, subimos un directorio ##
if [[ ! "${PWD##*/}" =~ symfony-docker ]]; then
    cd ..
fi

function connect_project() {
    cd ..

    local_path='\.\/symfony\/'
    container_path='\/var\/www\/symfony\/'
    project=$(grep -oP "(?<=COPY $local_path).+(?=\\/ $container_path)" Dockerfile-php)

    if [[ ! "$project" =~ [A-Za-z] ]]; then
        exit
    fi

    echo "Creando el fichero .env.local..."
    if [ -f "symfony/$project/.env.local" ]; then
        rm "symfony/$project/.env.local"
    fi
    touch "symfony/$project/.env.local"
    echo "DATABASE_URL=mysql://root:root@db:3306/$1" >"symfony/$project/.env.local"
    echo "Conexión configurada con éxito."
    printf "\n"
}

function import_database() {
    if [[ ! "$1" =~ [A-Za-z] ]]; then
        exit
    fi

    db=""${1%.*}""
    read -p "¿Deseas cambiar el nombre de la base de datos? (y/N) " resp
    if [[ "$resp" =~ y|Y ]]; then
        echo "Indica el nombre de la base de datos que deseas inicializar:"
        read db
    fi

    echo "Creando la base de datos..."
    if sudo docker exec -i db mysql -uroot -proot -e "CREATE DATABASE $db;"; then
        echo "Base de datos creada con éxito."
        echo "Importando los datos..."
        if sudo docker exec -i db mysql -uroot -proot $db <../mysql/$1; then
            echo "Base de datos importada con éxito."
        else
            echo "Error al importar la base de datos."
        fi
    else
        echo "La base de datos ya está creada en el sistema."
    fi
    printf "\n"

    connect_project "$db"
}

## Comprobamos primero si los contenedores están levantados ##
if [ ! "$(docker ps -a -q)" ]; then
    echo "Los contenedores deben estar levantados previamente."
    echo "Recuerda ejecutar el script 'start.sh' para levantar el proyecto."
    exit
fi

## Leemos todos los posibles proyectos ##
cd mysql
array=(*.sql)
echo "Tienes ${#array[@]} scripts sql en tu sistema:"
PS3="¿Qué base de datos deseas importar? "
select sql in "${array[@]}"; do
    import_database "$sql"
    break
done
