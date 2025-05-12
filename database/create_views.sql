--Vista empleados de forma detallada
CREATE OR REPLACE VIEW VISTA_EMPLEADOS_DETALLADA AS
SELECT 
    e.cod_empleado,
    e.nombre.nombre AS nombre,
    e.nombre.apellidos AS apellidos,
    e.fecha_nacimiento,
    e.telefonos,
    e.direccion.calle AS calle,
    e.direccion.ciudad AS ciudad,
    e.direccion.provincia AS provincia,
    e.direccion.codigo_postal AS codigo_postal,
    e.email,
    d.cod_departamento AS departamento,
    c.estado AS estado_contrato,
    c.jornada_laboral,
    c.sueldo,
    c.fecha_ini,
    c.fecha_fin,
    r.cod_rol AS rol
FROM EMPLEADOS e
JOIN DEPARTAMENTOS d ON e.cod_departamento = d.cod_departamento
JOIN CONTRATOS c ON e.cod_contrato = c.cod_contrato
LEFT JOIN ROLES_EMPLEADOS re ON e.cod_empleado = re.cod_empleado
LEFT JOIN ROLES r ON re.cod_rol = r.cod_rol;


--Vista autores detallada
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "AUTORES_DETALLADA" ("COD_AUTOR", "NOMBRE", "APELLIDOS", "PAIS_ORIGEN", "FECHA_NACIMIENTO", "FECHA_MUERTE", "NUM_OBRAS", "ESTILO") AS 
  SELECT
    a.cod_autor,
    a.nombre.nombre AS nombre,
    a.nombre.apellidos AS apellidos,
    a.pais_origen,
    a.fecha_nacimiento,
    a.fecha_muerte,
    total_obras_autor(a.cod_autor) AS num_obras,
    a.estilo
FROM AUTORES a;