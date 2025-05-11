--Vista empleados de forma detallada
CREATE OR REPLACE VIEW VISTA_EMPLEADOS_DETALLADA AS
SELECT 
    e.cod_empleado,
    e.nombre.nombre || ' ' || e.nombre.apellidos AS nombre_completo,
    e.fecha_nacimiento,
    e.telefonos,
    e.direccion.calle AS calle,
    e.direccion.ciudad AS ciudad,
    e.direccion.provincia AS provincia,
    e.direccion.codigo_postal AS codigo_postal,
    e.email,
    d.nombre AS nombre_departamento,
    c.estado AS estado_contrato,
    c.jornada_laboral,
    c.sueldo,
    c.fecha_ini,
    c.fecha_fin,
    r.nombre AS rol
FROM EMPLEADOS e
JOIN DEPARTAMENTOS d ON e.cod_departamento = d.cod_departamento
JOIN CONTRATOS c ON e.cod_contrato = c.cod_contrato
LEFT JOIN ROLES_EMPLEADOS re ON e.cod_empleado = re.cod_empleado
LEFT JOIN ROLES r ON re.cod_rol = r.cod_rol;
