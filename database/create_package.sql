
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

  CREATE OR REPLACE FUNCTION total_obras_autor(v_autor IN NUMBER) 
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
          SET estado = 'Inactivo'
          WHERE fecha_fin IS NOT NULL;
      END;
  END actualizar_estado_contratos;

END pkg_contrato;
/

-- Paquete Empleados
CREATE OR REPLACE PACKAGE pkg_empleados IS

  PROCEDURE actualizar_estado_empleado(v_cod_empleado IN NUMBER, v_estado IN VARCHAR2);
  PROCEDURE asignar_empleado_visita;

END pkg_empleados;
/

-- Cuerpo del paquete Empleados
CREATE OR REPLACE PACKAGE BODY pkg_empleados AS

  PROCEDURE asignar_empleado_visita (
    p_cod_visita IN ACTIVIDADES.cod_visita%TYPE,
    p_id_empleado IN EMPLEADO.cod_empleado%TYPE
  )
  IS
      v_exists NUMBER;
  BEGIN
      -- Verificar si la visita existe
      SELECT COUNT(*) INTO v_exists
      FROM VISITAS
      WHERE cod_visita = p_cod_visita;

      IF v_exists = 0 THEN
          RAISE_APPLICATION_ERROR(-20001, 'La visita no existe.');
      END IF;

      -- Verificar si el empleado existe
      SELECT COUNT(*) INTO v_exists
      FROM EMPLEADOS
      WHERE cod_empleado = p_cod_empleado;

      IF v_exists = 0 THEN
          RAISE_APPLICATION_ERROR(-20002, 'El empleado no existe.');
      END IF;

      -- Asignar el empleado a la actividad
      UPDATE VISITAS
      SET cod_empleado = p_cod_empleado
      WHERE cod_visita = p_cod_visita;

      COMMIT;

  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK;
          RAISE_APPLICATION_ERROR(-20003, 'Error al asignar el empleado: ' || SQLERRM);
  END;
  /


END pkg_empleados;

-- Paquete Obras
CREATE OR REPLACE PACKAGE pkg_obras IS

  FUNCTION registrar_obra (
        p_nombre            VARCHAR2,
        p_descripcion       VARCHAR2,
        p_fecha_creacion    DATE,
        p_fecha_adquisicion DATE,
        p_tipo              VARCHAR2,
        p_est_artistico     VARCHAR2,
        p_est_historico     VARCHAR2,
        p_imagen            BLOB,
        p_cod_sala          NUMBER,
        p_cod_autor         NUMBER
    ) RETURN NUMBER;
  FUNCTION total_obras_por_autor(v_autor IN NUMBER) RETURN NUMBER;
  PROCEDURE cambiar_obra_sala(v_obra IN NUMBER, v_sala IN NUMBER);

END pkg_obras;

-- Cuerpo del paquete Obras
CREATE OR REPLACE PACKAGE BODY pkg_obras AS

  -- Registra una nueva obra
  CREATE OR REPLACE FUNCTION registrar_obra (
    p_nombre            IN OBRAS.nombre%TYPE,
    p_descripcion       IN OBRAS.descripcion%TYPE,
    p_fecha_creacion    IN OBRAS.fecha_creacion%TYPE,
    p_fecha_adquisicion IN OBRAS.fecha_adquisicion%TYPE DEFAULT SYSDATE,
    p_tipo              IN OBRAS.tipo%TYPE,
    p_est_artistico     IN OBRAS.est_artistico%TYPE,
    p_est_historico     IN OBRAS.est_historico%TYPE,
    p_imagen            IN OBRAS.imagen%TYPE,
    p_cod_sala          IN OBRAS.cod_sala%TYPE,
    p_cod_autor         IN OBRAS.cod_autor%TYPE
  ) RETURN NUMBER
  IS
      v_cod_obra NUMBER;
      v_exists   NUMBER;
  BEGIN
      -- Verificar que la sala existe
      SELECT COUNT(*) INTO v_exists
      FROM SALAS
      WHERE cod_sala = p_cod_sala;

      IF v_exists = 0 THEN
          RAISE_APPLICATION_ERROR(-20001, 'La sala especificada no existe.');
      END IF;

      -- Verificar que el autor existe
      SELECT COUNT(*) INTO v_exists
      FROM AUTORES
      WHERE cod_autor = p_cod_autor;

      IF v_exists = 0 THEN
          RAISE_APPLICATION_ERROR(-20002, 'El autor especificado no existe.');
      END IF;
  END registrar_obra;

  -- Cambiar una obra de sala
  PROCEDURE cambiar_obra_sala(v_obra IN NUMBER, v_sala IN NUMBER) IS
      v_sala_actual NUMBER;
  BEGIN
      -- Obtener la sala actual de la obra
      SELECT sala INTO v_sala_actual FROM OBRAS WHERE cod_obra = v_obra;

      -- Si es distinta a la actual
      IF v_sala_actual != v_sala THEN
          UPDATE OBRAS SET sala = v_sala WHERE cod_obra = v_obra;
          COMMIT;
      ELSE
          DBMS_OUTPUT.PUT_LINE('La obra ya está en la sala especificada.');
      END IF;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('No se encontró la obra.');
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error al cambiar la sala de la obra: ' || SQLERRM);
  END cambiar_obra_sala;

END pkg_obras;