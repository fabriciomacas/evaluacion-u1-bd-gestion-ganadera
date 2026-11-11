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
