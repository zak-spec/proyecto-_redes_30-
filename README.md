# 🚀 Proyecto Final - Redes 2

**Stack Profesional de WordPress con Docker Compose**

Implementación completa de WordPress utilizando contenedores Docker con arquitectura de microservicios, optimizado para rendimiento y seguridad.

---

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Arquitectura](#-arquitectura)
- [Características](#-características)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Configuración](#-instalación-y-configuración)
- [Uso](#-uso)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Comandos Útiles](#-comandos-útiles)
- [Troubleshooting](#-troubleshooting)
- [Información Académica](#-información-académica)

---

## 📖 Descripción

Este proyecto implementa un stack completo de WordPress utilizando Docker Compose, diseñado con las mejores prácticas de DevOps y arquitectura de contenedores. El sistema utiliza **Nginx** como servidor web y proxy reverso, **PHP-FPM** para procesamiento PHP de alto rendimiento, y **MySQL** como base de datos.

### 🎯 Objetivos del Proyecto

- Implementar arquitectura de microservicios con Docker
- Optimizar rendimiento mediante separación de responsabilidades
- Aplicar configuraciones de seguridad en entornos containerizados
- Demostrar conocimientos de redes y orquestación de contenedores

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                      Internet/Usuario                    │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  Nginx:80     │ ◄── Servidor Web
                    │  (Alpine)     │     Proxy Reverso
                    └───────┬───────┘     Archivos Estáticos
                            │
                            │ FastCGI
                            ▼
                ┌───────────────────────┐
                │  WordPress:9000       │ ◄── PHP-FPM 8.1
                │  (PHP-FPM)            │     Procesamiento
                └───────────┬───────────┘     Dinámico
                            │
                            │ MySQL Protocol
                            ▼
                    ┌───────────────┐
                    │  MySQL:3306   │ ◄── Base de Datos
                    │  (v8.0)       │     (Red Interna)
                    └───────────────┘
```

### 🔄 Flujo de Peticiones

1. **Cliente** → Solicitud HTTP al puerto 80
2. **Nginx** → Recibe petición:
   - Si es archivo estático (.css, .js, img) → Sirve directamente
   - Si es archivo PHP → Envía a WordPress vía FastCGI
3. **WordPress (PHP-FPM)** → Procesa código PHP
4. **MySQL** → Consulta/almacena datos si es necesario
5. **Respuesta** → Nginx → Cliente

---

## ✨ Características

### 🐳 Contenedores

- **MySQL 8.0**: Base de datos con healthchecks y configuración optimizada
- **WordPress 6.4**: PHP-FPM 8.1 para mejor rendimiento
- **Nginx Stable Alpine**: Servidor web ligero y eficiente

### 🔒 Seguridad

- ✅ MySQL **no expuesto** al host (solo red interna)
- ✅ WordPress **no accesible directamente** (solo vía Nginx)
- ✅ Volúmenes en modo **read-only** donde aplica
- ✅ Variables sensibles en archivo `.env` (ignorado por Git)
- ✅ Protección de archivos `.htaccess`

### ⚡ Rendimiento

- ✅ **PHP-FPM 8.1**: 20-30% más rápido que Apache
- ✅ **Nginx FastCGI**: Caché y optimización de archivos estáticos
- ✅ **Healthchecks**: Asegura que servicios estén listos antes de iniciar
- ✅ **Volúmenes persistentes**: Datos optimizados y separados

### 🛠️ Configuración

- ✅ Límites PHP personalizables (uploads, memoria, timeout)
- ✅ Variables de entorno para configuración flexible
- ✅ Charset UTF-8MB4 para soporte completo Unicode
- ✅ Redes Docker aisladas

---

## 📋 Requisitos Previos

### Software Necesario

- **Docker Desktop** (v20.10 o superior)
  - [Descargar para Windows](https://www.docker.com/products/docker-desktop/)
- **Docker Compose** (v3.8 o superior - incluido en Docker Desktop)
- **Git** (opcional, para clonar el repositorio)

### Recursos del Sistema

- **RAM**: Mínimo 4GB (Recomendado 8GB)
- **Disco**: Mínimo 2GB libres
- **Puerto 80**: Debe estar disponible

### Verificar Instalación

```powershell
# Verificar versión de Docker
docker --version

# Verificar versión de Docker Compose
docker-compose --version

# Verificar que Docker está corriendo
docker ps
```

---

## 🚀 Instalación y Configuración

### 1️⃣ Clonar el Repositorio

```powershell
git clone https://github.com/zak-spec/proyecto-_redes_30-.git
cd proyecto-_redes_30-/docker/compose
```

### 2️⃣ Configurar Variables de Entorno

El archivo `.env` contiene las configuraciones. Valores por defecto:

```env
# Base de Datos
MYSQL_ROOT_PASSWORD=admin
MYSQL_DATABASE=wordpressdb
MYSQL_USER=wpuser
MYSQL_PASSWORD=admin

# WordPress
WORDPRESS_DB_HOST=db:3306
WORDPRESS_DB_USER=wpuser
WORDPRESS_DB_PASSWORD=admin
WORDPRESS_DB_NAME=wordpressdb

# Puertos
NGINX_PORT=80

# Proyecto
COMPOSE_PROJECT_NAME=wordpress-stack
```

**⚠️ Recomendación**: Cambia las contraseñas en producción.

### 3️⃣ Iniciar el Stack

```powershell
# Iniciar todos los contenedores
docker-compose up -d

# Ver el progreso
docker-compose logs -f
```

### 4️⃣ Verificar Estado

```powershell
# Ver contenedores en ejecución
docker-compose ps

# Verificar healthchecks
docker ps
```

### 5️⃣ Acceder a WordPress

Abre tu navegador en: **http://localhost**

Completa la instalación de WordPress:
- Selecciona idioma
- Crea usuario administrador
- ¡Listo! 🎉

---

## 🎮 Uso

### Acceso a la Aplicación

- **Frontend WordPress**: http://localhost
- **Panel Admin**: http://localhost/wp-admin

### Gestión de Contenedores

```powershell
# Detener contenedores (mantiene datos)
docker-compose stop

# Iniciar contenedores detenidos
docker-compose start

# Reiniciar todos los servicios
docker-compose restart

# Detener y eliminar contenedores (mantiene volúmenes)
docker-compose down

# Eliminar TODO incluyendo datos (⚠️ CUIDADO)
docker-compose down -v
```

### Ver Logs

```powershell
# Todos los servicios
docker-compose logs -f

# Servicio específico
docker-compose logs -f nginx
docker-compose logs -f wordpress
docker-compose logs -f db

# Últimas 100 líneas
docker-compose logs --tail=100
```

---

## 📁 Estructura del Proyecto

```
docker/
├── compose/
│   ├── docker-compose.yml       # Configuración principal
│   ├── .env                      # Variables de entorno (NO en Git)
│   ├── .gitignore               # Archivos ignorados
│   ├── README.md                # Documentación detallada
│   │
│   ├── nginx/
│   │   └── default.conf         # Config Nginx + FastCGI
│   │
│   └── php/
│       └── uploads.ini          # Límites PHP personalizados
│
└── README.md                    # Este archivo
```

---

## 🔧 Comandos Útiles

### Backup de Base de Datos

```powershell
# Crear backup
docker exec mysql_db mysqldump -u root -padmin wordpressdb > backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql

# Restaurar backup
Get-Content backup.sql | docker exec -i mysql_db mysql -u root -padmin wordpressdb
```

### Acceso Directo a Contenedores

```powershell
# Shell en MySQL
docker exec -it mysql_db mysql -u root -padmin

# Shell en WordPress
docker exec -it wordpress_app bash

# Shell en Nginx
docker exec -it nginx_proxy sh
```

### Limpieza del Sistema

```powershell
# Eliminar contenedores no utilizados
docker container prune

# Eliminar imágenes no utilizadas
docker image prune

# Limpieza completa del sistema
docker system prune -a --volumes
```

### Modificar Configuración PHP

Edita `compose/php/uploads.ini` y reinicia:

```powershell
docker-compose restart wordpress
```

---

## 🐛 Troubleshooting

### ❌ Error: "Puerto 80 ya en uso"

**Solución**: Cambia el puerto en `.env`
```env
NGINX_PORT=8080
```
Luego reinicia: `docker-compose up -d`

### ❌ WordPress no conecta a MySQL

**Causa**: MySQL no está listo

**Solución**: 
```powershell
# Ver logs de MySQL
docker-compose logs db

# Verificar healthcheck
docker inspect mysql_db | findstr Health
```

### ❌ Error 502 Bad Gateway

**Causa**: WordPress no está respondiendo

**Solución**:
```powershell
# Ver logs de WordPress
docker-compose logs wordpress

# Reiniciar servicio
docker-compose restart wordpress
```

### ❌ Problemas de permisos en archivos

**Solución**:
```powershell
docker exec -it wordpress_app chown -R www-data:www-data /var/www/html
```

### ❌ "Failed to connect to MySQL"

**Solución**: Verifica variables en `.env`
```env
WORDPRESS_DB_HOST=db:3306
WORDPRESS_DB_USER=wpuser
WORDPRESS_DB_PASSWORD=admin
WORDPRESS_DB_NAME=wordpressdb
```

---

## 📊 Información Académica

### 🎓 Datos del Proyecto

- **Institución**: Universidad [Tu Universidad]
- **Carrera**: Ingeniería de Sistemas
- **Curso**: Redes 2
- **Semestre**: 8vo
- **Proyecto**: Implementación de Stack WordPress con Docker
- **Repositorio**: [proyecto-_redes_30-](https://github.com/zak-spec/proyecto-_redes_30-)

### 📚 Conceptos Aplicados

- Contenedores Docker y orquestación
- Redes virtuales y aislamiento
- Proxy reverso y FastCGI
- Healthchecks y dependencias entre servicios
- Volúmenes persistentes
- Variables de entorno
- Arquitectura de microservicios

### 🎯 Objetivos de Aprendizaje Cumplidos

- ✅ Implementación de stack LEMP (Linux, Nginx, MySQL, PHP)
- ✅ Orquestación de contenedores con Docker Compose
- ✅ Configuración de redes Docker
- ✅ Gestión de volúmenes persistentes
- ✅ Aplicación de prácticas de seguridad
- ✅ Optimización de rendimiento

---

## 📝 Notas Importantes

- 📌 Los datos persisten en volúmenes Docker incluso si eliminas contenedores
- 📌 El archivo `.env` contiene información sensible - **NO** subir a Git
- 📌 Para producción, usar contraseñas seguras y certificados SSL
- 📌 Los healthchecks aseguran inicio correcto de servicios
- 📌 Nginx sirve archivos estáticos directamente para mejor rendimiento

---

## 🤝 Contribuciones

Este es un proyecto académico. Sugerencias y mejoras son bienvenidas.

---

## 📄 Licencia

Proyecto educativo - Uso libre para fines académicos

---

## 📧 Contacto

**Autor**: [Tu Nombre]  
**GitHub**: [@zak-spec](https://github.com/zak-spec)  
**Proyecto**: [proyecto-_redes_30-](https://github.com/zak-spec/proyecto-_redes_30-)

---

## 🌟 Recursos Adicionales

- [Documentación Docker](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [WordPress Docker Hub](https://hub.docker.com/_/wordpress)
- [MySQL Docker Hub](https://hub.docker.com/_/mysql)
- [Nginx Docker Hub](https://hub.docker.com/_/nginx)

---

**⭐ Si este proyecto te fue útil, no olvides darle una estrella en GitHub!**

---

*Última actualización: Octubre 2025*
