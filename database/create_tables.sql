-- Tabla de empleados
CREATE TABLE EMPLEADOS (
    cod_empleado       NUMBER NOT NULL,
    nombre             TipoNombre NOT NULL,
    fecha_nacimiento    DATE,
    telefonos           TipoListaTelefonos,
    Direccion           TipoDireccion,
    email               VARCHAR2(100) NOT NULL,
    cod_contrato       NUMBER NOT NULL,
    cod_departamento   NUMBER NOT NULL,

    CONSTRAINT pk_empleado 
        PRIMARY KEY (cod_empleado),
    CONSTRAINT fk_contrato 
        FOREIGN KEY (cod_contrato) REFERENCES CONTRATOS(cod_contrato),
    CONSTRAINT fk_departamento 
        FOREIGN KEY (cod_departamento) REFERENCES departamentos(cod_departamento)
);

-- Tabla de departamentos
CREATE TABLE DEPARTAMENTOS (
    cod_departamento   NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    cod_encargado      NUMBER,

    CONSTRAINT pk_departamento 
        PRIMARY KEY (cod_departamento),
     CONSTRAINT fk_encargado
        FOREIGN KEY (cod_encargado) REFERENCES EMPLEADOS(cod_empleado)
);

-- Tabla de roles
CREATE TABLE ROLES (
    cod_rol            NUMBER NOT NULL,
    nombre             VARCHAR2(50) NOT NULL,
    descripcion        VARCHAR2(255),

    CONSTRAINT pk_roles 
        PRIMARY KEY (cod_rol)
);

-- Tabla de contratos
CREATE TABLE CONTRATOS (
    cod_contrato       NUMBER NOT NULL,
    fecha_ini          DATE NOT NULL,
    fecha_fin          DATE DEFAULT NULL,
    sueldo             NUMBER(10, 2) NOT NULL,
    jornada_laboral    VARCHAR2(50) NOT NULL,
    estado             VARCHAR2(20) NOT NULL,

    CONSTRAINT pk_contrato 
        PRIMARY KEY (cod_contrato)
);

-- Tabla de ventas
CREATE TABLE VENTAS (
    cod_venta          NUMBER NOT NULL,
    fecha              DATE NOT NULL DEFAULT SYSDATE,
    cod_empleado       NUMBER NOT NULL,

    CONSTRAINT chk_fecha CHECK (fecha >= TRUNC(SYSDATE)),

    CONSTRAINT pk_venta
        PRIMARY KEY (cod_venta),
    CONSTRAINT fk_empleado 
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)
);

-- Tabla de entradas
CREATE TABLE ENTRADAS (
    cod_entrada        NUMBER NOT NULL,
    precio             NUMBER(7, 2) NOT NULL,
    fecha              DATE NOT NULL,
    tipo               VARCHAR2(20) NOT NULL,
    cod_cliente        NUMBER NOT NULL,
    cod_venta          NUMBER NOT NULL,
    
    CONSTRAINT chk_tipo CHECK (tipo IN ('Física', 'Online')),
    CONSTRAINT chk_precio CHECK (precio > 0),
    CONSTRAINT chk_fecha CHECK (fecha >= TRUNC(SYSDATE)),

    CONSTRAINT pk_entradas 
        PRIMARY KEY (cod_entrada),
    CONSTRAINT fk_cliente
        FOREIGN KEY (cod_cliente) REFERENCES CLIENTES(cod_cliente),
    CONSTRAINT fk_venta
        FOREIGN KEY (cod_venta) REFERENCES VENTAS(cod_venta),
);

-- Tabla de clientes
CREATE TABLE CLIENTES (
    cod_cliente        NUMBER NOT NULL,
    nombre             TipoNombre NOT NULL,
    fecha_nacimiento   DATE,
    apellidos          VARCHAR2(100),
    telefonos          ListaTelefonos NOT NULL,
    email              VARCHAR2(100) NOT NULL,

    CONSTRAINT chk_fecha CHECK (fecha_nacimiento <= TRUNC(SYSDATE)),
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_telefono CHECK (telefonos IS NOT NULL),

    CONSTRAINT pk_cliente
        PRIMARY KEY (cod_cliente),
);

-- Tabla de actividades
CREATE TABLE ACTIVIDADES OF TipoActividad (
    cod_actividad   NUMBER NOT NULL,
    nombre          VARCHAR2(100) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,

    CONSTRAINT pk_actividad 
        PRIMARY KEY (cod_actividad)
);

