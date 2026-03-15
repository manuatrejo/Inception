# Guía-TODOS Completa - Proyecto Inception (42)

## 📋 Instrucciones de uso

- [ ] Marcar cada tarea como completada cuando la finishes
- [ ] No avanzar a la siguiente fase sin completar la actual
- [ ] Documenta lo que aprendes en cada paso
- [ ] Consulta los recursos antes de pedir ayuda

---

## FASE 1: Entorno y Fundamentos

### 1.1 Preparar la Máquina Virtual
- [ ] **1.1.1** Instalar una máquina virtual (VirtualBox/VMware)
- [ ] **1.1.2** Descargar imagen ISO de Debian o Alpine
- [ ] **1.1.3** Instalar Linux en la VM
- [ ] **1.1.4** Configurar red de la VM (Bridge o NAT)
- [ ] **1.1.5** Instalar sudo y configurar usuario
- [ ] **1.1.6** Actualizar el sistema: `apt update && apt upgrade`

### 1.2 Instalar Docker
- [ ] **1.2.1** Instalar dependencias: `apt install apt-transport-https ca-certificates curl gnupg lsb-release`
- [ ] **1.2.2** Añadir clave GPG de Docker
- [ ] **1.2.3** Añadir repositorio Docker
- [ ] **1.2.4** Instalar Docker Engine: `apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin`
- [ ] **1.2.5** Verificar instalación: `docker --version`
- [ ] **1.2.6** Verificar Docker Compose: `docker compose version`
- [ ] **1.2.7** Añadir usuario al grupo docker: `usermod -aG docker $USER`
- [ ] **1.2.8** Verificar que Docker funciona: `docker run hello-world`

### 1.3 Conceptos Básicos de Docker
- [*] **1.3.1** ¿Qué es un contenedor? Explica con tus propias palabras
- [*] **1.3.2** ¿Qué es una imagen Docker?
- [*] **1.3.3** ¿Cuál es la diferencia entre imagen y contenedor?
- [*] **1.3.4** ¿Qué es el daemon de Docker?
- [*] **1.3.5** ¿Para qué sirve el comando `docker run`?
- [*] **1.3.6** ¿Para qué sirve el comando `docker pull`?
- [*] **1.3.7** ¿Qué son las capas (layers) de una imagen?
- [ ] **1.3.8** Ejecuta `docker run -it debian:bookworm-slim sh` y explora el contenedor

### 1.4 Comandos Esenciales de Docker
- [ ] **1.4.1** Practicar: `docker ps` - listar contenedores activos
- [ ] **1.4.2** Practicar: `docker ps -a` - listar todos los contenedores
- [ ] **1.4.3** Practicar: `docker images` - listar imágenes
- [ ] **1.4.4** Practicar: `docker logs <container>` - ver logs
- [ ] **1.4.5** Practicar: `docker exec -it <container> sh` - entrar en contenedor
- [ ] **1.4.6** Practicar: `docker stop <container>` - parar contenedor
- [ ] **1.4.7** Practicar: `docker rm <container>` - eliminar contenedor
- [ ] **1.4.8** Practicar: `docker rmi <image>` - eliminar imagen
- [ ] **1.4.9** Practicar: `docker build -t nombre .` - construir imagen
- [ ] **1.4.10** Practicar: `docker run -d -p 8080:80 --name test nginx` - crear y ejecutar

### 1.5 Docker Compose Básico
- [*] **1.5.1** ¿Qué es Docker Compose?
- [*] **1.5.2** ¿Cuál es la diferencia entre `docker run` y `docker compose`?
- [ ] **1.5.3** Practicar: crear un `docker-compose.yml` básico con nginx
- [ ] **1.5.4** Practicar: `docker compose up -d`
- [ ] **1.5.5** Practicar: `docker compose down`
- [ ] **1.5.6** Practicar: `docker compose ps`
- [ ] **1.5.7** Practicar: `docker compose logs -f`
- [ ] **1.5.8** Practicar: `docker compose exec servicio comando`
- [ ] **1.5.9** Entender la estructura de `docker-compose.yml` (version, services, volumes, networks)

