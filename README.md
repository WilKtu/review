# Normalización DB_CAPACITACIONES_DEV

## Objetivo

Normalizar la hoja de cálculo `MySQL - 02 - DB_CAPACITACIONES_DEV.xlsx` hasta la Cuarta Forma Normal, creando una estructura adecuada para MySQL Workbench.

## Datos recibidos

La hoja original contenía tres bloques de información:

- Desarrolladores
- Módulos
- Inscripciones

Además, la columna `tecnologia_clave` contenía valores como:

- HTML/CSS
- Jest / PyTest
- Express / FastPI
- Conceptual/Lógico

Esto se interpretó como una dependencia multivaluada.

## Normalización aplicada

### Primera Forma Normal

Se separaron las entidades principales y se eliminaron grupos repetidos.

### Segunda Forma Normal

Se definieron claves primarias claras para cada tabla. Los atributos no clave dependen de la clave completa.

### Tercera Forma Normal

Se separaron desarrolladores, módulos e inscripciones para evitar dependencias transitivas entre entidades distintas.

### Cuarta Forma Normal

Se eliminó la dependencia multivaluada de `tecnologia_clave`. Para eso se crearon:

- `TECNOLOGIAS`
- `MODULO_TECNOLOGIA`

## Tablas resultantes

| Tabla | Descripción |
|---|---|
| desarrolladores | Datos básicos de los desarrolladores. |
| modulos | Módulos de capacitación. |
| tecnologias | Catálogo de tecnologías. |
| modulo_tecnologia | Relación entre módulos y tecnologías. |
| inscripciones | Relación entre desarrolladores y módulos. |

## Decisiones importantes

1. Se conservaron los códigos originales:
   - `D01`, `D02`, etc. para desarrolladores.
   - `M101`, `M102`, etc. para módulos.
   - `INV-001`, `INV-002`, etc. para inscripciones.

2. Las fechas se guardaron como tipo `DATE`.

3. La tecnología `FastPI` se mantuvo como viene en el archivo original.

4. Se agregó una restricción `UNIQUE` en `inscripciones` para impedir que un desarrollador se inscriba dos veces al mismo módulo.

5. Se usó `InnoDB` para soportar claves foráneas y transacciones.

## Scripts

- DDL: `sql/01_ddl/`
- DML: `sql/02_dml/`
- DQL: `sql/03_dql/`
- Prácticas REVIEW: `sql/04_review/`

## Commits

Se recomienda hacer un commit por cada tabla:

- `feat(desarrolladores): agrega DDL y DML de desarrolladores`
- `feat(modulos): agrega DDL y DML de módulos`
- `feat(tecnologias): agrega DDL y DML de tecnologías`
- `feat(modulo_tecnologia): agrega DDL y DML de relación módulo-tecnología`
- `feat(inscripciones): agrega DDL y DML de inscripciones`

## Conclusión

La base de datos quedó normalizada hasta 4FN y lista para ser usada en MySQL Workbench. Además, se prepararon scripts para practicar procedimientos, funciones, triggers, eventos, particiones, consultas preparadas y usuarios.