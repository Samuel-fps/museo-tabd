-- Autor 1
INSERT INTO AUTORES (
    nombre,
    pais_origen,
    fecha_nacimiento,
    fecha_muerte,
    estilo
) VALUES (
    TipoNombre('Pablo', 'Plátano Picasso'),
    'España',
    TO_DATE('1881-10-25', 'YYYY-MM-DD'),
    TO_DATE('1973-04-08', 'YYYY-MM-DD'),
    'Cubismo'
);

-- Autor 2
INSERT INTO AUTORES (
    nombre,
    pais_origen,
    fecha_nacimiento,
    fecha_muerte,
    estilo
) VALUES (
    TipoNombre('Andy', 'Melon Warhol'),
    'Estados Unidos',
    TO_DATE('1928-08-06', 'YYYY-MM-DD'),
    TO_DATE('1987-02-22', 'YYYY-MM-DD'),
    'Pop Art'
);

-- Autor 3
INSERT INTO AUTORES (
    nombre,
    pais_origen,
    fecha_nacimiento,
    fecha_muerte,
    estilo
) VALUES (
    TipoNombre('Frida', 'Manzana Kahlo'),
    'México',
    TO_DATE('1907-07-06', 'YYYY-MM-DD'),
    TO_DATE('1954-07-13', 'YYYY-MM-DD'),
    'Surrealismo'
);


-- Sala 1
INSERT INTO SALAS (nombre, descripcion, localizacion)
VALUES (
    'Sala Tropical',
    'Exhibe obras de arte inspiradas en frutas tropicales.',
    'Planta Baja - Ala Norte'
);

-- Sala 2
INSERT INTO SALAS (nombre, descripcion, localizacion)
VALUES (
    'Sala Vanguardista',
    'Espacio dedicado a las reinterpretaciones modernas de la fruta en el arte contemporáneo.',
    'Planta Baja - Ala Este'
);

-- Sala 3
INSERT INTO SALAS (nombre, descripcion, localizacion)
VALUES (
    'Galería Histórica',
    'Recorrido por la historia del arte con motivos frutales desde la antigüedad hasta el siglo XIX.',
    'Primer Piso - Ala Oeste'
);

-- Sala 4
INSERT INTO SALAS (nombre, descripcion, localizacion)
VALUES (
    'Sala Experimental',
    'Lugar para instalaciones y obras de arte multimedia relacionadas con la cultura de la fruta.',
    'Segundo Piso - Ala Sur'
);

-- Sala 5
INSERT INTO SALAS (nombre, descripcion, localizacion)
VALUES (
    'Mini Galería Juvenil',
    'Pequeña sala dedicada a obras realizadas por artistas jóvenes sobre la temática frutal.',
    'Planta Baja - Cerca de la Entrada Principal'
);



-- Obra 1 - Pablo Plátano Picasso
INSERT INTO OBRAS (
    nombre,
    descripcion,
    fecha_creacion,
    fecha_adquisicion,
    tipo,
    est_artistico,
    est_historico,
    cod_sala,
    cod_autor
) VALUES (
    'El Sueño del Plátano Azul',
    'Una pieza cubista representando la dualidad del plátano.',
    TO_DATE('1932-03-15', 'YYYY-MM-DD'),
    SYSDATE,
    'Cuadro',
    'Cubismo',
    'Vanguardia',
    1,
    1  
);

-- Obra 2 - Pablo Plátano Picasso
INSERT INTO OBRAS (
    nombre,
    descripcion,
    fecha_creacion,
    fecha_adquisicion,
    tipo,
    est_artistico,
    est_historico,
    cod_sala,
    cod_autor
) VALUES (
    'Naturaleza Platanal Muerta',
    'Una reinterpretación cubista de un racimo de plátanos.',
    TO_DATE('1940-06-20', 'YYYY-MM-DD'),
    SYSDATE,
    'Cuadro',
    'Cubismo',
    'Vanguardia',
    1,
    1
);

-- Obra 3 - Andy Melon Warhol
INSERT INTO OBRAS (
    nombre,
    descripcion,
    fecha_creacion,
    fecha_adquisicion,
    tipo,
    est_artistico,
    est_historico,
    cod_sala,
    cod_autor
) VALUES (
    'Melón Pop',
    'La famosa serie de serigrafías de melones en colores vibrantes.',
    TO_DATE('1965-11-05', 'YYYY-MM-DD'),
    SYSDATE,
    'Cuadro',
    'Pop Art',
    'Contemporáneo',
    2,
    2
);