### 1.6 Redes en Docker
- [*] **1.6.1** ¿Qué es el driver bridge?
- [*] **1.6.2** ¿Qué es el driver host?
- [*] **1.6.3** ¿Por qué está prohibido `network: host` en Inception?
- [*] **1.6.4** ¿Qué es el flag `--link` y por qué está prohibido?
- [*] **1.6.5** ¿Cómo se comunican los contenedores entre sí?
- [*] **1.6.6** ¿Qué es el DNS interno de Docker?
- [ ] **1.6.7** Practicar: crear dos contenedores en la misma red y hacer ping entre ellos
- [ ] **1.6.8** Practicar: `docker network ls`
- [ ] **1.6.9** Practicar: `docker network inspect <network>`

---

## FASE 2: Dockerfile Profundo

### 2.1 Anatomía del Dockerfile
- [ ] **2.1.1** Investigar: instrucción FROM
- [ ] **2.1.2** Investigar: instrucción RUN
- [ ] **2.1.3** Investigar: instrucción COPY
- [ ] **2.1.4** Investigar: instrucción ADD
- [ ] **2.1.5** Investigar: diferencia entre COPY y ADD
- [ ] **2.1.6** Investigar: instrucción WORKDIR
- [ ] **2.1.7** Investigar: instrucción ENV
- [ ] **2.1.8** Investigar: instrucción EXPOSE
- [ ] **2.1.9** Investigar: instrucción ENTRYPOINT
- [ ] **2.1.10** Investigar: instrucción CMD
- [ ] **2.1.11** Investigar: diferencia entre ENTRYPOINT y CMD
- [ ] **2.1.12** Investigar: instrucción ARG

### 2.2 El Problema PID 1 (CRÍTICO)
- [ ] **2.2.1** ¿Qué es PID 1 en Linux?
- [ ] **2.2.2** ¿Por qué es importante en contenedores Docker?
- [ ] **2.2.3** ¿Qué son las señales (SIGTERM, SIGKILL)?
- [ ] **2.2.4** ¿Qué pasa cuando envías SIGTERM a un contenedor?
- [ ] **2.2.5** ¿Por qué `tail -f` no funciona correctamente?
- [ ] **2.2.6** ¿Por qué `sleep infinity` no funciona correctamente?
- [ ] **2.2.7** ¿Por qué `bash` como CMD no funciona bien?
- [ ] **2.2.8** ¿Qué es un daemon?
- [ ] **2.2.9** ¿Cómo hacen los daemons para funcionar correctamente con PID 1?
- [ ] **2.2.10** ¿Qué es `exec` en bash y por qué es importante?
- [ ] **2.2.11** Escribir un entrypoint script correcto
- [ ] **2.2.12** Testear que el contenedor responde bien a `docker stop`

### 2.3 Best Practices para Dockerfiles
- [ ] **2.3.1** ¿Por qué no usar la etiqueta `latest`?
- [ ] **2.3.2** ¿Por qué es importante el orden de las instrucciones?
- [ ] **2.3.3** ¿Qué son las capas de caché?
- [ ] **2.3.4** ¿Cómo optimizar el uso de caché?
- [ ] **2.3.5** ¿Qué es un Dockerfile multi-stage?
- [ ] **2.3.6** ¿Por qué limpiar el caché de apt?
- [ ] **2.3.7** ¿Por qué usar `--no-install-recommends` en apt?
- [ ] **2.3.8** ¿Cómo reducir el tamaño de las imágenes?
- [ ] **2.3.9** ¿Qué es un .dockerignore?
- [ ] **2.3.10** Crear un .dockerignore efectivo
- [ ] **2.3.11** ¿Cómo ejecutar como usuario no-root?
- [ ] **2.3.12** ¿Qué son las imágenes base pequeñas (alpine, slim)?

### 2.4 Ejercicios Prácticos de Dockerfile
- [ ] **2.4.1** Escribir un Dockerfile para nginx desde cero
- [ ] **2.4.2** Construir la imagen y verificar que funciona
- [ ] **2.4.3** Escribir un Dockerfile para MariaDB
- [ ] **2.4.4** Entender cómo funciona la inicialización de MariaDB
- [ ] **2.4.5** Escribir un Dockerfile para WordPress con php-fpm
- [ ] **2.4.6** Entender la configuración de php-fpm
- [ ] **2.4.7** Practicar con Entrypoint Scripts

