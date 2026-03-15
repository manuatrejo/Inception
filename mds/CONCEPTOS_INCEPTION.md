# Conceptos Fundamentales - Proyecto Inception

Este documento explica los conceptos técnicos necesarios para completar el proyecto Inception de 42.

---

## 1. Docker

### 1.1 ¿Qué es Docker?

Docker es una plataforma de virtualización a nivel de sistema operativo que permite empaquetar aplicaciones en contenedores. A diferencia de las máquinas virtuales, los contenedores comparten el kernel del sistema operativo host, haciéndolos más ligeros y rápidos.

### 1.2 Diferencia entre Contenedores y Máquinas Virtuales

| Aspecto | Máquina Virtual | Contenedor Docker |
|---------|-----------------|-------------------|
| **Kernel** | Kernel propio | Comparte kernel del host |
| **Tamaño** | Gigabytes | Megabytes |
| **Inicio** | Minutos | Segundos |
| **Aislamiento** | Total (hardware) | A nivel de SO |
| **Recursos** | Asignación fija | Compartidos |

### 1.3 Imágenes Docker

Una imagen es una plantilla de solo lectura que contiene todo lo necesario para ejecutar una aplicación: código, runtime, librerías, y configuración. Los contenedores son instancias de imágenes.

```bash
# Ejemplo: descargar imagen debian
docker pull debian:bookworm-slim
```

---

## 2. Dockerfile

### 2.1 ¿Qué es un Dockerfile?

Un Dockerfile es un script que contiene instrucciones para construir una imagen Docker. Cada instrucción crea una capa en la imagen.

### 2.2 Instrucciones básicas

```dockerfile
FROM debian:bookworm-slim    # Imagen base
RUN apt-get update           # Ejecutar comandos
COPY ./config /app/          # Copiar archivos
WORKDIR /app                 # Directorio de trabajo
EXPOSE 80                    # Puerto a exponer
ENV VAR=value                # Variable de entorno
ENTRYPOINT ["./entry.sh"]   # Comando principal
CMD ["nginx", "-g", "daemon off;"]  # Comando por defecto
```

### 2.3 El Problema PID 1

En Linux, el proceso con PID 1 es el primer proceso que se ejecuta al iniciar el sistema. Este proceso tiene responsabilidades especiales:

1. Es el padre de todos los procesos orphans
2. Maneja señales (SIGTERM, SIGINT)
3. Recoge procesos zombies

**En Docker**, si tu contenedor ejecuta un proceso que no maneja señales correctamente, el contenedor no se detendrá limpiamente.

#### Procesos que NO debes usar:

```dockerfile
# ❌ MALO - No maneja señales
CMD ["tail", "-f", "/dev/null"]
CMD ["sleep", "infinity"]
CMD ["bash"]  # bash por defecto no forwards señales

# ✅ BIEN - Maneja señales correctamente
CMD ["nginx", "-g", "daemon off;"]
CMD ["php-fpm8"]
```

#### Soluciones:

1. **Usar el proceso directamente**: Ejecutar el servicio como PID 1
2. **Usar un init system**: docker-init o tini
3. **Usar exec en entrypoint**: `exec "$@"` al final del script

```bash
#!/bin/sh
# Ejemplo de entrypoint correcto
echo "Starting service..."
exec php-fpm
```

### 2.4 Best Practices para Dockerfiles

1. **Orden de capas**: Pon los cambios menos frecuentes primero
2. **Multi-stage builds**: Reducir tamaño final
3. **No usar latest tag**: Especificar versiones exactas
4. **Limpiar caché**: `apt-get clean && rm -rf /var/lib/apt/lists/*`
5. **Un solo servicio por contenedor**: No mezclar responsabilidades

```dockerfile
# ✅ Ejemplo bien estructurado
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mariadb-server \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mariadbd"]
```

---

## 3. Docker Compose

### 3.1 ¿Qué es Docker Compose?

Docker Compose es una herramienta para definir y ejecutar aplicaciones multi-contenedor. Se configura todo en un archivo `docker-compose.yml`.

### 3.2 Estructura básica

