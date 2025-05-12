--trigger check visitas
create or replace TRIGGER trg_check_visita_cupo
BEFORE INSERT ON ENTRADAS
FOR EACH ROW
WHEN (NEW.cod_visita IS NOT NULL)
DECLARE
    v_total_entradas NUMBER;
    v_cupo_maximo    NUMBER;
BEGIN
    -- Obtener el número de entradas ya registradas para la visita
    SELECT COUNT(*) INTO v_total_entradas
    FROM ENTRADAS
    WHERE cod_visita = :NEW.cod_visita;

    -- Obtener el cupo máximo permitido de la visita
    SELECT cupo_maximo INTO v_cupo_maximo
    FROM VISITAS
    WHERE cod_visita = :NEW.cod_visita;

    -- Verificar si se supera el cupo
    IF v_total_entradas >= v_cupo_maximo THEN
        RAISE_APPLICATION_ERROR(-20005, 'No se pueden asignar más entradas: la visita ha alcanzado su cupo máximo.');
    END IF;
END;
/


--registrar venta
create or replace TRIGGER trg_registrar_venta
BEFORE INSERT ON ENTRADAS
FOR EACH ROW
DECLARE
    v_cod_venta VENTAS.cod_venta%TYPE;
BEGIN
    -- Registrar la fecha actual para la entrada
    :NEW.fecha := SYSDATE;

    -- Solo registrar venta si no se proporciona un cod_venta
    IF :NEW.cod_venta IS NULL THEN
        -- Validación: si la entrada es física, debe tener empleado asignado
        IF :NEW.tipo = 'Física' AND :NEW.cod_empleado IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Las entradas físicas deben tener un empleado asignado.');
        END IF;

        -- Crear la venta
        INSERT INTO VENTAS (fecha, cod_empleado)
        VALUES (SYSDATE, :NEW.cod_empleado)
        RETURNING cod_venta INTO v_cod_venta;

        -- Asignar venta a la entrada (modificando la fila que se insertará)
        :NEW.cod_venta := v_cod_venta;
    END IF;
END;
/


-- Archivo donde se contienen los triggers de la base de datos

-- Eliminar los triggers si ya existen antes de crearlos para evitar errores
BEGIN
    FOR trigger_record IN (SELECT trigger_name FROM user_triggers WHERE trigger_name IN ('TRG_BORRAR_ACTIVIDAD', 'NO_BORRAR_AUTOR_CON_OBRAS', 'TRG_UPDATE_NUM_OBRAS', 'TRG_INSERTAR_NUM_OBRAS', 'TRG_ACTUALIZAR_NUM_OBRAS', 'TRG_ELIMINAR_OBRA')) LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || trigger_record.trigger_name;
    END LOOP;
END;
/

-- Ahora, puedes volver a crear los triggers aquí

-- GENERAL

-- ACTIVIDADES

-- Trigger para no borrar una actividad si hay una visita o exposición activa
CREATE OR REPLACE TRIGGER trg_borrar_actividad
BEFORE DELETE ON VISITAS FOR EACH ROW
DECLARE
    v_visitas NUMBER; --GUARDARÁN EL NÚMERO DE VISITAS Y EXPOSICIONES
    v_exposicion NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_visitas FROM VISITAS WHERE cod_visita = :OLD.cod_visita;

    IF v_visitas > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'No se puede borrar la actividad porque hay una visita activa');
    END IF;

END;
/

-- AUTORES

-- Trigger para evitar eliminar autores que tengan obras registradas
CREATE OR REPLACE TRIGGER no_borrar_autor_con_obras
BEFORE DELETE ON AUTORES
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count -- Contar el número de obras asociadas al autor
    FROM OBRAS
    WHERE cod_autor = :OLD.cod_autor;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el autor porque tiene obras registradas.');
    END IF;
END;
/

-- OBRAS


-- GENERAL

-- ACTIVIDADES

-- Trigger para no borrar una actividad si hay una visita o exposicion activa
CREATE OR REPLACE TRIGGER trg_borrar_visita
BEFORE DELETE ON VISITAS FOR EACH ROW

DECLARE
    v_visitas NUMBER; --GUARDARÁN EL NÚMERO DE VISITAS
    
BEGIN
    SELECT COUNT(*) INTO v_visitas FROM VISITAS WHERE cod_visita = :OLD.cod_visita;

    IF v_visitas > 0 THEN
        RAISE_APPLICATION_ERROR(-20008,'No se puede borrar la actividad porque hay una visita activa');
    END IF;
END;
/

-- AUTORES

-- Trigger para evitar eliminar autores que tengan obras registradas
CREATE OR REPLACE TRIGGER no_borrar_autor_con_obras
BEFORE DELETE ON AUTORES
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count -- Contar el número de obras asociadas al autor
    FROM OBRAS
    WHERE cod_autor = :OLD.cod_autor;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el autor porque tiene obras registradas.');
    END IF;
END;
/

-- OBRAS

-- Trigger para evitar que haya obras anteriores al nacimiento de su autor
CREATE OR REPLACE TRIGGER trg_update_num_obras
AFTER UPDATE ON OBRAS FOR EACH ROW

DECLARE 
    v_fecha DATE;

BEGIN
    SELECT fecha_nacimiento INTO v_fecha FROM AUTORES WHERE cod_autor = :NEW.cod_autor;

    IF :NEW.fecha_creacion IS NOT NULL AND v_fecha IS NOT NULL THEN
        IF :NEW.fecha_creacion < v_fecha THEN
            RAISE_APPLICATION_ERROR(-20003, 'La fecha de creacion de la obra no puede ser anterior a la de nacimiento del autor');
        END IF;
    END IF;
END;
/

-- Triggers para controlar el numero de obras de un autor

CREATE OR REPLACE TRIGGER trg_insertar_num_obras
AFTER INSERT ON OBRAS
FOR EACH ROW
BEGIN
    -- Incrementar el número de obras del autor
    UPDATE AUTORES
    SET num_obras = num_obras + 1
    WHERE cod_autor = :NEW.cod_autor;
END trg_insertar_obra;
/

CREATE OR REPLACE TRIGGER trg_actualizar_num_obras
AFTER UPDATE ON OBRAS
FOR EACH ROW
BEGIN
    -- Si el autor de la obra ha cambiado, restamos una obra al autor anterior
    IF :OLD.cod_autor != :NEW.cod_autor THEN
        UPDATE AUTORES
        SET num_obras = num_obras - 1
        WHERE cod_autor = :OLD.cod_autor;

        -- Sumamos una obra al nuevo autor
        UPDATE AUTORES
        SET num_obras = num_obras + 1
        WHERE cod_autor = :NEW.cod_autor;
    END IF;
END trg_actualizar_obra;
/

CREATE OR REPLACE TRIGGER trg_eliminar_obra
AFTER DELETE ON OBRAS
FOR EACH ROW
BEGIN
    -- Decrementar el número de obras del autor
    UPDATE AUTORES
    SET num_obras = num_obras - 1
    WHERE cod_autor = :OLD.cod_autor;
END trg_eliminar_obra;
/



