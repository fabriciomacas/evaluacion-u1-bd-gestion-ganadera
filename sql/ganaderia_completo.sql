-- ============================================================
-- Sistema de Gestión Ganadera (bovinos) - MySQL 8.0
-- ============================================================
DROP DATABASE IF EXISTS ganaderia;
CREATE DATABASE ganaderia CHARACTER SET utf8mb4;
USE ganaderia;

CREATE TABLE RAZA (
    id_raza          INT          NOT NULL AUTO_INCREMENT,
    nombre           VARCHAR(50)  NOT NULL,
    proposito        VARCHAR(20)  NOT NULL,
    peso_adulto_kg   DECIMAL(6,2),
    PRIMARY KEY (id_raza),
    UNIQUE (nombre),
    CHECK (proposito IN ('Leche','Carne','Doble proposito'))
);

CREATE TABLE POTRERO (
    id_potrero   INT           NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(50)   NOT NULL,
    area_ha      DECIMAL(6,2)  NOT NULL,
    tipo_pasto   VARCHAR(40),
    capacidad    INT           NOT NULL,
    PRIMARY KEY (id_potrero),
    UNIQUE (nombre),
    CHECK (area_ha > 0),
    CHECK (capacidad > 0)
);

CREATE TABLE VETERINARIO (
    id_veterinario  INT          NOT NULL AUTO_INCREMENT,
    cedula          CHAR(10)     NOT NULL,
    nombres         VARCHAR(80)  NOT NULL,
    apellidos       VARCHAR(80)  NOT NULL,
    telefono        VARCHAR(15),
    PRIMARY KEY (id_veterinario),
    UNIQUE (cedula)
);

CREATE TABLE ALIMENTO (
    id_alimento     INT           NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(60)   NOT NULL,
    tipo            VARCHAR(20)   NOT NULL,
    costo_kg        DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (id_alimento),
    UNIQUE (nombre),
    CHECK (tipo IN ('Forraje','Concentrado','Suplemento')),
    CHECK (costo_kg >= 0)
);

CREATE TABLE ANIMAL (
    id_animal             INT          NOT NULL AUTO_INCREMENT,
    arete                 VARCHAR(15)  NOT NULL,
    nombre                VARCHAR(40),
    sexo                  CHAR(1)      NOT NULL,
    fecha_nacimiento      DATE         NOT NULL,
    peso_nacimiento_kg    DECIMAL(5,2),
    estado                VARCHAR(15)  NOT NULL DEFAULT 'Activo',
    estado_reproductivo   VARCHAR(15)  NOT NULL DEFAULT 'No aplica',
    id_raza               INT          NOT NULL,
    id_potrero            INT,
    id_madre              INT,
    id_padre              INT,
    PRIMARY KEY (id_animal),
    UNIQUE (arete),
    CHECK (sexo IN ('H','M')),
    CHECK (estado IN ('Activo','Vendido','Muerto')),
    CHECK (estado_reproductivo IN ('Vacia','Gestante','Lactante','No aplica')),
    FOREIGN KEY (id_raza)    REFERENCES RAZA(id_raza),
    FOREIGN KEY (id_potrero) REFERENCES POTRERO(id_potrero),
    FOREIGN KEY (id_madre)   REFERENCES ANIMAL(id_animal),
    FOREIGN KEY (id_padre)   REFERENCES ANIMAL(id_animal)
);

CREATE TABLE CONSUMO_ALIMENTO (
    id_consumo   INT           NOT NULL AUTO_INCREMENT,
    id_animal    INT           NOT NULL,
    id_alimento  INT           NOT NULL,
    fecha        DATE          NOT NULL,
    cantidad_kg  DECIMAL(6,2)  NOT NULL,
    PRIMARY KEY (id_consumo),
    UNIQUE (id_animal, id_alimento, fecha),
    CHECK (cantidad_kg > 0),
    FOREIGN KEY (id_animal)   REFERENCES ANIMAL(id_animal),
    FOREIGN KEY (id_alimento) REFERENCES ALIMENTO(id_alimento)
);

CREATE TABLE CELO (
    id_celo             INT          NOT NULL AUTO_INCREMENT,
    id_animal           INT          NOT NULL,
    fecha_inicio        DATE         NOT NULL,
    duracion_horas      INT          NOT NULL DEFAULT 18,
    intensidad          VARCHAR(10)  NOT NULL,
    observaciones       VARCHAR(150),
    fecha_proximo_celo  DATE GENERATED ALWAYS AS
        (DATE_ADD(fecha_inicio, INTERVAL 21 DAY)) STORED,
    PRIMARY KEY (id_celo),
    CHECK (duracion_horas BETWEEN 6 AND 36),
    CHECK (intensidad IN ('Baja','Media','Alta')),
    FOREIGN KEY (id_animal) REFERENCES ANIMAL(id_animal)
);