```yaml
version: "3.8"

services:
  nombre_del_servicio:
    build: ./ruta/Dockerfile
    image: nombre-imagen
    container_name: nombre-contenedor
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - nombre_volumen:/ruta/en/contenedor
    environment:
      - VARIABLE=valor
    secrets:
      - secret_name
    networks:
      - nombre_red
    depends_on:
      - otro_servicio

volumes:
  nombre_volumen:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /ruta/en/host

networks:
  nombre_red:
    driver: bridge
```

### 3.3 Redes en Docker

```yaml
# Red por defecto (bridge)
networks:
  default:
    driver: bridge    # ✅ Recomendado
    # host:          # ❌ Prohibido en Inception
    # link:         # ❌ Prohibido en Inception
```

**Tipos de redes:**
- **bridge**: Red privada para contenedores
- **host**: Comparte red con el host (PROHIBIDO)
- **overlay**: Multi-host Swarm
- **none**: Sin red

### 3.4 Restart Policy

| Política | Comportamiento |
|----------|----------------|
| `no` | No reiniciar (default) |
| `always` | Siempre reiniciar |
| `on-failure` | Reiniciar si sale con error |
| `unless-stopped` | Reiniciar siempre excepto si se para manualmente |

**Inception requiere**: `restart: unless-stopped`

---

## 4. NGINX

### 4.1 ¿Qué es NGINX?

NGINX es un servidor web de alto rendimiento que también funciona como reverse proxy, load balancer, y cache. En este proyecto actúa como punto de entrada a la infraestructura.

### 4.2 Reverse Proxy

Un reverse proxy recibe peticiones del cliente y las reenvía a servidores internos. En este proyecto:

```
Cliente → NGINX (443) → WordPress (9000)
```

### 4.3 Configuración básica

```nginx
server {
    listen 443 ssl;
    server_name maanguit.42.fr;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://wordpress:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 4.4 TLS/SSL

**TLS (Transport Layer Security)** es el protocolo que asegura la comunicación encriptada.

#### Certificados:
- **Auto-firmados**: Generados por ti mismo (para desarrollo)
- **Let's Encrypt**: Certificados gratuitos y automáticos
- **CA comercial**: VeriSign, DigiCert, etc.

```bash
# Generar certificado auto-firmado
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout key.pem -out cert.pem
```

#### Versiones de TLS:
- **TLSv1.0**: Deprecated (no usar)
- **TLSv1.1**: Deprecated (no usar)
- **TLSv1.2**: ✅ Seguro
- **TLSv1.3**: ✅ Más seguro y rápido

**Inception requiere**: Solo TLSv1.2 o TLSv1.3

---

## 5. WordPress + PHP-FPM

### 5.1 ¿Qué es WordPress?

WordPress es un CMS (Content Management System) escrito en PHP. Es el sistema de gestión de contenidos más popular del mundo.

### 5.2 ¿Qué es PHP-FPM?

**PHP-FPM (FastCGI Process Manager)** es un gestor de procesos FastCGI para PHP. Es más eficiente que el mod_php de Apache.

```
WordPress (PHP) → PHP-FPM (procesa .php) → NGINX (sirve contenido)
```

### 5.3 Arquitectura

```
NGINX (Puerto 443)
    ↓ proxy_pass
PHP-FPM (Puerto 9000) - Contenedor WordPress
    ↓ conexión TCP
