-- Eliminar las tablas en el orden correcto
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE VISITAS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EXPOSICIONES CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTES CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADOS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ROLES CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE DEPARTAMENTOS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE AUTORES CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SALAS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CONTRATOS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Si la tabla no existe, no hace nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ENTRADAS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE VENTAS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE OBRAS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADOS_VISITAS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ROLES_EMPLEADOS CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SALAS_EXPOSICIONES CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/




-- Tabla de contratos
CREATE TABLE CONTRATOS (
    cod_contrato       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_ini          DATE NOT NULL,
    fecha_fin          DATE DEFAULT NULL,
    sueldo             NUMBER(10, 2) NOT NULL,
    jornada_laboral    VARCHAR2(50) NOT NULL,
    estado             VARCHAR2(20) NOT NULL

);

-- Tabla de salas
CREATE TABLE SALAS (
    cod_sala           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(255),
    localizacion       VARCHAR2(100)

);

-- Tabla de roles
CREATE TABLE ROLES (
    cod_rol            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(50) NOT NULL,
    descripcion        VARCHAR2(255)

);

-- Tabla de autores
CREATE TABLE AUTORES(
    cod_autor          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             TipoNombre NOT NULL,
    pais_origen        VARCHAR2(50),
    fecha_nacimiento   DATE,
    fecha_muerte       DATE,
    num_obras          INTEGER DEFAULT 0,
    estilo             VARCHAR2(100)

);

-- Tabla de departamentos
CREATE TABLE DEPARTAMENTOS (
    cod_departamento   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    cod_encargado      NUMBER

);

-- Tabla de empleados
CREATE TABLE EMPLEADOS (
    cod_empleado       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             TipoNombre NOT NULL,
    fecha_nacimiento    DATE,
    telefonos           TipoListaTelefonos,
    Direccion           TipoDireccion,
    email               VARCHAR2(100) NOT NULL,
    cod_contrato       NUMBER NOT NULL,
    cod_departamento   NUMBER NOT NULL,

    CONSTRAINT fk_contrato 
        FOREIGN KEY (cod_contrato) REFERENCES CONTRATOS(cod_contrato),
    CONSTRAINT fk_departamento 
        FOREIGN KEY (cod_departamento) REFERENCES departamentos(cod_departamento)
);

ALTER TABLE DEPARTAMENTOS
ADD CONSTRAINT fk_encargado FOREIGN KEY (cod_encargado) REFERENCES EMPLEADOS(cod_empleado);


-- Tabla de clientes
CREATE TABLE CLIENTES (
    cod_cliente        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             TipoNombre NOT NULL,
    fecha_nacimiento   DATE,
    telefonos          TipoListaTelefonos NOT NULL,
    email              VARCHAR2(100) NOT NULL,

    CONSTRAINT chk_email CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_telefono CHECK (telefonos IS NOT NULL)

);


-- Tabla de ventas
CREATE TABLE VENTAS (
    cod_venta          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha              DATE DEFAULT SYSDATE NOT NULL,
    cod_empleado       NUMBER,

    CONSTRAINT fk_empleado 
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)
);

-- Tabla de entradas
CREATE TABLE ENTRADAS (
    cod_entrada        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    precio             NUMBER(7, 2) NOT NULL,
    fecha              DATE NOT NULL,
    tipo               VARCHAR2(20) NOT NULL,
    cod_cliente        NUMBER NOT NULL,
    cod_venta          NUMBER,
    cod_visita         NUMBER,
    cod_empleado       NUMBER,

    CONSTRAINT fk_entrada_empleado1
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado),
    
    CONSTRAINT chk_tipo CHECK (tipo IN ('Física', 'Online')),
    CONSTRAINT chk_precio CHECK (precio > 0),

    CONSTRAINT fk_cliente
        FOREIGN KEY (cod_cliente) REFERENCES CLIENTES(cod_cliente),
    CONSTRAINT fk_venta
        FOREIGN KEY (cod_venta) REFERENCES VENTAS(cod_venta),
    CONSTRAINT fk_visita
        FOREIGN KEY (cod_visita) REFERENCES VISITAS(cod_visita)
);

-- Tabla de visitas
CREATE TABLE VISITAS (
    cod_visita   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(100) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    cupo_maximo        NUMBER,
    idioma             VARCHAR2(50),
    tipo_visita               VARCHAR2(20),
    cod_empleado        NUMBER,
    

     CONSTRAINT chk_tipo_visita CHECK (tipo_visita IN ('Guiada', 'Autoguiada', 'Virtual')),
    CONSTRAINT chk_fecha_visita CHECK (fecha_inicio <= fecha_fin),
    CONSTRAINT chk_cupo CHECK (cupo_maximo >= 0),

    CONSTRAINT fk_visita_empleado
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)


);

-- Tabla de exposiciones
CREATE TABLE EXPOSICIONES (
    cod_exposicion   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(100) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    tematica           VARCHAR2(100),
    numero_obras       NUMBER,
    tipo_exposicion    VARCHAR2(20),
    cod_sala           NUMBER NOT NULL,
    cod_empleado       NUMBER,

    CONSTRAINT chk_tipo_expo CHECK (tipo_exposicion IN ('Online', 'Física')),
    CONSTRAINT chk_fecha_expo CHECK (fecha_inicio <= fecha_fin),
    CONSTRAINT chk_numero_obras CHECK (numero_obras >= 0),

    CONSTRAINT fk_sala 
        FOREIGN KEY (cod_sala) REFERENCES SALAS(cod_sala),

    CONSTRAINT fk_exposiciones_empleado
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)
);

-- Tabla de obras de arte
CREATE TABLE OBRAS (
    cod_obra           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    fecha_creacion     DATE,
    fecha_adquisicion  DATE DEFAULT SYSDATE,
    tipo               VARCHAR2(50) NOT NULL,
    est_artistico      VARCHAR2(100),
    est_historico      VARCHAR2(100),
    imagen             BLOB,
    cod_sala           NUMBER NOT NULL,
    cod_autor          NUMBER NOT NULL,

    CONSTRAINT chk_tipo_obra CHECK (tipo IN ('Cuadro', 'Escultura', 'Fotografía', 'Alfarería')),
    CONSTRAINT chk_fecha_obra CHECK (fecha_creacion <= fecha_adquisicion),

    CONSTRAINT fk_obras_sala 
        FOREIGN KEY (cod_sala) 
        REFERENCES SALAS(cod_sala),
 
    CONSTRAINT fk_obras_autor
        FOREIGN KEY (cod_autor)
        REFERENCES AUTORES(cod_autor)
);

-- TABLA DE RELACIÓN



-- Rol_Empleado N-M
CREATE TABLE ROLES_EMPLEADOS (
    cod_rol         NUMBER NOT NULL,
    cod_empleado    NUMBER NOT NULL,
    PRIMARY KEY (cod_rol, cod_empleado),
    FOREIGN KEY (cod_rol) REFERENCES ROLES(cod_rol),
    FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)
);
