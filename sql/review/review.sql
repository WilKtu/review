USE db_capacitaciones_dev;

DELIMITER //

-- =====================================================
-- Procedimiento con WHILE
-- Cuenta inscripciones por mes dentro de un rango.
-- =====================================================
CREATE PROCEDURE sp_while_ejemplo(IN p_cantidad_meses INT)
BEGIN
    DECLARE v_mes INT DEFAULT 6;
    DECLARE v_fin INT;

    SET v_fin = 6 + COALESCE(p_cantidad_meses, 1) - 1;

    WHILE v_mes <= v_fin DO
        SELECT
            v_mes AS mes,
            COUNT(*) AS total_inscripciones
        FROM inscripciones
        WHERE MONTH(fecha_inicio) = v_mes
          AND YEAR(fecha_inicio) = 2026;

        SET v_mes = v_mes + 1;
    END WHILE;
END //


-- =====================================================
-- Procedimiento con REPEAT
-- =====================================================
CREATE PROCEDURE sp_repeat_ejemplo(IN p_inicio INT, IN p_fin INT)
BEGIN
    DECLARE v_actual INT;

    SET v_actual = p_inicio;

    REPEAT
        SELECT v_actual AS iteracion;

        SET v_actual = v_actual + 1;
    UNTIL v_actual > p_fin
    END REPEAT;
END //


-- =====================================================
-- Procedimiento con CASE
-- =====================================================
CREATE PROCEDURE sp_case_nivel(IN p_id_dev VARCHAR(10))
BEGIN
    DECLARE v_nivel VARCHAR(20) DEFAULT NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_nivel = NULL;

    SELECT nivel
    INTO v_nivel
    FROM desarrolladores
    WHERE id_dev = p_id_dev;

    CASE
        WHEN v_nivel IS NULL THEN
            SELECT 'El desarrollador no existe' AS mensaje;

        WHEN v_nivel = 'Junior' THEN
            SELECT 'Desarrollador Junior' AS mensaje;

        WHEN v_nivel = 'Trainee' THEN
            SELECT 'Desarrollador Trainee' AS mensaje;

        ELSE
            SELECT 'Nivel no reconocido' AS mensaje;
    END CASE;
END //


-- =====================================================
-- Procedimiento con manejo de error específico
-- Error 1062: duplicado
-- Error 1452: clave foránea inválida
-- =====================================================
CREATE PROCEDURE sp_insertar_modulo_tecnologia(
    IN p_id_modulo VARCHAR(10),
    IN p_id_tecnologia INT UNSIGNED
)
BEGIN
    DECLARE v_error INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR 1062
        SET v_error = 1;

    DECLARE CONTINUE HANDLER FOR 1452
        SET v_error = 2;

    INSERT INTO modulo_tecnologia (id_modulo, id_tecnologia)
    VALUES (p_id_modulo, p_id_tecnologia);

    IF v_error = 1 THEN
        SELECT 'Error 1062: la relación módulo-tecnología ya existe.' AS mensaje;
    ELSEIF v_error = 2 THEN
        SELECT 'Error 1452: el módulo o la tecnología no existen.' AS mensaje;
    ELSE
        SELECT 'Registro insertado correctamente.' AS mensaje;
    END IF;
END //


-- =====================================================
-- Procedimiento con manejo de error y transacción
-- Registra una inscripción validando datos.
-- =====================================================
CREATE PROCEDURE sp_registrar_inscripcion_tran(
    IN p_id_inscripcion VARCHAR(15),
    IN p_id_dev VARCHAR(10),
    IN p_id_modulo VARCHAR(10),
    IN p_fecha_inicio DATE
)
BEGIN
    DECLARE v_existe_dev INT DEFAULT 0;
    DECLARE v_existe_modulo INT DEFAULT 0;
    DECLARE v_duplicada INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_existe_dev
    FROM desarrolladores
    WHERE id_dev = p_id_dev;

    SELECT COUNT(*)
    INTO v_existe_modulo
    FROM modulos
    WHERE id_modulo = p_id_modulo;

    SELECT COUNT(*)
    INTO v_duplicada
    FROM inscripciones
    WHERE id_dev = p_id_dev
      AND id_modulo = p_id_modulo;

    IF v_existe_dev = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El desarrollador no existe.';
    END IF;

    IF v_existe_modulo = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El módulo no existe.';
    END IF;

    IF v_duplicada > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El desarrollador ya está inscrito en ese módulo.';
    END IF;

    INSERT INTO inscripciones (
        id_inscripcion,
        id_dev,
        id_modulo,
        fecha_inicio
    ) VALUES (
        p_id_inscripcion,
        p_id_dev,
        p_id_modulo,
        p_fecha_inicio
    );

    COMMIT;