MariaDB (Puerto 3306) - Contenedor MariaDB
```

### 5.4 Configuración PHP-FPM

```ini
; www.conf
[www]
user = www-data
group = www-data
listen = 9000
listen.allowed_clients = 127.0.0.1
```

### 5.5 Conexión NGINX + PHP-FPM

```nginx
location ~ \.php$ {
    fastcgi_pass wordpress:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
```

---

## 6. MariaDB

### 6.1 ¿Qué es MariaDB?

MariaDB es un fork de MySQL, desarrollado originalmente por los creadores de MySQL. Es una base de datos relacional compatible con MySQL.

### 6.2 Características

- Código abierto
- Alta compatibilidad con MySQL
- Mejor rendimiento en algunos casos
- Storage engines: InnoDB, MyRocks, Aria

### 6.3 Configuración básica

```ini
[mysqld]
bind-address = 0.0.0.0
max_connections = 100
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
```

### 6.4 Inicialización

MariaDB puede ejecutar scripts SQL al iniciar:

```bash
#!/bin/bash
set -e

echo "Creating database and users..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
    FLUSH PRIVILEGES;
EOSQL

exec mariadbd --user=mysql
```

---

## 7. Volúmenes y Persistencia

### 7.1 Tipos de almacenamiento en Docker

| Tipo | Persistencia | Uso |
|------|--------------|-----|
| **Named Volumes** | ✅ Persisten | Datos de aplicaciones (BD, archivos) |
| **Bind Mounts** | ✅ Persisten | Desarrollo, archivos del host |
| **tmpfs** | ❌ En memoria | Datos temporales sensibles |
| **Ephermal** | ❌ Se pierde | Datos temporales |

### 7.2 Named Volumes

Los volúmenes nombrados son la forma recomendada de persistir datos:

```yaml
volumes:
  db_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/maanguit/data/database
```

**En Inception**:
- `/home/maanguit/data/database` → MariaDB (`/var/lib/mysql`)
- `/home/maanguit/data/website` → WordPress (`/var/www/html`)

### 7.3 Bind Mounts vs Named Volumes

| Característica | Bind Mount | Named Volume |
|----------------|------------|--------------|
| **Host path** | Definido por usuario | Gestionado por Docker |
| **Portabilidad** | Dependiente del host | Portable entre hosts |
| **Rendimiento** | Similar | Similar |
| **Permisos** | Puede tener problemas | Gestionados por Docker |
| **Uso en Inception** | ❌ No permitido | ✅ Obligatorio |

---

## 8. Docker Secrets

### 8.1 ¿Qué son los Secrets?

Los Docker Secrets son la forma segura de almacenar datos sensibles en Docker Swarm. En Docker Compose standalone, se pueden simular con archivos.

### 8.2 Secrets vs Environment Variables

| Aspecto | Environment Variables | Secrets |
|---------|----------------------|---------|
| **Seguridad** | Baja (visibles en procesos) | Alta (montados como tmpfs) |
| **Uso** | Configuración no sensible | Contraseñas, API keys, tokens |
| **Visibilidad** | `docker inspect`, logs | Solo proceso específico |
| **En Inception** | Dominio, nombre usuario BD | Contraseñas |

### 8.3 Implementación en Docker Compose

```yaml
services:
  mariadb:
    secrets:
      - db_root_password
      - db_password

secrets:
  db_root_password:
    file: ./secrets/db_root_password.txt
  db_password:
    file: ./secrets/db_password.txt
```

### 8.4 Uso en Dockerfile

```bash
#!/bin/bash
# Leer secret del archivo
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)

# Usar la variable
mysql -u root -p"$MYSQL_ROOT_PASSWORD"
```

---

## 9. Redes Docker

### 9.1 Tipos de redes

```yaml
# Bridge (default) - red privada
networks:
  app_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
```

### 9.2 Comunicación entre contenedores

Los contenedores en la misma red se comunican por nombre:

```bash
# Desde wordpress puedo hacer ping a mariadb
ping mariadb

# NGINX puede conectar a wordpress:9000
```

### 9.3 DNS automático

Docker proporciona DNS interno. Cada servicio es accesible por su nombre.

---

## 10. Seguridad

### 10.1 Buenas prácticas

1. **No incluir contraseñas en Dockerfiles**
2. **Usar secrets para datos sensibles**
3. **No exponer puertos innecesarios**
4. **Usar usuario no-root en contenedores**
5. **Actualizar imágenes regularmente**
6. **TLS mínimo v1.2**

### 10.2 Errores de seguridad a evitar

```dockerfile
# ❌ MALO - Contraseña en texto
ENV MYSQL_ROOT_PASSWORD=secret123

