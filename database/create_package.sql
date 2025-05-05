
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
END create_package;