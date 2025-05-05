CREATE OR REPLACE Type ListaTelefonos AS VARRAY(10) OF VARCHAR2(20);
/

-- Tipo Empleado
CREATE OR REPLACE TYPE TipoEmpleado AS OBJECT (
    cod_empleado       NUMBER,
    nombre             VARCHAR2(100) NOT NULL,
    fechaNacimiento    DATE NOT NULL,
    tlfContacto        VARCHAR2(20) NOT NULL,
    correoElectronico  VARCHAR2(100),
    cod_Contrato        NUMBER NOT NULL,
    cod_departamento   NUMBER NOT NULL
);

-- Tipo Departamento
CREATE OR REPLACE TYPE TipoDepartamento AS OBJECT (
    cod_departamento   NUMBER,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    cod_encargado      NUMBER
);

-- Tipo Rol
CREATE OR REPLACE TYPE TipoRol AS OBJECT (
    cod_rol            NUMBER NOT NULL,
    nombre             VARCHAR2(50) NOT NULL,
    descripcion        VARCHAR2(255)
);

-- Tipo Contrato
CREATE OR REPLACE TYPE TipoContrato AS OBJECT (
    cod_contrato       NUMBER,
    fecha_ini          DATE NOT NULL,
    fecha_fin          DATE DEFAULT NULL,
    sueldo             NUMBER(10, 2) NOT NULL,
    jornada_laboral    VARCHAR2(50) NOT NULL,
    estado             VARCHAR2(20) NOT NULL
);

-- Tipo Venta
CREATE OR REPLACE TYPE TipoVenta AS OBJECT (
    cod_venta          NUMBER,
    fecha              DATE NOT NULL,
    cod_empleado       NUMBER NOT NULL
);

-- Tipo Entrada
CREATE OR REPLACE TYPE TipoEntrada AS OBJECT (
    cod_entrada        NUMBER NOT NULL,
    precio             NUMBER(10, 2) NOT NULL,
    fecha              DATE NOT NULL,
    cod_cliente        NUMBER NOT NULL,
    cod_venta          NUMBER NOT NULL,
    tipo               VARCHAR2(20) NOT NULL
);

-- Tipo Cliente
CREATE OR REPLACE TYPE TipoCliente AS OBJECT (
    cod_cliente      NUMBER,
    nombre             VARCHAR2(100) NOT NULL,
    apellidos          VARCHAR2(100),
    fecha_nacimiento   DATE,
    telefonos          ListaTelefonos NOT NULL,
    email              VARCHAR2(100) NOT NULL,
    cod_entrada        NUMBER
);

-- Tipo Externo
CREATE OR REPLACE TYPE TipoExterno AS OBJECT (
    cod_externo        NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    telefonos          ListaTelefonos NOT NULL, 
    email              VARCHAR2(100),
    cod_actividad      NUMBER NOT NULL
);

-- Tipo Actividad
CREATE OR REPLACE TYPE TipoActividad AS OBJECT (
    cod_actividad   NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    fecha_inicio       DATE NOT NULL,
    fecha_fin          DATE NOT NULL,
    publico            VARCHAR2(100),
    cod_empleado       NUMBER,
    cod_externo        NUMBER
);

-- Tipo visita
CREATE OR REPLACE TYPE TipoVisita UNDER TipoActividad (
    cupo_maximo        NUMBER NOT NULL,
    idioma             VARCHAR2(50),
    tipo               VARCHAR2(20)
);

-- Tipo exposición
CREATE OR REPLACE TYPE TipoExposicion UNDER TipoActividad (
    tematica           VARCHAR2(100),
    numero_obras       NUMBER,
    cod_sala           NUMBER,
    tipo               VARCHAR2(20)
);

-- Tipo sala
CREATE OR REPLACE TYPE TipoSala AS OBJECT (
    cod_sala           NUMBER,
    nombre             VARCHAR2(100) NOT NULL,
    localizacion       VARCHAR2(100),
    descripcion        VARCHAR2(255)
);

-- Tipo Obra de Arte
CREATE OR REPLACE TYPE TipoObra AS OBJECT (
    cod_obra           NUMBER,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    fecha_creacion     DATE,
    fecha_adquisicion  DATE,
    tipo               VARCHAR2(50) NOT NULL,
    est_artistico      VARCHAR2(100),
    est_historico      VARCHAR2(100),
    imagen             BLOB,
    cod_sala           NUMBER NOT NULL,
    cod_autor          NUMBER NOT NULL
);

-- Tipo Autores
CREATE OR REPLACE TYPE TipoAutor AS OBJECT (
    cod_autor          NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    apellidos          VARCHAR2(100) ,
    pais_origen        VARCHAR2(50),
    fecha_nacimiento   DATE,
    fecha_muerte       DATE,
    num_obras          INTEGER DEFAULT 0,
    estilo             VARCHAR2(100)
);
