# museo-tabd

Trabajo para la asignatura Tecnología Avanzada de Bases de Datos en el que desarrollamos la base de datos de un museo así como un frontend para poder representar la información contenida en la base de datos.

## esplegar entorno de desarrollo

Este proyecto contiene un entorno de desarrollo basado en Docker con Oracle Database XE.

## 📦 Requisitos previos

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [SQL Developer](https://www.oracle.com/tools/downloads/sqldev-downloads.html) (opcional, para conectarte visualmente)

## 🚀 Despliegue del entorno

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/tu-repo.git
cd tu-repo
```

### 2. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto con el siguiente contenido:

```
ORACLE_PASSWORD=database_password
ORACLE_SID=XE
```

### 3. Construir y levantar los contenedores

En la raiz principal del proyecto ejecutar el comando:

```bash
docker-compose up --build
```

Esto descargará la imagen de Oracle XE y creará un contenedor llamado `oracle-database`. Se exponen los puertos:

- `31521` → Oracle DB (internamente es el 1521)
- `5500` → Oracle APEX o SQL Developer Web (si aplica)

Puedes ver los logs con:

```bash
docker logs -f oracle-database
```

## 🖥️ Conexión desde SQL Developer

1. Abre SQL Developer.
2. Crea una nueva conexión.
3. Introduce los siguientes datos:

- **Nombre:** OracleXE  
- **Usuario:** system  
- **Contraseña:** password_database
- **Hostname:** localhost
- **Puerto:** 31521  
- **Tipo de conexión:** Servicio  
- **Servicio:** XEPDB1

Haz clic en "Conectar".

⚠️ Aunque el SID del contenedor es `XE`, el **servicio para conexiones externas** es `XEPDB1`.

## 📂 Estructura del proyecto

```
.
├── .env                 # Variables de entorno
├── docker-compose.yml  # Configuración de servicios
├── database/
│   └── Dockerfile       # Dockerfile para Oracle XE
```

## 🧹 Limpieza

Si necesitas reiniciar completamente el entorno (incluyendo los datos persistentes):

```bash
docker-compose down -v
docker-compose up --build
```