CREATE TABLE SERVICIO (
    id_servicio       INT          NOT NULL AUTO_INCREMENT,
    id_hembra         INT          NOT NULL,
    id_toro           INT,
    id_celo           INT,
    fecha_servicio    DATE         NOT NULL,
    tipo              VARCHAR(25)  NOT NULL,
    resultado         VARCHAR(15)  NOT NULL DEFAULT 'Pendiente',
    fecha_probable_parto DATE GENERATED ALWAYS AS
        (DATE_ADD(fecha_servicio, INTERVAL 283 DAY)) STORED,
    PRIMARY KEY (id_servicio),
    CHECK (tipo IN ('Monta natural','Inseminacion artificial')),
    CHECK (resultado IN ('Pendiente','Gestante','Vacia','Parida')),
    FOREIGN KEY (id_hembra) REFERENCES ANIMAL(id_animal),
    FOREIGN KEY (id_toro)   REFERENCES ANIMAL(id_animal),
    FOREIGN KEY (id_celo)   REFERENCES CELO(id_celo)
);

CREATE TABLE PARTO (
    id_parto      INT          NOT NULL AUTO_INCREMENT,
    id_servicio   INT          NOT NULL,
    id_cria       INT,
    fecha_parto   DATE         NOT NULL,
    tipo_parto    VARCHAR(15)  NOT NULL DEFAULT 'Normal',
    PRIMARY KEY (id_parto),
    UNIQUE (id_servicio),
    CHECK (tipo_parto IN ('Normal','Asistido','Cesarea')),
    FOREIGN KEY (id_servicio) REFERENCES SERVICIO(id_servicio),
    FOREIGN KEY (id_cria)     REFERENCES ANIMAL(id_animal)
);

CREATE TABLE CONTROL_SANITARIO (
    id_control      INT          NOT NULL AUTO_INCREMENT,
    id_animal       INT          NOT NULL,
    id_veterinario  INT          NOT NULL,
    fecha           DATE         NOT NULL,
    tipo            VARCHAR(20)  NOT NULL,
    producto        VARCHAR(60),
    observaciones   VARCHAR(150),
    PRIMARY KEY (id_control),
    CHECK (tipo IN ('Vacunacion','Desparasitacion','Tratamiento','Revision')),
    FOREIGN KEY (id_animal)      REFERENCES ANIMAL(id_animal),
    FOREIGN KEY (id_veterinario) REFERENCES VETERINARIO(id_veterinario)
);



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

-- ===== CONSULTAS =====
-- Consulta 1: selección + proyección (σ, π) — celos prolongados desde 2026-07-01
SELECT id_animal, fecha_inicio, duracion_horas, intensidad, fecha_proximo_celo
FROM CELO
WHERE duracion_horas >= 18 AND fecha_inicio >= '2026-07-01';
-- Consulta 2: reunión de 4 tablas (⋈, σ, π) — hembras gestantes con raza, potrero y fecha probable de parto
SELECT a.arete, a.nombre, r.nombre AS raza, p.nombre AS potrero,
       s.fecha_servicio, s.fecha_probable_parto
FROM SERVICIO s
JOIN ANIMAL  a ON s.id_hembra = a.id_animal
JOIN RAZA    r ON a.id_raza   = r.id_raza
JOIN POTRERO p ON a.id_potrero = p.id_potrero
WHERE s.resultado = 'Gestante'
ORDER BY s.fecha_probable_parto;
-- Consulta 3: diferencia (−) — hembras activas >= 15 meses sin celo registrado
SELECT a.arete, a.nombre, a.fecha_nacimiento
FROM ANIMAL a
WHERE a.sexo = 'H' AND a.estado = 'Activo' AND a.fecha_nacimiento <= '2025-08-01'
  AND NOT EXISTS (SELECT 1 FROM CELO c WHERE c.id_animal = a.id_animal);
-- Consulta 3 (variante con EXCEPT; requiere MariaDB 10.3+ / MySQL 8.0.31+)
SELECT id_animal FROM ANIMAL WHERE sexo='H' AND estado='Activo' AND fecha_nacimiento <= '2025-08-01'
EXCEPT SELECT id_animal FROM CELO;
-- Consulta 4: división (÷) — animales que consumieron todos los forrajes
SELECT a.arete, a.nombre
FROM ANIMAL a
WHERE NOT EXISTS (
    SELECT 1 FROM ALIMENTO f
    WHERE f.tipo = 'Forraje'
      AND NOT EXISTS (SELECT 1 FROM CONSUMO_ALIMENTO c
                      WHERE c.id_animal = a.id_animal AND c.id_alimento = f.id_alimento));
-- Consulta 5: agrupamiento (γ) — consumo y costo de alimentación por potrero en octubre 2026
SELECT p.nombre AS potrero, COUNT(DISTINCT a.id_animal) AS animales,
       SUM(c.cantidad_kg) AS total_kg, ROUND(SUM(c.cantidad_kg * al.costo_kg),2) AS costo_usd
FROM CONSUMO_ALIMENTO c
JOIN ANIMAL   a  ON c.id_animal   = a.id_animal
JOIN ALIMENTO al ON c.id_alimento = al.id_alimento
JOIN POTRERO  p  ON a.id_potrero  = p.id_potrero
WHERE c.fecha BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY p.id_potrero, p.nombre
HAVING SUM(c.cantidad_kg * al.costo_kg) >= 12
ORDER BY costo_usd DESC;
