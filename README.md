# Symfony Docker
## Setup
- Añadir en la carpeta ***mysql*** el fichero .sql del que se quiere crear una base de datos.
- Ejecutar el script ***init.sh*** con el comando `bash init.sh` para preparar el entorno docker de manera automática. 
- ***Si al importar la base de datos aparecen errores, ejecutar los comandos de importación indicados en la lista de comandos*** 
- Actualizar las dependencias del proyecto en la carpeta ***symfony***

**LISTO**, ya deberíamos poder ver el proyecto corriendo en nuestro [localhost:8080](http://127.0.0.1:8080)

## Lista de comandos
### Docker:
- `docker compose up -d --build` -> Construye y levanta los contenedores
- `docker compose down` -> Para y elimina los contenedores

### Base de datos:
**IMPORTANTE:** Reemplazar **NOMBRE_BBDD** por el nombre de la **base de datos** (debe coincidir con el nombre del fichero **.sql**)
- `docker exec -i db mysql -uroot -proot -e "CREATE DATABASE NOMBRE_BBDD;"` -> Crea la base de datos
- `docker exec -i db mysql -uroot -proot NOMBRE_BBDD < ./mysql/NOMBRE_BBDD.sql` -> Importa la base de datos

### Xdebug:
Es necesario configurar Xdebug en IntelliJ / PHPStorm para poder hacer uso del mismo. Para ello, debemos hacer lo siguiente:
- Con el proyecto abierto, vamos a hacer click en `Run > Start Listening for PHP Debug Connections`, y también en `Run > Break at first line in PHP scripts`
- Una vez ambas opciones estén seleccionadas, debemos ir a nuestro localhost:8080 para comprobar que para el proceso
- Al pararse el proceso, nos saldrá una ventana (si es la primera configuración), le damos click en **Aceptar**
- Ya podemos parar la ejecución y desmarcar la opción de `Break at first line in PHP scripts`
- Por último, debemos ir a `File > Settings > Languages & Frameworks > PHP > Debug > Servers` y, una vez ahí, añadir la ruta del directorio `src` con la ruta del docker: `/var/www/symfony/src`

Listo, ya tenemos Xdebug configurado. Con la opción `Start Listening for PHP Debug Connections` activa, podemos marcar puntos de interrupción donde queramos debugar.