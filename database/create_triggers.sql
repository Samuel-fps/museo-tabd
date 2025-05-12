-- Archivo donde se contienen los triggers de la base de datos

-- GENERAL

-- Trigger para evitar eliminar tablas por error
CREATE OR REPLACE TRIGGER no_drop_table
BEFORE DROP ON DATABASE
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'No está permitido eliminar tablas en esta base de datos.');
END;
/

-- ACTIVIDADES

-- Trigger para no borrar una actividad si hay una visita o exposicion activa
CREATE OR REPLACE TRIGGER trg_borrar_actividad
BEFORE DELETE ON ACTIVIDADES FOR EACH ROW

DECLARE
    v_visitas NUMBER; --GUARDARÁN EL NÚMERO DE VISITAS Y EXPOSICIONES
    v_exposicion NUMBER;
    
BEGIN
    SELECT COUNT(*) INTO v_visitas FROM VISITA WHERE cod_actividad = :OLD.cod_actividad;

    IF v_visitas > 0 THEN
        RAISE_APPLICATION_ERROR(-20008,"No se puede borrar la actividad porque hay una visita activa");
    END IF;

    SELECT COUNT(*) INTO v_exposicion FROM EXPOSICION WHERE cod_actividad = :OLD.cod_actividad;

    IF v_exposicion > 0 THEN
        RAISE_APPLICATION_ERROR(-20009,"No se puede borrar la actividad porque hay una exposicion activa");
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
            RAISE_APPLICATION_ERROR(-20003, "La fecha de creacion de la obra no puede ser anterior a la de nacimiento del autor");
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
