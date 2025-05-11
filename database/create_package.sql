
-- Paquete ventas
CREATE OR REPLACE PACKAGE pkg_ventas IS
    PROCEDURE registrar_venta (v_cliente IN NUMBER, v_empleado IN NUMBER, v_entrada IN NUMBER);
END create_package;

-- Cuerpo del paquete ventas
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
END pkg_ventas;

--Paquete Autor
CREATE OR REPLACE PACKAGE pkg_autor IS
  FUNCTION total_obras_autor(v_autor IN NUMBER) RETURN NUMBER;
END create_package;

-- Cuerpo del paquete Autor
CREATE OR REPLACE PACKAGE BODY pkg_autor AS
  FUNCTION total_obras_autor(v_autor IN NUMBER) RETURN NUMBER IS v_total_obras NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_total_obras FROM Autor a JOIN OBRA_DE_ARTE o ON a.cod_autor = o.cod_autor WHERE v_autor = a.cod_autor;

      RETURN v_total_obras;
END;
END pkg_autor;


--Paquete Visitas
CREATE OR REPLACE PACKAGE pkg_visitas IS
  FUNCTION cantidad_visitas_por_mes(v_mes IN NUMBER, v_anno IN NUMBER) RETURN NUMBER;
END create_package;

-- Cuerpo del paquete Visitas
CREATE OR REPLACE PACKAGE BODY pkg_visitas AS
CREATE OR REPLACE FUNCTION cantidad_visitas_por_mes(v_mes IN NUMBER, v_anno IN NUMBER) RETURN NUMBER IS v_total_visitas NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total_visitas FROM VISITA v JOIN ACTIVIDADES a ON v.cod_actividad = a.cod_actividad WHERE v.tipo = 'Guiada'
    AND EXTRACT (MONTH FROM a.fecha_inicio) = v_mes;
    AND EXTRACT (YEAR FROM a.fecha_inicio) = v_anno;

    RETURN v_total_visitas;
END;
END pkg_visitas;

-- Paquete Entradas
CREATE OR REPLACE PACKAGE pkg_entradas IS
  PROCEDURE total_entradas_vendidas_por_fecha(v_fecha IN DATE, v_total OUT NUMBER);
END create_package;

-- Cuerpo del paquete Entradas
CREATE OR REPLACE PACKAGE BODY pkg_entradas AS

    -- Devuelve el numer de entradas vendidas en un periodo de tiempo.
  CREATE OR REPLACE FUNCTION total_entradas_vendidas_por_fecha (
      fecha_ini IN DATE,
      fecha_fin IN DATE
  ) IS total_entradas NUMBER;
  BEGIN
      SELECT COUNT(*) INTO total_entradas
      FROM ENTRADAS
      WHERE fecha BETWEEN fecha_ini AND fecha_fin;

      RETURN total_entradas;
  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error al calcular las entradas: ' || SQLERRM);
  END;
  /


END pkg_entradas;

--Paquete Contrato
CREATE OR REPLACE PACKAGE pkg_contrato IS
PROCEDURE actualizar_estado_contratos;
END create_package;

-- Cuerpo del paquete Contrato
CREATE OR REPLACE PACKAGE BODY pkg_contrato AS
PROCEDURE actualizar_estado_contratos AS
    BEGIN
        UPDATE CONTRATO
        SET estado = 'Inactivo';
        WHERE fecha_fin IS NOT NULL;
    END;
END;
END pkg_contrato;