-- Obra 4 - Frida Manzana Kahlo
INSERT INTO OBRAS (
    nombre,
    descripcion,
    fecha_creacion,
    fecha_adquisicion,
    tipo,
    est_artistico,
    est_historico,
    cod_sala,
    cod_autor
) VALUES (
    'Manzanas y Raíces',
    'Una obra surrealista que explora la conexión entre la naturaleza y la identidad.',
    TO_DATE('1944-09-12', 'YYYY-MM-DD'),
    SYSDATE,
    'Cuadro',
    'Surrealismo',
    'Modernismo',
    4,
    3
);

-- Obra 5 - Andy Melon Warhol
INSERT INTO OBRAS (
    nombre,
    descripcion,
    fecha_creacion,
    fecha_adquisicion,
    tipo,
    est_artistico,
    est_historico,
    cod_sala,
    cod_autor
) VALUES (
    'Melón Doble Exposure',
    'Un experimento visual sobre la repetición y la cultura pop.',
    TO_DATE('1970-02-10', 'YYYY-MM-DD'),
    SYSDATE,
    'Fotografía',
    'Pop Art',
    'Contemporáneo',
    5,
    2
);


--INSERTAR DEPARTAMENTOS
INSERT INTO DEPARTAMENTOS (nombre, descripcion, cod_encargado)
VALUES ('Conservación', 'Se encarga del mantenimiento y preservación de las obras.', NULL);

INSERT INTO DEPARTAMENTOS (nombre, descripcion, cod_encargado)
VALUES ('Educación', 'Organiza visitas guiadas y programas educativos.', NULL);

INSERT INTO DEPARTAMENTOS (nombre, descripcion, cod_encargado)
VALUES ('Curaduría', 'Selecciona y organiza las exposiciones temporales.', NULL);

INSERT INTO DEPARTAMENTOS (nombre, descripcion, cod_encargado)
VALUES ('Administración', 'Gestiona los recursos humanos y financieros del museo.', NULL);

INSERT INTO DEPARTAMENTOS (nombre, descripcion, cod_encargado)
VALUES ('Tecnología', 'Gestiona los sistemas informáticos y la plataforma web.', NULL);


--INSERTAR ROLES
INSERT INTO ROLES (nombre, descripcion)
VALUES ('Guía', 'Responsable de realizar visitas guiadas a los visitantes.');

INSERT INTO ROLES (nombre, descripcion)
VALUES ('Curador', 'Selecciona y organiza las obras para exposiciones.');

INSERT INTO ROLES (nombre, descripcion)
VALUES ('Administrador', 'Gestiona el sistema y los usuarios.');

INSERT INTO ROLES (nombre, descripcion)
VALUES ('Recepcionista', 'Atiende al público y gestiona la venta de entradas.');

INSERT INTO ROLES (nombre, descripcion)
VALUES ('Técnico de conservación', 'Supervisa el estado de las obras y su preservación.');


--INSERT CONTRATOS
INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2023-01-10', 'YYYY-MM-DD'), TO_DATE('2024-01-10', 'YYYY-MM-DD'), 18000.00, 'Completa', 'Activo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2022-05-01', 'YYYY-MM-DD'), NULL, 15000.00, 'Parcial', 'Activo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2021-09-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 22000.00, 'Completa', 'Inactivo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2020-03-20', 'YYYY-MM-DD'), TO_DATE('2021-03-20', 'YYYY-MM-DD'), 16000.00, 'Parcial', 'Inactivo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2024-02-01', 'YYYY-MM-DD'), NULL, 24000.00, 'Completa', 'Activo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2023-07-10', 'YYYY-MM-DD'), TO_DATE('2024-07-10', 'YYYY-MM-DD'), 20000.00, 'Completa', 'Activo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2023-11-01', 'YYYY-MM-DD'), 19000.00, 'Parcial', 'Inactivo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2023-03-01', 'YYYY-MM-DD'), NULL, 25000.00, 'Completa', 'Activo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2021-06-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 17000.00, 'Parcial', 'Inactivo');

INSERT INTO CONTRATOS (fecha_ini, fecha_fin, sueldo, jornada_laboral, estado)
VALUES (TO_DATE('2024-01-01', 'YYYY-MM-DD'), NULL, 26000.00, 'Completa', 'Activo');
