CREATE OR REPLACE Type TipoListaTelefonos AS VARRAY(10) OF VARCHAR2(20);
CREATE OR REPLACE Type TipoDireccion AS OBJECT (
    calle              VARCHAR2(100),
    ciudad             VARCHAR2(50),
    provincia          VARCHAR2(50),
    codigo_postal      VARCHAR2(10)
);

-- Tipo Empleado
CREATE OR REPLACE TYPE TipoEmpleado AS OBJECT (
    cod_empleado       NUMBER,
    nombre             VARCHAR2(100),
    fechaNacimiento    DATE,
    tlfContacto        TipoListaTelefonos,
    correoElectronico  VARCHAR2(100),
    Direccion
    cod_Contrato        NUMBER,
    cod_departamento   NUMBER
);

-- Tipo Departamento
CREATE OR REPLACE TYPE TipoDepartamento AS OBJECT (
    cod_departamento   NUMBER,
    nombre             VARCHAR2(100),
    descripcion        VARCHAR2(500),
    cod_encargado      NUMBER
);

-- Tipo Rol
CREATE OR REPLACE TYPE TipoRol AS OBJECT (
    cod_rol            NUMBER,
    nombre             VARCHAR2(50),
    descripcion        VARCHAR2(255)
);

-- Tipo Contrato
CREATE OR REPLACE TYPE TipoContrato AS OBJECT (
    cod_contrato       NUMBER,
    fecha_ini          DATE,
    fecha_fin          DATE,
    sueldo             NUMBER(10, 2),
    jornada_laboral    VARCHAR2(50),
    estado             VARCHAR2(20)
);

-- Tipo Venta
CREATE OR REPLACE TYPE TipoVenta AS OBJECT (
    cod_venta          NUMBER,
    fecha              DATE,
    cod_empleado       NUMBER
);

-- Tipo Entrada
CREATE OR REPLACE TYPE TipoEntrada AS OBJECT (
    cod_entrada        NUMBER,
    precio             NUMBER(10, 2),
    fecha              DATE,
    cod_cliente        NUMBER,
    cod_venta          NUMBER,
    tipo               VARCHAR2(20)
);

-- Tipo Cliente
CREATE OR REPLACE TYPE TipoCliente AS OBJECT (
    cod_cliente        NUMBER,
    nombre             VARCHAR2(100),
    apellidos          VARCHAR2(100),
    fecha_nacimiento   DATE,
    telefonos          TipoListaTelefonos,
    email              VARCHAR2(100),
    cod_entrada        NUMBER
);

-- Tipo Externo
CREATE OR REPLACE TYPE TipoExterno AS OBJECT (
    cod_externo        NUMBER,
    nombre             VARCHAR2(100),
    telefonos          TipoListaTelefonos, 
    email              VARCHAR2(100),
    cod_actividad      NUMBER
);

-- Tipo Actividad
CREATE OR REPLACE TYPE TipoActividad AS OBJECT (
    cod_actividad   NUMBER,
    nombre             VARCHAR2(100),
    descripcion        VARCHAR2(500),
    fecha_inicio       DATE,
    fecha_fin          DATE,
    publico            VARCHAR2(100),
    cod_empleado       NUMBER,
    cod_externo        NUMBER
);

-- Tipo visita
CREATE OR REPLACE TYPE TipoVisita UNDER TipoActividad (
    cupo_maximo        NUMBER,
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
    nombre             VARCHAR2(100),
    localizacion       VARCHAR2(100),
    descripcion        VARCHAR2(255)
);

-- Tipo Obra de Arte
CREATE OR REPLACE TYPE TipoObra AS OBJECT (
    cod_obra           NUMBER,
    nombre             VARCHAR2(100),
    descripcion        VARCHAR2(500),
    fecha_creacion     DATE,
    fecha_adquisicion  DATE,
    tipo               VARCHAR2(50),
    est_artistico      VARCHAR2(100),
    est_historico      VARCHAR2(100),
    imagen             BLOB,
    cod_sala           NUMBER,
    cod_autor          NUMBER
);

-- Tipo Autores
CREATE OR REPLACE TYPE TipoAutor AS OBJECT (
    cod_autor          NUMBER,
    nombre             VARCHAR2(100),
    apellidos          VARCHAR2(100) ,
    pais_origen        VARCHAR2(50),
    fecha_nacimiento   DATE,
    fecha_muerte       DATE,
    num_obras          INTEGER,
    estilo             VARCHAR2(100)
);