---

## FASE 3: NGINX y TLS/SSL

### 3.1 NGINX Básico
- [ ] **3.1.1** ¿Qué es NGINX?
- [ ] **3.1.2** ¿Cuál es la diferencia entre Apache y NGINX?
- [ ] **3.1.3** ¿Qué es un servidor web?
- [ ] **3.1.4** ¿Qué es un reverse proxy?
- [ ] **3.1.5** ¿Por qué usamos NGINX como reverse proxy?
- [ ] **3.1.6** Instalary configurar NGINX básico
- [ ] **3.1.7** Entender la estructura de configuración de NGINX
- [ ] **3.1.8** ¿Qué son los server blocks (virtual hosts)?
- [ ] **3.1.9** ¿Qué es el directive `listen`?
- [ ] **3.1.10** ¿Qué es el directive `server_name`?

### 3.2 Configuración de Proxy
- [ ] **3.2.1** ¿Qué es `proxy_pass`?
- [ ] **3.2.2** ¿Qué son los headers `X-Real-IP`, `X-Forwarded-For`?
- [ ] **3.2.3** ¿Por qué necesitamos estos headers?
- [ ] **3.2.4** Configurar NGINX como reverse proxy a un contenedor
- [ ] **3.2.5** Testear la configuración de proxy

### 3.3 TLS/SSL (CRÍTICO)
- [ ] **3.3.1** ¿Qué es HTTP vs HTTPS?
- [ ] **3.3.2** ¿Qué es SSL?
- [ ] **3.3.3** ¿Qué es TLS?
- [ ] **3.3.4** ¿Cuál es la diferencia entre SSL y TLS?
- [ ] **3.3.5** ¿Qué es un certificado digital?
- [ ] **3.3.6** ¿Qué es un certificado autofirmado?
- [ ] **3.3.7** ¿Qué es una CA (Certificate Authority)?
- [ ] **3.3.8** Generar un certificado autofirmado con openssl
- [ ] **3.3.9** ¿Qué es el handshake de TLS?
- [ ] **3.3.10** Entender los archivos .key y .pem/.crt

### 3.4 Versiones de TLS
- [ ] **3.4.1** ¿Qué es TLSv1.0 y TLSv1.1?
- [ ] **3.4.2** ¿Por qué están deprecated?
- [ ] **3.4.3** ¿Qué es TLSv1.2?
- [ ] **3.4.4** ¿Qué es TLSv1.3? ¿Qué mejoras tiene?
- [ ] **3.4.5** ¿Cómo configurar NGINX para usar solo TLSv1.2 y TLSv1.3?
- [ ] **3.4.6** ¿Qué son los ssl_ciphers?
- [ ] **3.4.7** ¿Por qué usar `ssl_protocols TLSv1.2 TLSv1.3`?
- [ ] **3.4.8** Configurar NGINX con TLS en docker-compose

### 3.5 Configuración NGINX para WordPress
- [ ] **3.5.1** ¿Cómo configura NGINX para php-fpm?
- [ ] **3.5.2** ¿Qué es fastcgi_pass?
- [ ] **3.5.3** ¿Qué es fastcgi_param SCRIPT_FILENAME?
- [ ] **3.5.4** ¿Por qué no instalamos nginx en el contenedor de WordPress?
- [ ] **3.5.5** Escribir configuración completa para WordPress
- [ ] **3.5.6** Testear que WordPress funciona a través de NGINX

---

## FASE 4: PHP-FPM y WordPress

### 4.1 PHP-FPM
- [ ] **4.1.1** ¿Qué es PHP?
- [ ] **4.1.2** ¿Qué es FastCGI?
- [ ] **4.1.3** ¿Qué es PHP-FPM?
- [ ] **4.1.4** ¿Por qué usar PHP-FPM en lugar de mod_php?
- [ ] **4.1.5** ¿Qué es un pool de PHP-FPM?
- [ ] **4.1.6** Entender la configuración de www.conf
- [ ] **4.1.7** ¿Qué es el directive `listen` en PHP-FPM?
- [ ] **4.1.8** ¿Cómo se conecta NGINX con PHP-FPM?
- [ ] **4.1.9** Configurar PHP-FPM para escuchar en red
- [ ] **4.1.10** Entender los permisos de archivos