END //


-- =====================================================
-- Procedimiento con parámetro OUT
-- =====================================================
CREATE PROCEDURE sp_total_inscripciones_dev(
    IN p_id_dev VARCHAR(10),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM inscripciones
    WHERE id_dev = p_id_dev;
END //


-- =====================================================
-- Procedimiento con parámetro INOUT
-- =====================================================
CREATE PROCEDURE sp_inout_resumen_dev(
    INOUT p_resumen VARCHAR(500),
    IN p_id_dev VARCHAR(10)
)
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_total
    FROM inscripciones
    WHERE id_dev = p_id_dev;

    SET p_resumen = CONCAT(
        COALESCE(p_resumen, ''),
        ' El desarrollador ',
        p_id_dev,
        ' tiene ',
        v_total,
        ' inscripciones.'
    );
END //


-- =====================================================
-- Procedimiento de inserción con IF THEN ELSE
-- =====================================================
CREATE PROCEDURE sp_insertar_desarrollador(
    IN p_id_dev VARCHAR(10),
    IN p_nombre_dev VARCHAR(100),
    IN p_nivel VARCHAR(20)
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM desarrolladores
        WHERE id_dev = p_id_dev
    ) THEN
        SELECT 'El desarrollador ya existe.' AS mensaje;
    ELSE
        INSERT INTO desarrolladores (id_dev, nombre_dev, nivel)
        VALUES (p_id_dev, p_nombre_dev, p_nivel);

        SELECT 'Desarrollador insertado correctamente.' AS mensaje;
    END IF;
END //


-- =====================================================
-- Procedimiento con LOOP
-- =====================================================
CREATE PROCEDURE sp_loop_ejemplo(IN p_max INT)
BEGIN
    DECLARE v_contador INT DEFAULT 1;

    etiqueta_loop: LOOP
        SELECT v_contador AS iteracion;

        SET v_contador = v_contador + 1;

        IF v_contador > p_max THEN
            LEAVE etiqueta_loop;
        END IF;
    END LOOP;
END //

DELIMITER ;

USE db_capacitaciones_dev;

CALL sp_while_ejemplo(2);

CALL sp_repeat_ejemplo(1, 5);

CALL sp_case_nivel('D01');

CALL sp_insertar_modulo_tecnologia('M101', 1);

CALL sp_registrar_inscripcion_tran(
    'INV-031',
    'D03',
    'M113',
    '2026-07-01'
);

SET @total = 0;
CALL sp_total_inscripciones_dev('D01', @total);
SELECT @total AS total_inscripciones;

SET @resumen = '';
CALL sp_inout_resumen_dev(@resumen, 'D01');
CALL sp_inout_resumen_dev(@resumen, 'D02');
SELECT @resumen AS resumen;

CALL sp_insertar_desarrollador('D07', 'Prueba Nuevo', 'Trainee');

CALL sp_loop_ejemplo(3);


-- =====================================================
-- Funciones creadas por usuario

DELIMITER //

-- =====================================================
-- Función simple
-- =====================================================
CREATE FUNCTION fn_contar_desarrolladores()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_total
    FROM desarrolladores;

    RETURN v_total;
END //


-- =====================================================
-- Función equivalente a calcular comisión
-- En este proyecto se adapta como puntos de capacitación.
-- =====================================================
CREATE FUNCTION fn_calcular_puntos_formacion(p_id_dev VARCHAR(10))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_puntos INT DEFAULT 0;

    SELECT COUNT(*) * 10
    INTO v_puntos
    FROM inscripciones
    WHERE id_dev = p_id_dev;

    RETURN COALESCE(v_puntos, 0);
END //


-- =====================================================
-- Función con condiciones
-- =====================================================
CREATE FUNCTION fn_descripcion_nivel(p_nivel VARCHAR(20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF p_nivel = 'Junior' THEN
        RETURN 'Desarrollador Junior';
    ELSEIF p_nivel = 'Trainee' THEN
        RETURN 'Desarrollador Trainee';
    ELSE
        RETURN 'Nivel desconocido';
    END IF;
END //


-- =====================================================
-- Función con bucle
-- =====================================================
CREATE FUNCTION fn_contar_modulos_hasta(p_numero INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_actual INT DEFAULT 101;
    DECLARE v_total INT DEFAULT 0;

    WHILE v_actual <= p_numero DO
        SET v_total = v_total + (
            SELECT COUNT(*)
            FROM modulos
            WHERE id_modulo = CONCAT('M', v_actual)
        );

        SET v_actual = v_actual + 1;
    END WHILE;

    RETURN v_total;
END //


-- =====================================================
-- Función que accede a datos de la base
-- =====================================================
CREATE FUNCTION fn_obtener_nivel(p_id_dev VARCHAR(10))
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE v_nivel VARCHAR(20) DEFAULT NULL;

    SELECT nivel
    INTO v_nivel
    FROM desarrolladores
    WHERE id_dev = p_id_dev;

    RETURN COALESCE(v_nivel, 'NO EXISTE');
END //


-- =====================================================
-- Función no determinística
-- =====================================================
CREATE FUNCTION fn_fecha_hora_actual()
RETURNS DATETIME
NOT DETERMINISTIC
NO SQL
RETURN NOW() //


-- =====================================================
-- Función con manejo de errores
-- =====================================================
CREATE FUNCTION fn_obtener_nivel_seguro(p_id_dev VARCHAR(10))
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE v_nivel VARCHAR(20) DEFAULT NULL;
    DECLARE v_estado VARCHAR(10) DEFAULT 'OK';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_estado = 'NO_DATA';

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET v_estado = 'ERROR';

    SELECT nivel
    INTO v_nivel
    FROM desarrolladores
    WHERE id_dev = p_id_dev;

    IF v_estado = 'NO_DATA' THEN
        RETURN 'NO EXISTE';
    ELSEIF v_estado = 'ERROR' THEN
        RETURN 'ERROR';
    ELSE
        RETURN COALESCE(v_nivel, 'SIN NIVEL');
    END IF;
END //

DELIMITER ;

USE db_capacitaciones_dev;

SELECT fn_contar_desarrolladores() AS total_desarrolladores;

SELECT fn_calcular_puntos_formacion('D01') AS puntos_d01;

SELECT fn_descripcion_nivel('Junior') AS descripcion;

SELECT fn_contar_modulos_hasta(114) AS modulos_contados;

SELECT fn_obtener_nivel('D01') AS nivel_d01;

SELECT fn_fecha_hora_actual() AS fecha_hora;

SELECT fn_obtener_nivel_seguro('D99') AS nivel_seguro;


-- ==================================================
--Trigger

DELIMITER //

DROP TRIGGER IF EXISTS trg_inscripciones_before_insert //

CREATE TRIGGER trg_inscripciones_before_insert
BEFORE INSERT ON inscripciones
FOR EACH ROW
BEGIN
    IF NEW.fecha_inicio < '2026-01-01' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio no puede ser anterior a 2026.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM inscripciones
        WHERE id_dev = NEW.id_dev
          AND id_modulo = NEW.id_modulo
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El desarrollador ya está inscrito en ese módulo.';
    END IF;
END //

DELIMITER ;

USE db_capacitaciones_dev;

-- Esta inserción debería fallar por duplicado.
INSERT INTO inscripciones (id_inscripcion, id_dev, id_modulo, fecha_inicio)
VALUES ('INV-099', 'D01', 'M101', '2026-07-01');
 
 -- =================================================================
 -- Eventos

 USE db_capacitaciones_dev;

-- Tabla para guardar el reporte diario.
CREATE TABLE IF NOT EXISTS reporte_diario_inscripciones (
    id_reporte INT UNSIGNED NOT NULL AUTO_INCREMENT,
    fecha_reporte DATE NOT NULL,
    id_dev VARCHAR(10) NOT NULL,
    cantidad_inscripciones INT NOT NULL DEFAULT 0,

    CONSTRAINT pk_reporte_diario_inscripciones
        PRIMARY KEY (id_reporte),

    CONSTRAINT uq_reporte_diario_dev_fecha
        UNIQUE (fecha_reporte, id_dev),

    CONSTRAINT fk_reporte_diario_dev
        FOREIGN KEY (id_dev)
        REFERENCES desarrolladores (id_dev)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


DELIMITER //

DROP EVENT IF EXISTS ev_reporte_diario_inscripciones //

CREATE EVENT ev_reporte_diario_inscripciones
ON SCHEDULE
    EVERY 1 DAY
    STARTS '2026-08-16 00:05:00'
DO
BEGIN
    INSERT INTO reporte_diario_inscripciones (
        fecha_reporte,
        id_dev,
        cantidad_inscripciones
    )
    SELECT
        CURRENT_DATE,
        d.id_dev,
        COUNT(i.id_inscripcion)
    FROM desarrolladores d
    LEFT JOIN inscripciones i
        ON d.id_dev = i.id_dev
    GROUP BY d.id_dev
    ON DUPLICATE KEY UPDATE
        cantidad_inscripciones = VALUES(cantidad_inscripciones);
END //

DELIMITER ;

-- ==================================================================
-- Prepare, Execute y Deallocate