# ✅ BIEN - Usar secrets
ENV MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password
```

---

## 11. Comandos útiles

### Docker
```bash
docker build -t nombre .                    # Construir imagen
docker run -d --name nombre imagen          # Ejecutar contenedor
docker ps                                   # Ver contenedores activos
docker ps -a                                # Ver todos los contenedores
docker logs -f nombre                       # Ver logs
docker exec -it nombre sh                   # Entrar al contenedor
docker stop nombre                          # Parar contenedor
docker rm nombre                            # Eliminar contenedor
```

### Docker Compose
```bash
docker compose build                        # Construir servicios
docker compose up -d                        # Iniciar servicios
docker compose down                         # Parar servicios
docker compose logs -f                      # Ver logs
docker compose exec servicio comando        # Ejecutar en servicio
docker compose restart servicio             # Reiniciar servicio
docker compose ps                           # Estado de servicios
```

### Volumes
```bash
docker volume ls                            # Listar volúmenes
docker volume inspect nombre                # Ver detalles
docker volume rm nombre                     # Eliminar
```

### Redes
```bash
docker network ls                           # Listar redes
docker network inspect nombre               # Ver detalles
```

---

## 12. Glosario

| Término | Definición |
|---------|------------|
| **Container** | Instancia ejecutable de una imagen |
| **Image** | Plantilla de solo lectura para crear contenedores |
| **Dockerfile** | Script con instrucciones para construir una imagen |
| **Volume** | Almacenamiento persistente fuera del contenedor |
| **Network** | Sistema de comunicación entre contenedores |
| **Bridge** | Driver de red que crea una red privada |
| **TLS/SSL** | Protocolos de encriptación para comunicación segura |
| **Reverse Proxy** | Servidor que redistribuye peticiones a otros servidores |
| **PID 1** | Primer proceso en un sistema Linux |
| **PHP-FPM** | Gestor de procesos FastCGI para PHP |
| **CMS** | Content Management System |

---

## 13. Conceptos Adicionales para Inception

### 13.1 Alpine vs Debian

El proyecto permite usar Alpine o Debian como imagen base:

```dockerfile
# Opción 1: Debian
FROM debian:bookworm-slim

# Opción 2: Alpine
FROM alpine:latest
```

| Aspecto | Alpine | Debian |
|---------|--------|--------|
| **Tamaño** | ~5MB | ~80MB |
| **Paquetes** | apk | apt |
| **Ligereza** | Más ligero | Más compatibilidad |

### 13.2 FastCGI

**FastCGI** es un protocolo que permite a un servidor web comunicarse con aplicaciones externas de forma eficiente. A diferencia de CGI tradicional, FastCGI mantiene procesos persistentes.

```
CGI tradicional:      Petición → Nuevo proceso → Respuesta → Fin proceso
FastCGI:              Petición → Proceso persistente → Respuesta (reutiliza proceso)
```

**Flujo en Inception**:
```
NGINX → FastCGI (protocolo) → PHP-FPM (procesa .php) → WordPress
```

### 13.3 WP-CLI

**WP-CLI** es la interfaz de línea de comandos para WordPress. Permite gestionar WordPress sin navegador:

```bash
# Instalar WordPress
wp core install --url=maanguit.42.fr --title="Mi Sitio" --admin_user=admin --admin_password=pass --admin_email=email@email.com

# Instalar plugin
wp plugin install redis-cache --activate

# Actualizar WordPress
wp core update
```

### 13.4 Entrypoint Scripts

Los scripts de entrada se ejecutan cuando el contenedor inicia, antes del proceso principal:

```bash
#!/bin/sh
set -e

echo "Inicializando MariaDB..."

# Esperar a que MariaDB esté listo
until mysql -u root -p"$MYSQL_ROOT_PASSWORD" &> /dev/null; do
    echo "Esperando a MariaDB..."
    sleep 2
done

echo "MariaDB listo!"

# IMPORTANTE: exec reemplaza el proceso actual
exec "$@"
```

**Puntos clave**:
- `set -e` - Sale si hay error
- `exec "$@"` - Ejecuta el CMD final (reemplaza PID 1)

### 13.5 Makefile

Makefile automatiza la construcción del proyecto:

```makefile
.PHONY: all build up down clean re

all: build up

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

clean: down
	docker compose down -v --rmi local

