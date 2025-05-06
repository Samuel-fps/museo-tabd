-- Tipo de lista de numeros de teléfono
CREATE OR REPLACE Type TipoListaTelefonos AS VARRAY(10) OF VARCHAR2(20);

-- Tipo dirección
CREATE OR REPLACE Type TipoDireccion AS OBJECT (
    calle              VARCHAR2(100),
    ciudad             VARCHAR2(50),
    provincia          VARCHAR2(50),
    codigo_postal      VARCHAR2(10)
);

-- Tipo Nombre
CREATE OR REPLACE Type TipoNombre AS OBJECT (
    nombre             VARCHAR2(50),
    apellidos          VARCHAR2(100)
);

-- TIPOS POR CAMBIAR
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
) NOT FINAL;

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
