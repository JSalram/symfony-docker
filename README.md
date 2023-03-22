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