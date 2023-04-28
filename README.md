# Symfony Docker

## Setup

- Ejecutar el script **_init.sh_** con el comando `bash init.sh` para preparar el entorno docker de manera automática
- _(Opcional)_ Añadir el fichero .sql con la base de datos en el directorio _mysql_, para así poder importarlo con el script `init.sh` o, en su defecto, el script `import_database.sh`

Con estos sencillos pasos ya deberíamos poder ver el proyecto corriendo en nuestro [localhost:8080](http://127.0.0.1:8080)

## Scripts

- **`init.sh`**: Se encarga de levantar un proyecto (nuevo o ya existente) llamando al resto de scripts. Se puede utilizar en cualquier momento
- **`clone_project.sh`**: Clona un proyecto nuevo en el directorio de proyectos (_symfony_)
- **`change_project.sh`**: Lista los proyectos existentes y te da a elegir, cambiando así pa configuración en los archivos de docker
- **`start.sh`**: Levanta los contenedores y finaliza los anteriores (en caso de tener contenedores levantados)
- **`import_databases.sh`**: Lista los ficheros sql de nuestro directorio _mysql_ e importa la base de datos seleccionada, además de añadir la conexión en el fichero de configuración del proyecto symfony (`.env.local`)
- **`install_dependencies.sh`**: Instala las dependencias del proyecto activo en el momento
- **`reset_docker.sh`**: Elimina todos los contenedores y solo se debe utilizar en caso de conflicto

## Rutas
Todas las rutas se encuentran en localhost, pero dependiendo del puerto, accederemos a un contenedor u otro:
- **[localhost:8080](http://127.0.0.1:8080)**: Conexión principal del proyecto. Es el puerto de Nginx, desde el cual se puede visualizar el mismo
- **[localhost:8081](http://127.0.0.1:8081)**: PhpMyAdmin. Desde esta web podemos acceder al gestor de base de datos
- **localhost:3306**: No es una ruta accesible. Aquí se encuentra la base de datos mysql y se puede utilizar para realizar conexiones (en ocasiones se deberá sustituir **localhost** por **db**, puesto que docker tiene una conexión interna donde especifica así la ruta)

## Xdebug

Es necesario configurar Xdebug en PHPStorm/IntelliJ para poder hacer uso del mismo. Para ello, debemos hacer lo siguiente:

- Con el proyecto abierto, vamos a hacer click en `Run > Start Listening for PHP Debug Connections`, y también en `Run > Break at first line in PHP scripts`
- Una vez ambas opciones estén seleccionadas, debemos ir a nuestro localhost:8080 y recargar la página para comprobar que para el proceso
- Al pararse el proceso, nos saldrá una ventana (si es la primera configuración), le damos click en **Aceptar**
- Ya podemos parar la ejecución y desmarcar la opción de `Break at first line in PHP scripts`
- Por último, debemos ir a `File > Settings > Languages & Frameworks > PHP > Servers` y, una vez ahí, añadir la ruta del directorio `src` con la ruta del docker: `/var/www/symfony/src` haciendo click a la derecha de la ruta de src de nuestro sistema

**Listo**, ya tenemos Xdebug configurado. Con la opción `Start Listening for PHP Debug Connections` activa, podemos marcar puntos de interrupción donde queramos debugar.

## Lista de comandos

Solo necesitamos conocer dos comandos de docker (aunque con los scripts ya no es del todo necesario):

- `docker compose up -d`: Levanta los contenedores del proyecto activo
- `docker compose down`: Finaliza y elimina los contenedores activos

## Estructura

### **Directorios**

- **mysql**: Contiene los ficheros .sql para su posterior importación
- **nginx**: Contiene el fichero de configuración de nginx
- **scripts**: Contiene los scripts necesarios para automatizar el arranque del proyecto
- **symfony**: Contiene los proyectos symfony
- **xdebug**: Contiene el fichero de configuración de Xdebug

### **Ficheros docker**

- **`docker-compose.yml`**: Es el fichero principal, se encarga de orquestar los contenedores y contiene todos los parámetros necesarios
- **`Dockerfile-php`**: Fichero de configuración para el contenedor de PHP`
- **`Dockerfile-nginx`**: Fichero de configuración para el contenedor de Nginx`
