
-- Paquete ventas
CREATE OR REPLACE PACKAGE pkg_ventas IS

    PROCEDURE registrar_venta (v_cliente IN NUMBER, v_empleado IN NUMBER, v_entrada IN NUMBER);
    FUNCTION entradas_vendidas_mes(p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER;

END pkg_ventas;

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

  -- Devulve el número de entradas vendidas en un mes y año específicos
  CREATE OR REPLACE FUNCTION entradas_vendidas_mes(p_mes IN NUMBER, p_anio IN NUMBER) 
  RETURN NUMBER IS
    v_num_entradas NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_num_entradas FROM ENTRADAS
    WHERE EXTRACT(MONTH FROM fecha) = p_mes
    AND EXTRACT(YEAR FROM fecha) = p_anio;
        
    RETURN v_num_entradas;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
  END entradas_vendidas_mes;

END pkg_ventas;

-- Paquete Autor
CREATE OR REPLACE PACKAGE pkg_autor IS

  FUNCTION total_obras_autor(v_autor IN NUMBER) RETURN NUMBER;

END pkg_autor;

-- Cuerpo del paquete Autor
CREATE OR REPLACE PACKAGE BODY pkg_autor AS

  FUNCTION total_obras_autor(v_autor IN NUMBER) RETURN NUMBER IS v_total_obras NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_total_obras FROM Autor a JOIN OBRA_DE_ARTE o ON a.cod_autor = o.cod_autor WHERE v_autor = a.cod_autor;

      RETURN v_total_obras;
  END total_obras_autor;

END pkg_autor;


-- Paquete Visitas
CREATE OR REPLACE PACKAGE pkg_visitas IS

  FUNCTION cantidad_visitas_mes(v_mes IN NUMBER, v_anno IN NUMBER) RETURN NUMBER;
  FUNCTION cantidad_plazas_disponibles(cod_visita IN NUMBER) RETURN NUMBER;

END pkg_visitas;

-- Cuerpo del paquete Visitas
CREATE OR REPLACE PACKAGE BODY pkg_visitas AS

  -- Devuelve el número de plazas disponibles para una visita
  CREATE OR REPLACE FUNCTION cantidad_plazas_disponibles(cod_visita IN NUMBER) 
  RETURN NUMBER 
  IS
      v_cupo_maximo    NUMBER;
      entradas_reservadas NUMBER;
      plazas_disponibles NUMBER;
  BEGIN
      -- Obtener el cupo máximo de la visita
      SELECT cupo_maximo INTO v_cupo_maximo
      FROM VISITAS WHERE cod_visita = cod_visita;

      -- Calcular el número de entradas reservadas para la visita
      SELECT COUNT(*) INTO entradas_reservadas
      FROM ENTRADAS WHERE cod_visita = cod_visita;

      -- Calcular las plazas disponibles
      plazas_disponibles := cupo_maximo - entradas_reservadas;

      RETURN plazas_disponibles;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RETURN -1; -- No se encontró la visita
      WHEN OTHERS THEN
          RETURN NULL;
  END obtener_plazas_disponibles;
  /

END pkg_visitas;

-- Paquete Entradas
CREATE OR REPLACE PACKAGE pkg_entradas IS

  PROCEDURE total_entradas_vendidas_por_fecha(v_fecha IN DATE, v_total OUT NUMBER);

END pkg_entradas;

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

END pkg_contrato;

  -- Cuerpo del paquete Contrato
CREATE OR REPLACE PACKAGE BODY pkg_contrato AS

  PROCEDURE actualizar_estado_contratos AS
      BEGIN
          UPDATE CONTRATO
          SET estado = 'Inactivo';
          WHERE fecha_fin IS NOT NULL;
      END;
  END actualizar_estado_contratos;

END pkg_contrato;
