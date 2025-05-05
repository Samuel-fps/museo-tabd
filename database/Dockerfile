# Usamos la imagen base de Oracle XE
FROM gvenzl/oracle-xe:latest

# Establece las variables de entorno necesarias para Oracle
ENV ORACLE_SID=XEPDB1

# Exponemos los puertos para acceder a Oracle y al SQL Developer
EXPOSE 1521 5500

# Copiar los scripts de inicialización
COPY ./init_script/init_script.sql /opt/oracle/scripts/startup/

# Copiar todos los demás scripts (como create_types.sql, etc.) en una subcarpeta /opt/oracle/scripts/sql-scripts/
COPY *sql /opt/oracle/scripts/sql-scripts/



