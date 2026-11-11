USE ganaderia;


INSERT INTO RAZA (id_raza, nombre, proposito, peso_adulto_kg) VALUES
(1, 'Holstein',     'Leche',          650.00),
(2, 'Pardo Suizo',  'Doble proposito', 620.00),
(3, 'Brahman',      'Carne',          700.00),
(4, 'Jersey',       'Leche',          430.00),
(5, 'Criolla',      'Doble proposito', 450.00),
(6, 'Mestiza',      'Doble proposito', 500.00);

INSERT INTO POTRERO (id_potrero, nombre, area_ha, tipo_pasto, capacidad) VALUES
(1, 'El Mirador',        3.50, 'Kikuyo',            12),
(2, 'La Esperanza',      4.00, 'Rye grass-trebol',  14),
(3, 'Los Laureles',      2.50, 'Kikuyo',             6),
(4, 'San Jose',          6.00, 'Brachiaria',        20),
(5, 'Corral de Ordeno',  0.50, 'Estabulado',         8);

INSERT INTO VETERINARIO (id_veterinario, cedula, nombres, apellidos, telefono) VALUES
(1, '1100000011', 'Carlos Andres',  'Mora Jimenez',   '0990000001'),
(2, '1100000022', 'Maria Fernanda', 'Ortega Salinas', '0990000002'),
(3, '1100000033', 'Luis Alberto',   'Cueva Armijos',  '0990000003'),
(4, '1100000044', 'Sofia Elena',    'Granda Poma',    '0990000004'),
(5, '1100000055', 'Diego Patricio', 'Tapia Rojas',    '0990000005');

INSERT INTO ALIMENTO (id_alimento, nombre, tipo, costo_kg) VALUES
(1, 'Pasto Kikuyo',            'Forraje',     0.05),
(2, 'Pasto Elefante',          'Forraje',     0.04),
(3, 'Heno de avena',           'Forraje',     0.22),
(4, 'Ensilaje de maiz',        'Forraje',     0.09),
(5, 'Balanceado lechero 18%',  'Concentrado', 0.55),
(6, 'Balanceado de engorde',   'Concentrado', 0.50),
(7, 'Sal mineralizada',        'Suplemento',  0.80),
(8, 'Melaza',                  'Suplemento',  0.30);

INSERT INTO ANIMAL (id_animal, arete, nombre, sexo, fecha_nacimiento, peso_nacimiento_kg,
                    estado, estado_reproductivo, id_raza, id_potrero, id_madre, id_padre) VALUES
(1,  'EC-0001', 'Jupiter',  'M', '2019-03-12', 42.0, 'Activo',  'No aplica', 1, 3, NULL, NULL),
(2,  'EC-0002', 'Tornado',  'M', '2018-07-20', 45.0, 'Activo',  'No aplica', 2, 3, NULL, NULL),
(3,  'EC-0003', 'Luna',     'H', '2019-02-10', 38.0, 'Activo',  'Lactante',  1, 1, NULL, NULL),
(4,  'EC-0004', 'Estrella', 'H', '2019-08-05', 37.5, 'Activo',  'Gestante',  1, 1, NULL, NULL),
(5,  'EC-0005', 'Canela',   'H', '2020-01-18', 39.0, 'Activo',  'Lactante',  2, 2, NULL, NULL),
(6,  'EC-0006', 'Paloma',   'H', '2020-05-30', 28.0, 'Activo',  'Vacia',     4, 2, NULL, NULL),
(7,  'EC-0007', 'Mora',     'H', '2018-11-22', 32.0, 'Activo',  'Gestante',  3, 4, NULL, NULL),
(8,  'EC-0008', 'Reina',    'H', '2021-03-09', 30.0, 'Activo',  'Vacia',     5, 4, NULL, NULL),
(9,  'EC-0009', 'Bonita',   'H', '2021-09-14', 33.0, 'Activo',  'Lactante',  6, 4, NULL, NULL),
(10, 'EC-0010', 'Nieves',   'H', '2022-04-02', 37.0, 'Activo',  'Vacia',     1, 1, 3,    1),
(11, 'EC-0011', 'Pinta',    'H', '2025-02-20', 36.0, 'Activo',  'No aplica', 1, 1, 3,    1),
(12, 'EC-0012', 'Rocky',    'M', '2025-06-15', 41.0, 'Activo',  'No aplica', 2, 2, 5,    2),
(13, 'EC-0013', 'Lucero',   'M', '2026-01-10', 35.0, 'Activo',  'No aplica', 6, 4, 9,    2),
(14, 'EC-0014', 'Aurora',   'H', '2024-06-10', 31.0, 'Activo',  'Vacia',     3, 4, 7,    NULL),
(15, 'EC-0015', 'Marquesa', 'H', '2018-04-04', 38.0, 'Vendido', 'No aplica', 1, NULL, NULL, NULL);

INSERT INTO CELO (id_celo, id_animal, fecha_inicio, duracion_horas, intensidad, observaciones) VALUES
(1,  3,  '2024-05-12', 20, 'Alta',  'Monta a otras vacas, moco cristalino'),
(2,  5,  '2024-09-04', 16, 'Media', 'Inquietud y menor produccion de leche'),
(3,  9,  '2025-04-01', 18, 'Alta',  'Acepta la monta'),
(4,  4,  '2026-07-19', 22, 'Alta',  'Moco abundante, vulva inflamada'),
(5,  8,  '2026-07-31', 10, 'Baja',  'Celo corto, no se sirvio'),
(6,  7,  '2026-08-04', 14, 'Media', 'Detectado por el vaquero en la manana'),
(7,  8,  '2026-08-21', 18, 'Baja',  'Servida al dia siguiente'),
(8,  6,  '2026-09-08', 18, 'Media', 'No se sirvio'),
(9,  8,  '2026-09-11', 19, 'Media', 'Retorno a celo: no quedo gestante'),
(10, 10, '2026-09-13', 12, 'Baja',  'Primer celo observado, no se sirvio'),
(11, 6,  '2026-09-29', 20, 'Alta',  'Inseminada el dia siguiente'),
(12, 10, '2026-10-04', 17, 'Media', 'Inseminada el dia siguiente');

