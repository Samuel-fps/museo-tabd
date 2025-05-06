-- Tabla de empleados
CREATE TABLE EMPLEADOS OF TipoEmpleado (
    cod_empleado       NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    fechaNacimiento    DATE NOT NULL,
    tlfContacto        ListaTelefonos NOT NULL,
    correoElectronico  VARCHAR2(100),
    cod_Contrato       NUMBER NOT NULL,
    cod_departamento   NUMBER NOT NULL,

    CONSTRAINT pk_empleado 
        PRIMARY KEY (cod_empleado),
    CONSTRAINT fk_contrato 
        FOREIGN KEY (cod_contrato) REFERENCES CONTRATOS(cod_contrato),
    CONSTRAINT fk_departamento 
        FOREIGN KEY (cod_departamento) REFERENCES departamentos(cod_departamento)
);

-- Tabla de departamentos
CREATE TABLE DEPARTAMENTOS OF TipoDepartamento (
    cod_departamento   NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,

    CONSTRAINT pk_departamento 
        PRIMARY KEY (cod_departamento),
     CONSTRAINT fk_encargado
        FOREIGN KEY (cod_encargado) REFERENCES EMPLEADOS(cod_empleado)
);

-- Tabla de roles
CREATE TABLE ROLES OF TipoRol (
    cod_rol            NUMBER NOT NULL,
    nombre             VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_roles 
        PRIMARY KEY (cod_rol)
);

-- Tabla de contratos
CREATE TABLE CONTRATOS OF TipoContrato (
    cod_contrato       NUMBER NOT NULL,
    fecha_ini          DATE NOT NULL,
    fecha_fin          DATE DEFAULT NULL,
    sueldo             NUMBER(10, 2) NOT NULL,
    jornada_laboral    VARCHAR2(50) NOT NULL,
    estado             VARCHAR2(20) NOT NULL

    CONSTRAINT pk_contrato 
        PRIMARY KEY (cod_contrato)
);

-- Tabla de ventas
CREATE TABLE VENTAS OF TipoVenta (
    cod_venta          NUMBER NOT NULL,
    fecha              DATE NOT NULL,
    cod_empleado       NUMBER NOT NULL,

    CONSTRAINT pk_venta
        PRIMARY KEY (cod_venta),
    CONSTRAINT fk_empleado 
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADOS(cod_empleado)
);

-- Tabla de entradas
CREATE TABLE ENTRADAS OF TipoEntrada (
    cod_entrada        NUMBER NOT NULL,
    precio             NUMBER(10, 2) NOT NULL,
    fecha              DATE NOT NULL,
    cod_cliente        NUMBER NOT NULL,
    cod_venta          NUMBER NOT NULL,
    tipo               VARCHAR2(20) NOT NULL

    CONSTRAINT pk_entradas 
        PRIMARY KEY (cod_entrada),
    CONSTRAINT fk_cliente
        FOREIGN KEY (cod_cliente) REFERENCES CLIENTES(cod_cliente),
    CONSTRAINT fk_venta
        FOREIGN KEY (cod_venta) REFERENCES VENTAS(cod_venta),
    CONSTRAINT chk_tipo CHECK (tipo IN ('Física', 'Online'))
);

-- Tabla de clientes
CREATE TABLE CLIENTES OF TipoCliente (
    cod_cliente        NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    apellidos          VARCHAR2(100),
    telefonos          ListaTelefonos NOT NULL,
    email              VARCHAR2(100) NOT NULL,

    CONSTRAINT pk_cliente
        PRIMARY KEY (cod_cliente),
    CONSTRAINT fk_entrada
        FOREIGN KEY (cod_entrada) REFERENCES ENTRADAS(cod_entrada)
);

-- Tabla de externos
CREATE TABLE EXTERNOS OF TipoExterno(
    cod_externo        NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    telefonos          ListaTelefonos NOT NULL, 
    cod_actividad      NUMBER NOT NULL

    CONSTRAINT pk_externo 
        PRIMARY KEY (cod_externo)
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
    cupo_maximo        NUMBER NOT NULL,

    CONSTRAINT tipo CHECK (tipo IN ('Guiada', 'Autoguiada', 'Virtual')),
    CONSTRAINT fk_actividades 
        FOREIGN KEY (cod_actividad) REFERENCES ACTIVIDADES(cod_actividad)
);

-- Tabla de exposiciones
CREATE TABLE EXPOSICIONES OF TipoExposicion (
    cod_sala           NUMBER NOT NULL,

    CONSTRAINT chk_tipo_expo CHECK (tipo IN ('Online', 'Física'))
);

-- Tabla de salas
CREATE TABLE SALAS OF TipoSala (
    cod_sala           NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,

    CONSTRAINT pk_sala 
        PRIMARY KEY (cod_sala)
);