### 4.2 WordPress
- [ ] **4.2.1** ¿Qué es WordPress?
- [ ] **4.2.2** ¿Qué es un CMS?
- [ ] **4.2.3** ¿Qué es wp-cli?
- [ ] **4.2.4** Instalar WordPress manualmente
- [ ] **4.2.5** Instalar WordPress con wp-cli
- [ ] **4.2.6** Entender la estructura de archivos de WordPress
- [ ] **4.2.7** ¿Qué es wp-config.php?
- [ ] **4.2.8** Configurar conexión a base de datos

### 4.3 Instalación de WordPress en Docker
- [ ] **4.3.1** Descargar WordPress
- [ ] **4.3.2** Configurar permisos correctos
- [ ] **4.3.3** Configurar php-fpm
- [ ] **4.3.4** Escribir entrypoint para inicializar WordPress
- [ ] **4.3.5** Testear que WordPress responde

---

## FASE 5: MariaDB

### 5.1 Bases de Datos
- [ ] **5.1.1** ¿Qué es una base de datos relacional?
- [ ] **5.1.2** ¿Qué es SQL?
- [ ] **5.1.3** ¿Qué es MySQL?
- [ ] **5.1.4** ¿Qué es MariaDB? ¿Cuál es la diferencia con MySQL?
- [ ] **5.1.5** ¿Por qué elegimos MariaDB?

### 5.2 MariaDB en Docker
- [ ] **5.2.1** ¿Cómo se inicializa MariaDB en un contenedor?
- [ ] **5.2.2** ¿Qué es `/docker-entrypoint.sh`?
- [ ] **5.2.3** ¿Cómo pasar contraseña root?
- [ ] **5.2.4** Crear base de datos en el primer inicio
- [ ] **5.2.5** Crear usuarios y dar permisos
- [ ] **5.2.6** Entender el comando FLUSH PRIVILEGES

### 5.3 Configuración de MariaDB
- [ ] **5.3.1** ¿Qué es my.cnf?
- [ ] **5.3.2** Configurar bind-address
- [ ] **5.3.3** Configurar character set
- [ ] **5.3.4** Entender los storage engines
- [ ] **5.3.5** Configurar para producción básica

### 5.4 Conexión desde WordPress
- [ ] **5.4.1** ¿Qué datos necesita WordPress para conectar a MariaDB?
- [ ] **5.4.2** ¿Qué es el nombre de la base de datos?
- [ ] **5.4.3** ¿Qué es el usuario de la base de datos?
- [ ] **5.4.4** ¿Qué es el host de la base de datos?
- [ ] **5.4.5** Testear conexión desde WordPress a MariaDB

---

## FASE 6: Volúmenes y Persistencia

### 6.1 Tipos de Almacenamiento en Docker
- [ ] **6.1.1** ¿Qué son los volúmenes de Docker?
- [ ] **6.1.2** ¿Qué son los bind mounts?
- [ ] **6.1.3** ¿Qué son los tmpfs?
- [ ] **6.1.4** ¿Cuál es la diferencia principal?

### 6.2 Named Volumes
- [ ] **6.2.1** ¿Qué es un named volume?
- [ ] **6.2.2** ¿Por qué son mejores que bind mounts?
- [ ] **6.2.3** ¿Cómo crear un named volume?
- [ ] **6.2.4** ¿Cómo usar driver local con bind?
- [ ] **6.2.5** ¿Por qué Inception requiere named volumes?
- [ ] **6.2.6** Configurar volúmenes en /home/maanguit/data

### 6.3 Volúmenes para MariaDB
- [ ] **6.3.1** ¿Qué directorio de MariaDB hay que persistir?
- [ ] **6.3.2** Montar volumen en /var/lib/mysql
- [ ] **6.3.3** Verificar que los datos persisten al reiniciar

