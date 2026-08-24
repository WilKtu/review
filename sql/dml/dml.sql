USE db_capacitaciones;


INSERT INTO desarrolladores (id_dev, nombre_dev, nivel) 
VALUES ('D01', 'Ana Torres', 'Junior'),
    ('D02', 'Carlos Gómez', 'Junior'),
    ('D03', 'Lucía Ruiz', 'Trainee'),
    ('D04', 'David Soto', 'Junior'),
    ('D05', 'Elena Vega', 'Junior'),
    ('D06', 'Fernando Marín', 'Trainee');


INSERT INTO modulos (id_modulo, titulo_modulo) 
VALUES ('M101', 'Ingeniería de Requisitos'),
    ('M102', 'Automatización de Flujos'),
    ('M103', 'Principios Clean Code'),
    ('M104', 'Componentes Web Vanilla'),
    ('M105', 'Fundamentos de SQL'),
    ('M106', 'Modelado de Datos'),
    ('M107', 'Control de Versiones'),
    ('M108', 'Pruebas Unitarias'),
    ('M109', 'Introducción a APIs REST'),
    ('M110', 'Contenedores Básicos'),
    ('M111', 'Introducción a CI/CD'),
    ('M112', 'Metodologías Ágiles'),
    ('M113', 'Estructuras de Datos'),
    ('M114', 'Seguridad Web Básica');


INSERT INTO tecnologias (id_tecnologia, nombre_tecnologia) 
VALUES (1, 'Metodología'),
    (2, 'n8n'),
    (3, 'Python'),
    (4, 'HTML'),
    (5, 'CSS'),
    (6, 'PostgreSQL'),
    (7, 'Conceptual'),
    (8, 'Lógico'),
    (9, 'Git'),
    (10, 'Jest'),
    (11, 'PyTest'),
    (12, 'Express'),
    (13, 'FastPI'),
    (14, 'Docker'),
    (15, 'GitHub Actions'),
    (16, 'Scrum'),
    (17, 'Algoritmia'),
    (18, 'OWASP Top 10');

INSERT INTO modulo_tecnologia (id_modulo, id_tecnologia) 
VALUES ('M101', 1),
    ('M102', 2),
    ('M103', 3),
    ('M104', 4),
    ('M104', 5),
    ('M105', 6),
    ('M106', 7),
    ('M106', 8),
    ('M107', 9),
    ('M108', 10),
    ('M108', 11),
    ('M109', 12),
    ('M109', 13),
    ('M110', 14),
    ('M111', 15),
    ('M112', 16),
    ('M113', 17),
    ('M114', 18);


INSERT INTO inscripciones (id_inscripcion, id_dev, id_modulo, fecha_inicio) VALUES ('INV-001', 'D01', 'M101', '2026-06-01'),
    ('INV-002', 'D01', 'M103', '2026-06-05'),
    ('INV-003', 'D02', 'M102', '2026-06-02'),
    ('INV-004', 'D03', 'M104', '2026-06-10'),
    ('INV-005', 'D01', 'M105', '2026-06-12'),
    ('INV-006', 'D01', 'M106', '2026-06-15'),
    ('INV-007', 'D01', 'M107', '2026-06-18'),
    ('INV-008', 'D02', 'M101', '2026-06-01'),
    ('INV-009', 'D02', 'M103', '2026-06-06'),
    ('INV-010', 'D02', 'M105', '2026-06-12'),
    ('INV-011', 'D02', 'M106', '2026-06-15'),
    ('INV-012', 'D03', 'M101', '2026-06-02'),
    ('INV-013', 'D03', 'M105', '2026-06-13'),
    ('INV-014', 'D03', 'M107', '2026-06-19'),
    ('INV-015', 'D04', 'M101', '2026-06-03'),
    ('INV-016', 'D04', 'M102', '2026-06-04'),
    ('INV-017', 'D04', 'M103', '2026-06-07'),
    ('INV-018', 'D04', 'M105', '2026-06-14'),
    ('INV-019', 'D04', 'M108', '2026-06-20'),
    ('INV-020', 'D05', 'M102', '2026-06-05'),
    ('INV-021', 'D05', 'M104', '2026-06-11'),
    ('INV-022', 'D05', 'M105', '2026-06-14'),
    ('INV-023', 'D05', 'M109', '2026-06-22'),
    ('INV-024', 'D05', 'M110', '2026-06-25'),
    ('INV-025', 'D06', 'M103', '2026-06-08'),
    ('INV-026', 'D06', 'M105', '2026-06-15'),
    ('INV-027', 'D06', 'M111', '2026-06-26'),
    ('INV-028', 'D06', 'M112', '2026-06-28'),
    ('INV-029', 'D01', 'M113', '2026-06-29'),
    ('INV-030', 'D02', 'M114', '2026-06-30');

