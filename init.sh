#!/bin/bash

echo "####################################################################"
echo "################## Asistente automático de docker ##################"
echo "####################################################################"
printf "\n"

## Recogemos el nombre del directorio ##
result=${PWD##*/}
result=${result:-/}

## Clonamos el proyecto en la carpeta symfony ##
read -p "¿Deseas clonar un nuevo proyecto? (y/N) " resp
if [[ "$resp" =~ y|Y ]]; then
    source scripts/clone_project.sh
fi
printf "\n"

## Seleccionamos el proyecto ##
source scripts/change_project.sh
printf "\n"

## Cambiamos la versión de PHP ##
printf "Versión actual: PHP "
sed -n "1p" Dockerfile-php | grep -Eo "[7-8]\.[0-9]"
read -p "¿Deseas modificar la versión de PHP? (y/N) " resp
if [[ "$resp" =~ y|Y ]]; then
    source scripts/php_version.sh
fi
printf "\n"

## Levantamos los contenedores ##
source scripts/start.sh
printf "\n"

## Actualizamos las dependencias del proyecto ##
read -p "El proyecto está listo. ¿Deseas actualizar las dependencias? (y/N) " resp
if [[ "$resp" =~ y|Y ]]; then
    echo "Instalando las dependencias..."
    source scripts/install_dependencies.sh
fi
printf "\n"

## Importamos la base de datos ##
read -p "Por último, ¿deseas importar una base de datos? (y/N) " resp
if [[ "$resp" =~ y|Y ]]; then
    source scripts/import_database.sh
fi
printf "\n"

echo -e "$GREEN"
echo ""
echo -e " Si todo ha ido bien, ya puedes acceder a través del siguiente enlace:\n$WHITE http://localhost:8080"
echo -e "$RESET"