### 6.4 Volúmenes para WordPress
- [ ] **6.4.1** ¿Qué directorio de WordPress hay que persistir?
- [ ] **6.4.2** Montar volumen en /var/www/html
- [ ] **6.4.3** Verificar que los archivos persisten al reiniciar

### 6.5 Bind Mounts vs Named Volumes
- [ ] **6.5.1** ¿Por qué están prohibidos los bind mounts en Inception?
- [ ] **6.5.2** ¿Qué ventajas tienen los named volumes?
- [ ] **6.5.3** ¿Qué es la portabilidad de volúmenes?

---

## FASE 7: Secrets y Variables de Entorno

### 7.1 Environment Variables
- [ ] **7.1.1** ¿Qué son las variables de entorno?
- [ ] **7.1.2** ¿Cómo se definen en docker-compose?
- [ ] **7.1.3** ¿Qué datos sensibles NO deben ir en env vars?
- [ ] **7.1.4** Ejemplos de datos no sensibles en env vars

### 7.2 Docker Secrets
- [ ] **7.2.1** ¿Qué son los Docker Secrets?
- [ ] **7.2.2** ¿En qué casos se usan?
- [ ] **7.2.3** ¿Cómo se configuran en docker-compose?
- [ ] **7.2.4** ¿Por qué son más seguros que env vars?
- [ ] **7.2.5** ¿Cómo acceder a secrets en el contenedor?

### 7.3 Secrets en Inception
- [ ] **7.3.1** Crear archivo db_root_password.txt
- [ ] **7.3.2** Crear archivo db_password.txt
- [ ] **7.3.3** ¿Qué es credentials.txt?
- [ ] **7.3.4** Configurar secrets en docker-compose
- [ ] **7.3.5** Leer secrets en entrypoint scripts

### 7.4 Archivo .env
- [ ] **7.4.1** ¿Qué es el archivo .env?
- [ ] **7.4.2** ¿Por qué es obligatorio en Inception?
- [ ] **7.4.3** ¿Qué variables se definen en .env?
- [ ] **7.4.4** No incluir contraseñas en .env
- [ ] **7.4.5** Crear .env con configuración básica

---

## FASE 8: docker-compose.yml

### 8.1 Estructura de docker-compose.yml
- [ ] **8.1.1** Entender la versión del archivo
- [ ] **8.1.2** ¿Qué es `services`?
- [ ] **8.1.3** ¿Qué es `volumes`?
- [ ] **8.1.4** ¿Qué es `networks`?
- [ ] **8.1.5** ¿Qué es `build`?

### 8.2 Servicios
- [ ] **8.2.1** Definir servicio nginx
- [ ] **8.2.2** Definir servicio wordpress
- [ ] **8.2.3** Definir servicio mariadb
- [ ] **8.2.4** Configurar restart policy
- [ ] **8.2.5** Configurar depends_on
- [ ] **8.2.6** Configurar ports
- [ ] **8.2.7** Configurar volumes
- [ ] **8.2.8** Configurar environment
- [ ] **8.2.9** Configurar secrets

### 8.3 Redes
- [ ] **8.3.1** Crear red bridge
- [ ] **8.3.2** Verificar comunicación entre servicios
- [ ] **8.3.3** Por qué no usar network: host

### 8.4 Volúmenes
- [ ] **8.4.1** Definir volumen para MariaDB
- [ ] **8.4.2** Definir volumen para WordPress
- [ ] **8.4.3** Configurar driver local
- [ ] **8.4.4** Configurar bind al host

### 8.5 Compose Commands
- [ ] **8.5.1** `docker compose build`
- [ ] **8.5.2** `docker compose up -d`
- [ ] **8.5.3** `docker compose down`
- [ ] **8.5.4** `docker compose ps`
- [ ] **8.5.5** `docker compose logs -f`
- [ ] **8.5.6** `docker compose restart`
- [ ] **8.5.7** `docker compose exec`

---

## FASE 9: Makefile

### 9.1 Basics de Make
- [ ] **9.1.1** ¿Qué es make?
- [ ] **9.1.2** ¿Qué es un Makefile?
- [ ] **9.1.3** Entender la sintaxis de Makefile
- [ ] **9.1.4** ¿Qué son los targets?
- [ ] **9.1.5** ¿Qué son las recipes?
- [ ] **9.1.6** ¿Qué es .PHONY?