re: down all
```

**Comandos make**:
- `make all` - Construye y levanta
- `make build` - Solo construye imágenes
- `make up` - Solo levanta contenedores
- `make down` - Para contenedores
- `make clean` - Elimina todo (incluyendo volúmenes)
- `make re` - Recrea todo

### 13.6 Openssl y Certificados

```bash
# Generar clave privada
openssl genrsa -out server.key 2048

# Generar certificado autofirmado
openssl req -new -x509 -key server.key -out server.crt -days 365

# O en un solo comando
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout server.key -out server.crt
```

**Archivos generados**:
- `.key` - Clave privada (SECRETO)
- `.crt` / `.pem` - Certificado público

### 13.7 Permisos en Linux

Los contenedores necesitan permisos correctos:

```bash
# En Dockerfile
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html
```

**UID/GID comunes**:
- `www-data` (Debian/Ubuntu)
- `nginx` (Alpine)
- `apache` (RHEL/CentOS)

### 13.8 DNS Local (/etc/hosts)

Para desarrollo local, configura el dominio en `/etc/hosts`:

```bash
# Añadir al archivo /etc/hosts
127.0.0.1    maanguit.42.fr
```

Esto hace que `maanguit.42.fr` resuelva a tu máquina local.

### 13.9 Puertos de Inception

| Puerto | Servicio | Propósito |
|--------|----------|-----------|
| 443 | NGINX | Único punto de entrada (HTTPS) |
| 9000 | PHP-FPM | FastCGI para WordPress |
| 3306 | MariaDB | Base de datos (no expuesto) |

### 13.10 Docker .dockerignore

Evita copiar archivos innecesarios:

```
# .dockerignore
*.md
.git
.gitignore
.env
secrets/
*.log
node_modules/
```

### 13.11 WordPress - Dos Usuarios

El proyecto requiere:
- Usuario administrador (NO puede ser admin/Admin/administrator)
- Un segundo usuario

```sql
-- Crear usuario administrador
CREATE USER 'webmaster'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'webmaster'@'%';

-- Crear segundo usuario
CREATE USER 'editor'@'%' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON wordpress.* TO 'editor'@'%';

FLUSH PRIVILEGES;
```

### 13.12 Docker Init (tini)

Para resolver el problema PID 1, puedes usar un init:

```dockerfile
# Añadir tini
RUN apt-get install -y tini

# Usar tini como entrypoint
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["mariadbd"]
```

### 13.13 Wait-for-it / Healthcheck

Espera a que un servicio esté listo:

```bash
#!/bin/sh
# wait-for-it.sh
HOST="$1"
PORT="$2"
shift 2

until nc -z "$HOST" "$PORT"; do
    echo "Esperando a $HOST:$PORT..."
    sleep 2
done

exec "$@"
```

### 13.14 Comparaciones del README

**VM vs Docker**:

| Aspecto | Máquina Virtual | Contenedor |
|---------|-----------------|------------|
| Aislamiento | Total (hardware) | Namespaces Linux |
| Recursos | Asignación fija | Compartidos |
| Tamaño | GB | MB |
| Inicio | Minutos | Segundos |
| Portabilidad | Difícil | Fácil |

**Secrets vs Environment Variables**:

| Aspecto | Environment Variables | Secrets |
|---------|----------------------|---------|
| Almacenamiento | Memoria del proceso | tmpfs (montaje seguro) |
| Visibilidad | docker inspect, logs | Limitada |
| Uso | Configuración no sensible | Contraseñas, API keys |

**Docker Network vs Host Network**:

| Aspecto | Docker Network | Host Network |
|---------|----------------|---------------|
| Aislamiento | Total | Comparte red del host |
| Seguridad | Mayor | Menor |
| Puertos | Necesita mapping | Acceso directo |

**Docker Volumes vs Bind Mounts**:

| Aspecto | Docker Volumes | Bind Mounts |
|---------|----------------|--------------|
| Ubicación | /var/lib/docker | Ruta absoluta del host |
| Portabilidad | Entre hosts | Dependiente del host |
| Permisos | Gestionados por Docker | Del host |

---

*Documento creado para el proyecto Inception (42)*
*Login: maanguit*
