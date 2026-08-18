-- =====================================================
-- Script: 001_create_database.sql
-- Propósito: Crear la base de datos del proyecto.
-- Herramienta: MySQL Workbench
-- =====================================================

CREATE DATABASE IF NOT EXISTS db_capacitaciones_dev
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE db_capacitaciones_dev;

-- =====================================================
-- Tabla: desarrolladores
-- =====================================================

USE db_capacitaciones_dev;

CREATE TABLE IF NOT EXISTS desarrolladores (
    id_dev VARCHAR(10) NOT NULL,
    nombre_dev VARCHAR(100) NOT NULL,
    nivel VARCHAR(20) NOT NULL,

    CONSTRAINT pk_desarrolladores
        PRIMARY KEY (id_dev),

    CONSTRAINT chk_desarrolladores_nivel
        CHECK (nivel IN ('Junior', 'Trainee'))
)ENGINE = InnoDB;

-- =====================================================
-- Tabla: modulos
-- =====================================================

USE db_capacitaciones_dev;

CREATE TABLE IF NOT EXISTS modulos (
    id_modulo VARCHAR(10) NOT NULL,
    titulo_modulo VARCHAR(150) NOT NULL,

    CONSTRAINT pk_modulos
        PRIMARY KEY (id_modulo)
)ENGINE = InnoDB;

-- =====================================================
-- Tabla: tecnologias
-- =====================================================

USE db_capacitaciones_dev;

CREATE TABLE IF NOT EXISTS tecnologias (
    id_tecnologia INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre_tecnologia VARCHAR(100) NOT NULL,

    CONSTRAINT pk_tecnologias
        PRIMARY KEY (id_tecnologia),

    CONSTRAINT uq_tecnologias_nombre
        UNIQUE (nombre_tecnologia)
)ENGINE = InnoDB;

-- =====================================================
-- Tabla: modulo_tecnologia
-- Tabla intermedia para eliminar la dependencia
-- multivaluada de tecnologia_clave.
-- =====================================================

USE db_capacitaciones_dev;

CREATE TABLE IF NOT EXISTS modulo_tecnologia (
    id_modulo VARCHAR(10) NOT NULL,
    id_tecnologia INT UNSIGNED NOT NULL,

    CONSTRAINT pk_modulo_tecnologia
        PRIMARY KEY (id_modulo, id_tecnologia),

    CONSTRAINT fk_modulo_tecnologia_modulo
        FOREIGN KEY (id_modulo)
        REFERENCES modulos (id_modulo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_modulo_tecnologia_tecnologia
        FOREIGN KEY (id_tecnologia)
        REFERENCES tecnologias (id_tecnologia)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)ENGINE = InnoDB;

-- =====================================================
-- Tabla: inscripciones
-- =====================================================

USE db_capacitaciones_dev;

CREATE TABLE IF NOT EXISTS inscripciones (
    id_inscripcion VARCHAR(15) NOT NULL,
    id_dev VARCHAR(10) NOT NULL,
    id_modulo VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL,

    CONSTRAINT pk_inscripciones
        PRIMARY KEY (id_inscripcion),

    CONSTRAINT uq_inscripciones_dev_modulo
        UNIQUE (id_dev, id_modulo),

    CONSTRAINT fk_inscripciones_desarrollador
        FOREIGN KEY (id_dev)
        REFERENCES desarrolladores (id_dev)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_inscripciones_modulo
        FOREIGN KEY (id_modulo)
        REFERENCES modulos (id_modulo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)ENGINE = InnoDB;