--Actualizar empleado detallado
create or replace PROCEDURE actualizar_empleado_completo (
    p_cod_empleado     NUMBER,
    p_nombre           VARCHAR2,
    p_apellidos        VARCHAR2,
    p_fecha_nacimiento DATE,
    p_telefono         VARCHAR2,
    p_calle            VARCHAR2,
    p_ciudad           VARCHAR2,
    p_provincia        VARCHAR2,
    p_codigo_postal    VARCHAR2,
    p_email            VARCHAR2,
    p_cod_departamento NUMBER,
    p_cod_rol          NUMBER,
    p_fecha_ini        DATE,
    p_fecha_fin        DATE,
    p_sueldo           NUMBER,
    p_jornada_laboral  VARCHAR2,
    p_estado_contrato  VARCHAR2
)
IS
    v_telefonos    TipoListaTelefonos := TipoListaTelefonos(p_telefono);
    v_cod_contrato CONTRATOS.cod_contrato%TYPE;
BEGIN
    -- Obtener cod_contrato del empleado
    SELECT cod_contrato INTO v_cod_contrato
    FROM EMPLEADOS
    WHERE cod_empleado = p_cod_empleado;

    -- Actualizar contrato
    UPDATE CONTRATOS
    SET fecha_ini        = p_fecha_ini,
        fecha_fin        = p_fecha_fin,
        sueldo           = p_sueldo,
        jornada_laboral  = p_jornada_laboral,
        estado           = p_estado_contrato
    WHERE cod_contrato = v_cod_contrato;

    -- Actualizar empleado
    UPDATE EMPLEADOS
    SET nombre           = TipoNombre(p_nombre, p_apellidos),
        fecha_nacimiento = p_fecha_nacimiento,
        telefonos        = v_telefonos,
        direccion        = TipoDireccion(p_calle, p_ciudad, p_provincia, p_codigo_postal),
        email            = p_email,
        cod_departamento = p_cod_departamento
    WHERE cod_empleado = p_cod_empleado;

    -- Actualizar rol
    UPDATE ROLES_EMPLEADOS
    SET cod_rol = p_cod_rol
    WHERE cod_empleado = p_cod_empleado;

END actualizar_empleado_completo;
/


--Eliminar empleado detallado
create or replace PROCEDURE eliminar_empleado_completo (
    p_cod_empleado NUMBER
)
IS
    v_cod_contrato CONTRATOS.cod_contrato%TYPE;
BEGIN
    -- Obtener cod_contrato del empleado
    SELECT cod_contrato INTO v_cod_contrato
    FROM EMPLEADOS
    WHERE cod_empleado = p_cod_empleado;

    -- Eliminar rol-empleado
    DELETE FROM ROLES_EMPLEADOS
    WHERE cod_empleado = p_cod_empleado;

    -- Eliminar empleado
    DELETE FROM EMPLEADOS
    WHERE cod_empleado = p_cod_empleado;

    -- Eliminar contrato (si aplica)
    DELETE FROM CONTRATOS
    WHERE cod_contrato = v_cod_contrato;
END eliminar_empleado_completo;
/


--insertar empleado detallado
create or replace PROCEDURE insertar_empleado_completo (
    p_nombre           VARCHAR2,
    p_apellidos        VARCHAR2,
    p_fecha_nacimiento DATE,
    p_telefono         VARCHAR2,
    p_calle            VARCHAR2,
    p_ciudad           VARCHAR2,
    p_provincia        VARCHAR2,
    p_codigo_postal    VARCHAR2,
    p_email            VARCHAR2,
    p_cod_departamento NUMBER,
    p_cod_rol          NUMBER,
    p_fecha_ini        DATE,
    p_fecha_fin        DATE,
    p_sueldo           NUMBER,
    p_jornada_laboral  VARCHAR2,
    p_estado_contrato  VARCHAR2
)
IS
    v_cod_contrato CONTRATOS.cod_contrato%TYPE;
    v_cod_empleado EMPLEADOS.cod_empleado%TYPE;
    v_telefonos    TipoListaTelefonos := TipoListaTelefonos(p_telefono);
BEGIN
    -- 1. Insertar contrato
    INSERT INTO CONTRATOS (
        fecha_ini,
        fecha_fin,
        sueldo,
        jornada_laboral,
        estado
    ) VALUES (
        p_fecha_ini,
        p_fecha_fin,
        p_sueldo,
        p_jornada_laboral,
        p_estado_contrato
    )
    RETURNING cod_contrato INTO v_cod_contrato;

    -- 2. Insertar empleado
    INSERT INTO EMPLEADOS (
        nombre,
        fecha_nacimiento,
        telefonos,
        direccion,
        email,
        cod_contrato,
        cod_departamento
    ) VALUES (
        TipoNombre(p_nombre, p_apellidos),
        p_fecha_nacimiento,
        v_telefonos,
        TipoDireccion(p_calle, p_ciudad, p_provincia, p_codigo_postal),
        p_email,
        v_cod_contrato,
        p_cod_departamento
    )
    RETURNING cod_empleado INTO v_cod_empleado;

    -- 3. Insertar en tabla intermedia de roles
    INSERT INTO ROLES_EMPLEADOS (cod_rol, cod_empleado)
    VALUES (p_cod_rol, v_cod_empleado);

END insertar_empleado_completo;
/

--primer_telefono
create or replace FUNCTION primer_telefono(p_telefonos TipoListaTelefonos)
RETURN VARCHAR2 IS
BEGIN
    IF p_telefonos IS NOT NULL AND p_telefonos.COUNT > 0 THEN
        RETURN p_telefonos(1);
    ELSE
        RETURN NULL;
    END IF;
END;
/


--total obras autor
create or replace FUNCTION total_obras_autor(v_autor IN NUMBER) 
RETURN NUMBER 
IS 
    v_total_obras NUMBER;
BEGIN
    SELECT COUNT(*) 
    INTO v_total_obras 
    FROM OBRAS 
    WHERE cod_autor = v_autor;

    RETURN v_total_obras;
END total_obras_autor;
/

