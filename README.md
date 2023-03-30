# Symfony Docker
## Setup
- Añadir en la carpeta ***mysql*** el fichero .sql del que se quiere crear una base de datos.
- Ejecutar el script ***init.sh*** con el comando `bash init.sh` para preparar el entorno docker de manera automática. 
- ***Si al importar la base de datos aparecen errores, ejecutar los comandos de importación indicados en la lista de comandos*** 
- Actualizar las dependencias del proyecto en la carpeta ***symfony***

**¡LISTO!** Ya deberíamos poder ver el proyecto corriendo en nuestro [localhost:8080](http://127.0.0.1:8080)

#

## Lista de comandos
### **Docker:**
- `docker compose up -d --build` -> Construye y levanta los contenedores (el --build solo es necesario si se han hecho cambios en los ficheros de configuración)
- `docker compose down` -> Para y elimina los contenedores (Necesario cuando cambiemos de un proyecto a otro, parando el que se encuentre activo)
- `docker stop $(docker ps -a -q)` -> Para todos los contenedores indistintamente del proyecto
- `docker rm $(docker ps -a -q)` -> Elimina todos los contedores indistintamente del proyecto (necesario si paramos todos los contenedores con el comando anterior)

### **Base de datos:**
**IMPORTANTE:** Reemplazar **NOMBRE_BBDD** por el nombre de la **base de datos** (debe coincidir con el nombre del fichero **.sql**)
- `docker exec -i db mysql -uroot -proot -e "CREATE DATABASE NOMBRE_BBDD;"` -> Crea la base de datos
- `docker exec -i db mysql -uroot -proot NOMBRE_BBDD < ./mysql/NOMBRE_BBDD.sql` -> Importa la base de datos

### **Xdebug:**
Es necesario configurar Xdebug en PHPStorm/IntelliJ para poder hacer uso del mismo. Para ello, debemos hacer lo siguiente:
- Con el proyecto abierto, vamos a hacer click en `Run > Start Listening for PHP Debug Connections`, y también en `Run > Break at first line in PHP scripts`
- Una vez ambas opciones estén seleccionadas, debemos ir a nuestro localhost:8080 y recargar la página para comprobar que para el proceso
- Al pararse el proceso, nos saldrá una ventana (si es la primera configuración), le damos click en **Aceptar**
- Ya podemos parar la ejecución y desmarcar la opción de `Break at first line in PHP scripts`
- Por último, debemos ir a `File > Settings > Languages & Frameworks > PHP > Servers` y, una vez ahí, añadir la ruta del directorio `src` con la ruta del docker: `/var/www/symfony/src` haciendo click a la derecha de la ruta de src de nuestro sistema

**Listo**, ya tenemos Xdebug configurado. Con la opción `Start Listening for PHP Debug Connections` activa, podemos marcar puntos de interrupción donde queramos debugar.

#

## Estructura
En el proyecto tenemos varios ficheros de configuración de docker y scripts en bash (Linux) que realizan diversas funciones, así como carpetas con archivos de configuración para los distintos contenedores (cuya explicación no es necesaria).

### **Scripts**
- `init.sh` -> Se encarga de iniciar el docker si se trata de un proyecto nuevo (no inicializado)
- `install_dependencies.sh` -> Se encarga de instalar las dependencias del proyecto symfony una vez ha sido inicializado (es llamado automáticamente desde el init.sh)
- `reset_docker.sh` -> Se encarga de resetear los contenedores de docker en caso de que tengamos conflictos con algún otro proyecto

### **Ficheros de configuración**
- `docker-compose.yml` -> Es el fichero main, se encarga de orquestrar los contenedores y contiene todos los parámetros necesarios
- `Dockerfile-php` -> Fichero de configuración para el contenedor de PHP`
- `Dockerfile-nginx` -> Fichero de configuración para el contenedor de Nginx`