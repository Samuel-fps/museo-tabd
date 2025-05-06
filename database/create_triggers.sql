
-- trigger para evitar eliminar autores que tengan obras registradas
CREATE OR REPLACE TRIGGER no_delete_autor_con_obras
BEFORE DELETE ON AUTORES
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM OBRA_DE_ARTE
    WHERE cod_autor = :OLD.cod_autor;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el autor porque tiene obras registradas.');
    END IF;
END;
/

-- trigger para evitar eliminar trapas por error
CREATE OR REPLACE TRIGGER no_drop_table
BEFORE DROP ON DATABASE
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'No está permitido eliminar tablas en esta base de datos.');
END;




/