-- Tabla de obras de arte
CREATE TABLE OBRAS OF TipoObra (
    cod_obra           NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    tipo               VARCHAR2(50) NOT NULL,
    cod_sala           NUMBER NOT NULL,
    cod_autor          NUMBER NOT NULL

    CONSTRAINT pk_obra
        PRIMARY KEY (cod_obra),

    CONSTRAINT fk_sala 
        FOREIGN KEY (cod_sala) 
        REFERENCES SALAS(cod_sala),
 
    CONSTRAINT fk_AUTOR 
        FOREIGN KEY (cod_autor)
        REFERENCES AUTORES(cod_autor),

    CONSTRAINT chk_tipo_obra CHECK (tipo IN ('Cuadro', 'Escultura', 'Fotografía', 'Alfarería'))

);

-- Tabla de autores
CREATE TABLE AUTORES OF TipoAutor (
    cod_autor          NUMBER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    num_obras          INTEGER DEFAULT 0,

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


-- Actividad_Externo N-M
CREATE TABLE ACTIVIDADES_EXTERNOS (
    cod_actividad   NUMBER NOT NULL,
    cod_externo     NUMBER NOT NULL,
    fecha           DATE DEFAULT SYSDATE,
    horas           NUMBER,
    descripcion     VARCHAR2(255),
    PRIMARY KEY (cod_actividad, cod_externo),
    FOREIGN KEY (cod_actividad) REFERENCES ACTIVIDADES(cod_actividad),
    FOREIGN KEY (cod_externo) REFERENCES EXTERNOS(cod_externo)
);






























-- Funciones

-- Devuelve el número de plazas disponibles para una visita guiada.
CREATE OR REPLACE PROCEDURE obtener_disponibilidad_visita (
    p_id_visita IN VISITA.cod_actividad%TYPE
)
IS
    v_maximo NUMBER;
BEGIN
    SELECT cupo_maximo INTO v_maximo
    FROM VISITA
    WHERE cod_actividad = p_id_visita;

    DBMS_OUTPUT.PUT_LINE('Cupos disponibles para la visita ' || p_id_visita || ': ' || v_maximo);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('La visita con ID ' || p_id_visita || ' no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al obtener la disponibilidad: ' || SQLERRM);
END;
/



-- Devuelve el número total de visitas guiadas en un mes.
CREATE OR REPLACE PROCEDURE cantidad_visitas_mes (
    p_mes IN NUMBER,
    p_anio IN NUMBER
)
IS
    total_visitas NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO total_visitas
    FROM VISITA V
    JOIN ACTIVIDADES A ON V.cod_actividad = A.cod_actividad
    WHERE EXTRACT(MONTH FROM A.fecha_inicio) = p_mes
      AND EXTRACT(YEAR FROM A.fecha_inicio) = p_anio;

    DBMS_OUTPUT.PUT_LINE('Cantidad de visitas en ' || p_mes || '/' || p_anio || ': ' || total_visitas);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al calcular las visitas: ' || SQLERRM);
END;
/






-- Procedimientos

-- Actualiza el precio de una entrada.
CREATE OR REPLACE PROCEDURE total_entradas_vendidas_por_fecha (
    fecha_ini IN DATE,
    fecha_fin IN DATE
)
IS
    total_entradas NUMBER;
BEGIN
    SELECT COUNT(*) INTO total_entradas
    FROM ENTRADAS
    WHERE fecha BETWEEN fecha_ini AND fecha_fin;

    DBMS_OUTPUT.PUT_LINE('Total de entradas vendidas entre ' || TO_CHAR(fecha_ini, 'DD-MM-YYYY') ||
                         ' y ' || TO_CHAR(fecha_fin, 'DD-MM-YYYY') || ': ' || total_entradas);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al calcular las entradas: ' || SQLERRM);
END;
/

-- Asigna un empleado a una actividad.
CREATE OR REPLACE PROCEDURE asignar_empleado_a_actividad (
    id_actividad IN ACTIVIDADES.cod_actividad%TYPE,
    id_empleado IN EMPLEADO.cod_empleado%TYPE
)
IS
    v_exists NUMBER;
BEGIN
    -- Verificar si la actividad existe
    SELECT COUNT(*) INTO v_exists
    FROM ACTIVIDADES
    WHERE cod_actividad = id_actividad;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La actividad no existe.');
        RETURN;
    END IF;

    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO v_exists
    FROM EMPLEADO
    WHERE cod_empleado = id_empleado;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El empleado no existe.');
        RETURN;
    END IF;

    -- Actualizar la actividad con el nuevo empleado
    UPDATE ACTIVIDADES
    SET cod_empleado = id_empleado
    WHERE cod_actividad = id_actividad;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Empleado asignado correctamente a la actividad.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al asignar el empleado: ' || SQLERRM);
END;
/
