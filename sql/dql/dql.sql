USE db_capacitaciones;

-- =====================================================
-- Consulta 1: INNER JOIN
-- Detalle de inscripciones
-- =====================================================
SELECT
    i.id_inscripcion,
    d.nombre_dev,
    d.nivel,
    m.titulo_modulo,
    i.fecha_inicio
FROM inscripciones i
INNER JOIN desarrolladores d
    ON i.id_dev = d.id_dev
INNER JOIN modulos m
    ON i.id_modulo = m.id_modulo
ORDER BY i.fecha_inicio;


-- =====================================================
-- Consulta 2: Uso de IN
-- Desarrolladores con nivel Junior o Trainee
-- =====================================================
SELECT
    id_dev,
    nombre_dev,
    nivel
FROM desarrolladores
WHERE nivel IN ('Junior', 'Trainee');


-- =====================================================
-- Consulta 3: Cantidad de inscripciones por desarrollador
-- =====================================================
SELECT
    d.id_dev,
    d.nombre_dev,
    COUNT(i.id_inscripcion) AS total_inscripciones
FROM desarrolladores d
LEFT JOIN inscripciones i
    ON d.id_dev = i.id_dev
GROUP BY
    d.id_dev,
    d.nombre_dev
ORDER BY total_inscripciones DESC;


-- =====================================================
-- Consulta 4: Módulos con sus tecnologías
-- =====================================================
SELECT
    m.id_modulo,
    m.titulo_modulo,
    GROUP_CONCAT(t.nombre_tecnologia ORDER BY t.nombre_tecnologia SEPARATOR ', ') AS tecnologias
FROM modulos m
LEFT JOIN modulo_tecnologia mt
    ON m.id_modulo = mt.id_modulo
LEFT JOIN tecnologias t
    ON mt.id_tecnologia = t.id_tecnologia
GROUP BY
    m.id_modulo,
    m.titulo_modulo
ORDER BY m.id_modulo;


-- =====================================================
-- Consulta 5: Módulos que usan Python
-- =====================================================
SELECT
    m.id_modulo,
    m.titulo_modulo
FROM modulos m
INNER JOIN modulo_tecnologia mt
    ON m.id_modulo = mt.id_modulo
INNER JOIN tecnologias t
    ON mt.id_tecnologia = t.id_tecnologia
WHERE t.nombre_tecnologia IN ('Python');


-- =====================================================
-- Consulta 6: Inscripciones del desarrollador D01
-- =====================================================
SELECT
    i.id_inscripcion,
    m.titulo_modulo,
    i.fecha_inicio
FROM inscripciones i
INNER JOIN modulos m
    ON i.id_modulo = m.id_modulo
WHERE i.id_dev IN ('D01')
ORDER BY i.fecha_inicio;