-- Tabla de visitas
CREATE TABLE VISITAS OF TipoVisita (
    cod_actividad   NUMBER NOT NULL,
    nombre          VARCHAR2(100) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    cupo_maximo        NUMBER,
    idioma             VARCHAR2(50),
    tipo_visita               VARCHAR2(20),
    cod_entrada        NUMBER NOT NULL,

    CONSTRAINT tipo CHECK (tipo_visita IN ('Guiada', 'Autoguiada', 'Virtual')),
    CONSTRAINT chk_fecha_visita CHECK (fecha_inicio <= fecha_fin),
    CONSTRAINT chk_cupo CHECK (cupo_maximo >= 0),

    CONSTRAINT pk_visita 
        PRIMARY KEY (cod_actividad),
    CONSTRAINT fk_cliente
        FOREIGN KEY (cod_entrada) REFERENCES CLIENTES(cod_entrada),
);

-- Tabla de exposiciones
CREATE TABLE EXPOSICIONES OF TipoExposicion (
    cod_actividad   NUMBER NOT NULL,
    nombre          VARCHAR2(100) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    tematica           VARCHAR2(100),
    numero_obras       NUMBER,
    tipo_exposicion    VARCHAR2(20),
    cod_sala           NUMBER NOT NULL,

    CONSTRAINT chk_tipo_expo CHECK (tipo_exposicion IN ('Online', 'Física')),
    CONSTRAINT chk_fecha_expo CHECK (fecha_inicio <= fecha_fin),
    CONSTRAINT chk_numero_obras CHECK (numero_obras >= 0),

    CONSTRAINT pk_exposicion 
        PRIMARY KEY (cod_actividad),
    CONSTRAINT fk_sala 
        FOREIGN KEY (cod_sala) REFERENCES SALAS(cod_sala),
);

-- Tabla de salas
CREATE TABLE SALAS (
    cod_sala           NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(255),
    localizacion       VARCHAR2(100),

    CONSTRAINT pk_sala 
        PRIMARY KEY (cod_sala)
);

-- Tabla de obras de arte
CREATE TABLE OBRAS (
    cod_obra           NUMBER NOT NULL,
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
    CONSTRAINT chk_fecha_creacion CHECK (fecha_creacion <= TRUNC(SYSDATE)),
    CONSTRAINT chk_fecha_adquisicion CHECK (fecha_adquisicion <= TRUNC(SYSDATE)),
    CONSTRAINT chk_fecha CHECK (fecha_creacion <= fecha_adquisicion),

    CONSTRAINT pk_obra
        PRIMARY KEY (cod_obra),

    CONSTRAINT fk_sala 
        FOREIGN KEY (cod_sala) 
        REFERENCES SALAS(cod_sala),
 
    CONSTRAINT fk_AUTOR 
        FOREIGN KEY (cod_autor)
        REFERENCES AUTORES(cod_autor)
);

-- Tabla de autores
CREATE TABLE AUTORES(
    cod_autor          NUMBER NOT NULL,
    nombre             TipoNombre NOT NULL,
    pais_origen        VARCHAR2(50),
    fecha_nacimiento   DATE,
    fecha_muerte       DATE,
    num_obras          INTEGER DEFAULT 0,
    estilo             VARCHAR2(100),

    CONSTRAINT pk_autor 
        PRIMARY KEY (cod_autor)
);

-- TABLA DE RELACIÓN

-- Empleado_Actividad N-M
CREATE TABLE EMPLEADOS_ACTIVIDADES (
    cod_empleado    NUMBER NOT NULL,
    cod_actividad   NUMBER  NOT NULL,
    fecha_asignacion DATE DEFAULT SYSDATE,
    
    PRIMARY KEY (cod_empleado, cod_actividad),
    FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado),
    FOREIGN KEY (cod_actividad) REFERENCES ACTIVIDADES(cod_actividad)
);

-- Sala_Actividad N-M
CREATE TABLE SALAS_EXPOSICIONES (
    cod_sala        NUMBER NOT NULL,
    cod_actividad   NUMBER NOT NULL,
    PRIMARY KEY (cod_sala, cod_actividad),
    FOREIGN KEY (cod_sala) REFERENCES SALAS(cod_sala),
    FOREIGN KEY (cod_actividad) REFERENCES EXPOSICIONES(cod_actividad)
);

-- Rol_Empleado N-M
CREATE TABLE ROLES_EMPLEADOS (
    cod_rol         NUMBER NOT NULL,
    cod_empleado    NUMBER NOT NULL,
    PRIMARY KEY (cod_rol, cod_empleado),
    FOREIGN KEY (cod_rol) REFERENCES ROLES(cod_rol),
    FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)
);