### 9.2 Makefile para Inception
- [ ] **9.2.1** Crear target `all`
- [ ] **9.2.2** Crear target `build`
- [ ] **9.2.3** Crear target `up`
- [ ] **9.2.4** Crear target `down`
- [ ] **9.2.5** Crear target `clean`
- [ ] **9.2.6** Crear target `re` (restart)
- [ ] **9.2.7** Probar todos los targets

---

## FASE 10: Configuración de Dominio

### 10.1 DNS Local
- [ ] **10.1.1** ¿Qué es /etc/hosts?
- [ ] **10.1.2** Añadir entrada para maanguit.42.fr
- [ ] **10.1.3** Verificar que resuelve a 127.0.0.1

### 10.2 Puerto 443
- [ ] **10.2.1** ¿Por qué solo puerto 443?
- [ ] **10.2.2** ¿Qué pasa si intentas acceder por HTTP?
- [ ] **10.2.3** Configurar redirects si es necesario

---

## FASE 11: Integración y Testing

### 11.1 Primera Integración
- [ ] **11.1.1** Construir todas las imágenes
- [ ] **11.1.2** Levantar todos los servicios
- [ ] **11.1.3** Verificar que NGINX está corriendo
- [ ] **11.1.4** Verificar que WordPress responde
- [ ] **11.1.5** Verificar que MariaDB está corriendo

### 11.2 Verificación de Requisitos
- [ ] **11.2.1** Verificar que solo puerto 443 está expuesto
- [ ] **11.2.2** Verificar TLSv1.2/1.3 funciona
- [ ] **11.2.3** Verificar volúmenes en /home/maanguit/data
- [ ] **11.2.4** Verificar restart policy
- [ ] **11.2.5** Verificar red entre contenedores
- [ ] **11.2.6** Verificar que no hay passwords en Dockerfiles
- [ ] **11.2.7** Verificar .env existe

### 11.3 WordPress Setup
- [ ] **11.3.1** Acceder a WordPress por primera vez
- [ ] **11.3.2** Crear usuario administrador (NO usar admin)
- [ ] **11.3.3** Crear segundo usuario
- [ ] **11.3.4** Instalar tema básico
- [ ] **11.3.5** Crear post de prueba
- [ ] **11.3.6** Subir imagen de prueba

### 11.4 Persistencia
- [ ] **11.4.1** Reiniciar contenedores
- [ ] **11.4.2** Verificar que WordPress sigue igual
- [ ] **11.4.3** Verificar que el post de prueba sigue ahí
- [ ] **11.4.4** Verificar datos en /home/maanguit/data

### 11.5 Restart Policy Testing
- [ ] **11.5.1** Matar un contenedor a propósito
- [ ] **11.5.2** Verificar que reinicia automáticamente
- [ ] **11.5.3** Verificar que el servicio sigue funcionando

---

## FASE 12: Documentación

### 12.1 README.md
- [ ] **12.1.1** Primera línea: This project has been created...
- [ ] **12.1.2** Section: Description
- [ ] **12.1.3** Section: Instructions
- [ ] **12.1.4** Section: Resources
- [ ] **12.1.5** Section: AI Usage
- [ ] **12.1.6** Comparación: VM vs Docker
- [ ] **12.1.7** Comparación: Secrets vs Environment Variables
- [ ] **12.1.8** Comparación: Docker Network vs Host Network
- [ ] **12.1.9** Comparación: Docker Volumes vs Bind Mounts

### 12.2 USER_DOC.md
- [ ] **12.2.1** Explicar qué servicios proporciona la infraestructura
- [ ] **12.2.2** Cómo iniciar el proyecto
- [ ] **12.2.3** Cómo detener el proyecto
- [ ] **12.2.4** Cómo acceder al sitio web
- [ ] **12.2.5** Cómo acceder al panel de administración
- [ ] **12.2.6** Dónde están las credenciales
- [ ] **12.2.7** Cómo verificar que los servicios funcionan

