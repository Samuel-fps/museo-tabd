
-- Paquete visitas
CREATE OR REPLACE PACKAGE pkg_informes IS
    FUNCTION calcular_duracion_actividad(id_actividad IN NUMBER) RETURN NUMBER;
    FUNCTION cantidad_visitas_por_mes(mes IN NUMBER, anio IN NUMBER) RETURN NUMBER;
    FUNCTION obtener_disponibilidad_visita(id_visita IN NUMBER) RETURN NUMBER;
END create_package;
/ 

CREATE OR REPLACE PACKAGE BODY pkg_informes AS
  FUNCTION calcular_duracion_actividad(id_actividad IN NUMBER) RETURN NUMBER IS
  BEGIN
    -- Lógica aquí
    RETURN NULL;
  END;

  -- Resto de funciones...

END pkg_informes;
/

-- Paquete ventas
CREATE OR REPLACE PACKAGE pkg_ventas IS
    FUNCTION calcular_precio_entrada(codigo_entrada IN NUMBER) RETURN NUMBER;
    FUNCTION obtener_detalle_venta(codigo_venta IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION obtener_total_ventas_por_mes(mes IN NUMBER, anio IN NUMBER) RETURN NUMBER;
    PROCEDURE registrar_venta (v_cliente IN NUMBER, v_empleado IN NUMBER, v_entrada IN NUMBER);
END create_package;

CREATE OR REPLACE PACKAGE BODY pkg_ventas AS
PROCEDURE registrar_venta (v_cliente IN NUMBER, v_empleado IN NUMBER, v_entrada IN NUMBER) IS v_venta_id NUMBER, v_estado NUMBER;
BEGIN
    -- Comprueba que la entrada esté disponible
    SELECT COUNT(*) INTO v_estado FROM ENTRADAS WHERE cod_entrada = v_entrada AND cod_venta IS NOT NULL;

    IF v_estado > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'La entrada a asignar ya ha sido vendida.');
    END IF;

    -- Inserta la venta
    INSERT INTO VENTA (fecha, cod_empleado) VALUES (SYSDATE, v_empleado) RETURNING cod_venta INTO v_venta_id;

    -- Asignar la entrada a la venta
    UPDATE entradas SET cod_venta = v_venta_id WHERE cod_entrada = v_entrada;

    DBMS_OUTPUT.PUT_LINE('Venta registrada, ID venta: ' || v_venta_id);
END;
/

--Paquete Autor
CREATE OR REPLACE PACKAGE pkg_autor IS
  FUNCTION total_obras_autor(v_autor IN NUMBER) RETURN NUMBER;
END create_package;

CREATE OR REPLACE PACKAGE BODY pkg_autor AS
FUNCTION total_obras_autor(v_autor IN NUMBER) RETURN NUMBER IS v_total_obras NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total_obras FROM Autor a JOIN OBRA_DE_ARTE o ON a.cod_autor = o.cod_autor WHERE v_autor = a.cod_autor;

    RETURN v_total_obras;
END;

--Paquete Visitas
CREATE OR REPLACE PACKAGE pkg_visitas IS
  FUNCTION cantidad_visitas_por_mes(v_mes IN NUMBER, v_anno IN NUMBER) RETURN NUMBER;
END create_package;