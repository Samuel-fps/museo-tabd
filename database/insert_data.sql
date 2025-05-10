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
    'Banana Pop',
    'La famosa serie de serigrafías de melones en colores vibrantes.',
    TO_DATE('1965-11-05', 'YYYY-MM-DD'),
    SYSDATE,
    'Cuadro',
    'Pop Art',
    'Contemporáneo',
    1,
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
    'Plátanos y Raíces',
    'Una obra surrealista que explora la conexión entre la naturaleza y la identidad.',
    TO_DATE('1944-09-12', 'YYYY-MM-DD'),
    SYSDATE,
    'Cuadro',
    'Surrealismo',
    'Modernismo',
    1,
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
    'Plátano Doble Exposure',
    'Un experimento visual sobre la repetición y la cultura pop.',
    TO_DATE('1970-02-10', 'YYYY-MM-DD'),
    SYSDATE,
    'Fotografía',
    'Pop Art',
    'Contemporáneo',
    1,
    2
);