### 12.3 DEV_DOC.md
- [ ] **12.3.1** Prerequisites para setup
- [ ] **12.3.2** Archivos de configuración necesarios
- [ ] **12.3.3** Cómo construir el proyecto
- [ ] **12.3.4** Cómo lanzar el proyecto
- [ ] **12.3.5** Comandos para gestionar contenedores
- [ ] **12.3.6** Dónde se almacenan los datos
- [ ] **12.3.7** Cómo funcionan los volúmenes

---

## FASE 13: Bonus (Opcional)

### 13.1 Redis Cache
- [ ] **13.1.1** ¿Qué es Redis?
- [ ] **13.1.2** ¿Qué es un cache?
- [ ] **13.1.3** ¿Cómo beneficia Redis a WordPress?
- [ ] **13.1.4** Escribir Dockerfile para Redis
- [ ] **13.1.5** Configurar WordPress para usar Redis
- [ ] **13.1.6** Instalar plugin de Redis en WordPress

### 13.2 FTP Server
- [ ] **13.2.1** ¿Qué es un servidor FTP?
- [ ] **13.2.2** ¿Para qué sirve en esta infraestructura?
- [ ] **13.2.3** Escribir Dockerfile para vsftpd
- [ ] **13.2.4** Configurar volumen de WordPress en FTP
- [ ] **13.2.5** Testear conexión FTP

### 13.3 Static Website
- [ ] **13.3.1** ¿Qué es un sitio estático?
- [ ] **13.3.2** Elegir tecnología (Node.js, Python, etc.)
- [ ] **13.3.3** Crear sitio básico
- [ ] **13.3.4** Escribir Dockerfile
- [ ] **13.3.5** Integrar con NGINX

### 13.4 Adminer
- [ ] **13.4.1** ¿Qué es Adminer?
- [ ] **13.4.2** ¿Para qué sirve?
- [ ] **13.4.3** Escribir Dockerfile para Adminer
- [ ] **13.4.4** Configurar acceso a MariaDB
- [ ] **13.4.5** Probar gestión de base de datos

---

## FASE 14: Verificación Final

### 14.1 Checklist Obligatorio
- [ ] **14.1.1** Makefile funciona correctamente
- [ ] **14.1.2** docker-compose.yml está bien configurado
- [ ] **14.1.3** Los 3 Dockerfiles están escritos por ti
- [ ] **14.1.4** NGINX usa solo TLSv1.2 o TLSv1.3
- [ ] **14.1.5** NGINX es el único punto de entrada (puerto 443)
- [ ] **14.1.6** WordPress + php-fpm está configurado
- [ ] **14.1.7** MariaDB está configurado
- [ ] **14.1.8** Volúmenes en /home/maanguit/data
- [ ] **14.1.9** No se usan bind mounts
- [ ] **14.1.10** Restart policy configurada
- [ ] **14.1.11** Red configurada correctamente
- [ ] **14.1.12** Secrets configurados
- [ ] **14.1.13** .env file existe
- [ ] **14.1.14** Dominio maanguit.42.fr configurado
- [ ] **14.1.15** WordPress tiene 2 usuarios (admin no válido)
- [ ] **14.1.16** README.md completo
- [ ] **14.1.17** USER_DOC.md completo
- [ ] **14.1.18** DEV_DOC.md completo

### 14.2 Limpieza
- [ ] **14.2.1** Eliminar imágenes de prueba
- [ ] **14.2.2** Organizar estructura de archivos
- [ ] **14.2.3** Verificar que no hay archivos sensibles en git
- [ ] **14.2.4** Crear .gitignore apropiado

---

## 📚 Recursos de Estudio

### Docker
- Docker Official Documentation
- Docker Best Practices
- Dockerfile Best Practices

### NGINX
- NGINX Documentation
- NGINX Reverse Proxy
- NGINX SSL/TLS Configuration

### PHP-FPM
- PHP-FPM Configuration
- NGINX + PHP-FPM

### MariaDB
- MariaDB Documentation
- Docker MariaDB

### General
- Docker Compose Documentation
- 42 Intra Inception Subject

---

*Documento creado para el proyecto Inception (42)*
*Login: maanguit*
*Última actualización: 2026-03-14*