INSERT INTO SERVICIO (id_servicio, id_hembra, id_toro, id_celo, fecha_servicio, tipo, resultado) VALUES
(1, 3,  1, 1,  '2024-05-13', 'Inseminacion artificial', 'Parida'),
(2, 5,  2, 2,  '2024-09-05', 'Monta natural',           'Parida'),
(3, 9,  2, 3,  '2025-04-02', 'Monta natural',           'Parida'),
(4, 4,  1, 4,  '2026-07-20', 'Inseminacion artificial', 'Gestante'),
(5, 7,  2, 6,  '2026-08-05', 'Monta natural',           'Gestante'),
(6, 8,  2, 7,  '2026-08-22', 'Monta natural',           'Vacia'),
(7, 6,  1, 11, '2026-09-30', 'Inseminacion artificial', 'Pendiente'),
(8, 10, 1, 12, '2026-10-05', 'Inseminacion artificial', 'Pendiente');

INSERT INTO PARTO (id_parto, id_servicio, id_cria, fecha_parto, tipo_parto) VALUES
(1, 1, 11, '2025-02-20', 'Normal'),
(2, 2, 12, '2025-06-15', 'Asistido'),
(3, 3, 13, '2026-01-10', 'Normal');

INSERT INTO CONSUMO_ALIMENTO (id_animal, id_alimento, fecha, cantidad_kg) VALUES
(3, 1, '2026-10-01', 45.00), (3, 2, '2026-10-02', 22.00), (3, 3, '2026-10-03',  4.00),
(3, 4, '2026-10-04', 15.00), (3, 5, '2026-10-01',  6.00), (3, 7, '2026-10-01',  0.12),
(4, 1, '2026-10-01', 40.00), (4, 2, '2026-10-02', 20.00), (4, 3, '2026-10-03',  3.50),
(4, 4, '2026-10-04', 12.00), (4, 5, '2026-10-01',  5.00),
(5, 1, '2026-10-01', 42.00), (5, 2, '2026-10-02', 18.00), (5, 3, '2026-10-03',  4.00),
(5, 4, '2026-10-04', 14.00), (5, 5, '2026-10-02',  5.50), (5, 8, '2026-10-02',  0.40),
(6, 1, '2026-10-01', 30.00), (6, 3, '2026-10-02',  3.00), (6, 5, '2026-10-02',  4.00),
(7, 2, '2026-10-01', 38.00), (7, 4, '2026-10-03', 10.00), (7, 6, '2026-10-02',  3.00),
(7, 7, '2026-10-02',  0.10),
(8, 2, '2026-10-01', 36.00), (8, 1, '2026-10-02', 30.00), (8, 3, '2026-10-03',  3.00),
(8, 7, '2026-10-02',  0.10),
(9, 1, '2026-10-01', 33.00), (9, 2, '2026-10-02', 25.00), (9, 5, '2026-10-01',  4.50),
(10, 1, '2026-10-01', 28.00), (10, 5, '2026-10-02',  3.00),
(1, 1, '2026-10-01', 50.00), (1, 2, '2026-10-02', 25.00), (1, 6, '2026-10-01',  4.00),
(1, 7, '2026-10-02',  0.15),
(2, 1, '2026-10-01', 48.00), (2, 4, '2026-10-03', 16.00), (2, 6, '2026-10-02',  4.00),
(14, 2, '2026-10-01', 30.00), (14, 8, '2026-10-02', 0.30);

INSERT INTO CONTROL_SANITARIO (id_control, id_animal, id_veterinario, fecha, tipo, producto, observaciones) VALUES
(1,  3,  1, '2026-03-10', 'Vacunacion',      'Vacuna fiebre aftosa',       'Refuerzo semestral'),
(2,  4,  1, '2026-03-10', 'Vacunacion',      'Vacuna fiebre aftosa',       'Refuerzo semestral'),
(3,  5,  1, '2026-03-10', 'Vacunacion',      'Vacuna fiebre aftosa',       'Refuerzo semestral'),
(4,  6,  2, '2026-04-02', 'Desparasitacion', 'Ivermectina 1%',             'Dosis segun peso'),
(5,  7,  2, '2026-04-02', 'Desparasitacion', 'Ivermectina 1%',             'Dosis segun peso'),
(6,  8,  3, '2026-05-15', 'Tratamiento',     'Oxitetraciclina',            'Cojera leve en miembro posterior'),
(7,  9,  3, '2026-06-20', 'Revision',        NULL,                         'Control posparto sin novedades'),
(8,  4,  1, '2026-08-25', 'Revision',        NULL,                         'Palpacion: gestacion positiva'),
(9,  7,  2, '2026-09-10', 'Revision',        NULL,                         'Gestacion confirmada'),
(10, 10, 4, '2026-10-12', 'Vacunacion',      'Vacuna triple (clostridiosis)', 'Primera dosis'),
(11, 12, 5, '2026-02-01', 'Desparasitacion', 'Albendazol',                 'Ternero'),
(12, 13, 5, '2026-04-12', 'Vacunacion',      'Vacuna neumoenteritis',      'Ternero'),
(13, 1,  2, '2026-03-12', 'Revision',        NULL,                         'Evaluacion andrologica favorable');
