# Guía de Estudio - Proyecto Inception (42)

## Overview del Proyecto

Este proyecto consiste en crear una infraestructura con múltiples servicios usando Docker:
- NGINX (punto de entrada con TLS)
- WordPress + php-fpm
- MariaDB
- Volúmenes nombrados para persistencia

---

## 1. Preparación del Entorno

### 1.1 Requisitos previos
- Máquina virtual con Linux (Debian/Alpine recomendado)
- Docker instalado
- Docker Compose instalado
- Tu login de 42: **maanguit**

### 1.2 Estructura de directorios
```
inception/
├── Makefile
├── .env
├── secrets/
│   ├── db_root_password.txt
│   ├── db_password.txt
│   └── credentials.txt
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

---

## 2. Conceptos Clave (Investigar)

### 2.1 Dockerfiles - PID 1 Problem
**MUY IMPORTANTE**: Los contenedores no son máquinas virtuales. Evita:
- `tail -f`
- `sleep infinity`
- `while true`

Investiga: **Docker daemon**, **PID 1**, **docker init system**

### 2.2 Secrets vs Environment Variables
- **Environment variables**: Datos no sensibles (DOMAIN_NAME, MYSQL_USER)
- **Docker secrets**: Contraseñas, API keys, credentials

### 2.3 TLS/SSL
- NGINX debe usar solo TLSv1.2 o TLSv1.3
- Necesitas certificados SSL (puedes generar los tuyos con openssl)

### 2.4 Volumes
- **Named volumes**: Persisten datos fuera del contenedor
- **Bind mounts**: NO permitidos para este proyecto
- Ruta: `/home/maanguit/data` en el host

---

## 3. Paso a Paso

### Paso 1: Preparar secretos
Crear archivos en `secrets/`:
```bash
# Generar contraseñas seguras
openssl rand -base64 32 > secrets/db_root_password.txt
openssl rand -base64 32 > secrets/db_password.txt
```

### Paso 2: Configurar .env
```env
DOMAIN_NAME=maanguit.42.fr
MYSQL_USER=wordpress_user
MYSQL_DATABASE=wordpress
```

### Paso 3: Dockerfiles

#### MariaDB (Debian/Alpine)
- Base image: debian:bookworm-slim o alpine:latest
- Instalar mariadb-server
- Copiar configuración
- Exponer puerto 3306
- Usar scripts de inicialización

#### WordPress + php-fpm
- Instalar php-fpm, wordpress, wp-cli
- Configurar php-fpm
- No instalar nginx aquí

#### NGINX
- Instalar nginx
- Configurar SSL/TLS (solo TLSv1.2/1.3)
- Proxy pass a wordpress:9000
- Exponer solo puerto 443

### Paso 4: docker-compose.yml
```yaml
services:
  nginx:
    build: ./requirements/nginx
    restart: unless-stopped
    ports:
      - "443:443"
    volumes:
      - wordpress_data:/home/maanguit/data
    depends_on:
      - wordpress

  wordpress:
    build: ./requirements/wordpress
    restart: unless-stopped
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - mariadb

  mariadb:
    build: ./requirements/mariadb
    restart: unless-stopped
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/maanguit/data/database

  wordpress_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/maanguit/data/website

networks:
  default:
    driver: bridge
```

### Paso 5: Makefile
```makefile
.PHONY: all build up down clean

all: build up

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

clean: down
	docker compose down -v --rmi local
```

### Paso 6: Configurar dominio
```bash
# Añadir al /etc/hosts
127.0.0.1    maanguit.42.fr
```

---

## 4. Configuración de WordPress

### 4.1 Crear base de datos y usuarios
- Usuario administrador: NO usar "admin", "Admin", "administrator"
- Crear segundo usuario

### 4.2 Instalar WordPress
- Usar wp-cli o instalación automática via docker-entrypoint

---

## 5. Documentación Requerida

### 5.1 README.md
- Primera línea: _This project has been created as part of the 42 curriculum by maanguit._
- Description: Explicar qué es Docker y el proyecto
- Instructions: Cómo compilar y ejecutar
- Resources: Referencias y cómo se usó AI
- Comparaciones:
  - VM vs Docker
  - Secrets vs Environment Variables
  - Docker Network vs Host Network
  - Docker Volumes vs Bind Mounts

### 5.2 USER_DOC.md
- Qué servicios proporciona
- Cómo iniciar/detener
- Cómo acceder al sitio y admin panel
- Dónde están las credenciales
- Cómo verificar que los servicios funcionan

### 5.3 DEV_DOC.md
- Setup desde cero
- Build y launch con Makefile
- Comandos para gestionar contenedores
- Dónde se almacena y persiste los datos

---

## 6. Puntos de Evaluación (Prerrequisitos)

- [ ] Todos los Dockerfiles escritos por ti (no usar imágenes pre-hechas)
- [ ] Contenedores reinician si crashan (`restart: unless-stopped`)
- [ ] NGINX es el único punto de entrada (puerto 443)
- [ ] TLSv1.2 o TLSv1.3 solo
- [ ] Volúmenes nombrados en `/home/maanguit/data`
- [ ] No usar network: host, --link, o links
- [ ] No passwords en Dockerfiles (usar secrets)
- [ ] Usar .env file
- [ ] Dominio: maanguit.42.fr
- [ ] Dos usuarios en WordPress (admin no permitido)

---

## 7. Bonus (Opcional)

Si completas el obligatorio perfectamente:
1. **Redis cache** - Para WordPress
2. **FTP server** - Apuntando al volumen de WP
3. **Static website** - En otro lenguaje (no PHP)
4. **Adminer** - Gestor de DB

---

## 8. Recursos Recomendados

### Documentación oficial
- [Docker Docs](https://docs.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [NGINX SSL/TLS](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [WordPress + php-fpm](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)

### Temas a investigar más
- Docker multi-stage builds
- Docker entrypoint scripts
- Mariadb initialization scripts
- PHP-FPM pool configuration
- SSL certificates (let's encrypt o auto-firmados)

---

## 9. Errores Comunes a Evitar

1. ❌ Usar `tail -f` o `sleep infinity` en Dockerfiles
2. ❌ Poner contraseñas en texto plano en Dockerfiles
3. ❌ Usar bind mounts en vez de named volumes
4. ❌ Exponer puerto 80 en NGINX (solo 443)
5. ❌ Usar "admin" como usuario de WordPress
6. ❌ No configurar restart policy
7. ❌ Olvidar la red entre contenedores
8. ❌ Usar imagen "latest" en Dockerfiles

---

*Última actualización: 2026-03-14*
*Proyecto: Inception (42)*
*Login: maanguit*
