-- -----------------------------------------------------
-- Base de datos Electrosurr_jvl para el portal de permisos
-- Compatible con MySQL 8.x
-- -----------------------------------------------------

DROP DATABASE IF EXISTS Electrosurr_jvl;
CREATE DATABASE Electrosurr_jvl CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Electrosurr_jvl;

-- -----------------------------------------------------
-- Tabla: area
-- -----------------------------------------------------
DROP TABLE IF EXISTS area;
CREATE TABLE area (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) DEFAULT NULL,
    jefe_area_id INT DEFAULT NULL,
    UNIQUE KEY uk_area_nombre (nombre)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Tabla: empleado
-- -----------------------------------------------------
DROP TABLE IF EXISTS empleado;
CREATE TABLE empleado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    documento VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    password VARCHAR(120) NOT NULL,
    rol ENUM('EMPLEADO', 'JEFE_AREA', 'JEFE_RRHH') NOT NULL DEFAULT 'EMPLEADO',
    area_id INT DEFAULT NULL,
    horas_acumuladas DECIMAL(6, 2) NOT NULL DEFAULT 0.00,
    reincidente TINYINT(1) NOT NULL DEFAULT 0,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_empleado_documento (documento),
    UNIQUE KEY uk_empleado_correo (correo),
    KEY idx_empleado_area (area_id),
    CONSTRAINT fk_empleado_area FOREIGN KEY (area_id)
        REFERENCES area (id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Tabla: permiso
-- -----------------------------------------------------
DROP TABLE IF EXISTS permiso;
CREATE TABLE permiso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT NOT NULL,
    fecha_permiso DATE NOT NULL,
    hora_salida TIME NOT NULL,
    fecha_retorno DATE NOT NULL,
    hora_retorno TIME NOT NULL,
    motivo VARCHAR(500) NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE_JEFE',
    observaciones VARCHAR(500) NOT NULL DEFAULT '',
    firmado_jefe_area TINYINT(1) NOT NULL DEFAULT 0,
    firmado_rrhh TINYINT(1) NOT NULL DEFAULT 0,
    marcado_reincidente TINYINT(1) NOT NULL DEFAULT 0,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_permiso_empleado FOREIGN KEY (empleado_id)
        REFERENCES empleado (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Llave foránea circular: jefe de área
-- Se agrega tras crear la tabla empleado para evitar errores de orden
-- -----------------------------------------------------
ALTER TABLE area
    ADD CONSTRAINT fk_area_jefe
    FOREIGN KEY (jefe_area_id)
    REFERENCES empleado (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- -----------------------------------------------------
-- Datos de referencia
-- -----------------------------------------------------
INSERT INTO area (nombre, descripcion) VALUES
    ('Ventas', 'Área encargada de la atención al cliente y ventas de electrodomésticos'),
    ('Operaciones', 'Área encargada de la supervisión técnica y logística');

INSERT INTO empleado (nombres, apellidos, documento, correo, password, rol, area_id, horas_acumuladas, reincidente) VALUES
    ('Carlos', 'Pérez Ramos', '12345678', 'carlos.perez@electrosurr.com', '123456', 'EMPLEADO', 1, 12.50, 0),
    ('María', 'López Díaz', '87654321', 'maria.lopez@electrosurr.com', '123456', 'JEFE_AREA', 1, 4.00, 0),
    ('Luis', 'García Torres', '45678912', 'luis.garcia@electrosurr.com', '123456', 'JEFE_RRHH', NULL, 8.00, 0),
    ('Ana', 'Torres Meza', '78912345', 'ana.torres@electrosurr.com', '123456', 'EMPLEADO', 2, 35.75, 1);

-- Asociar jefe de área a la tabla área
UPDATE area SET jefe_area_id = 2 WHERE id = 1;
UPDATE area SET jefe_area_id = NULL WHERE id = 2;

-- Solicitudes de permiso de ejemplo
INSERT INTO permiso (empleado_id, fecha_permiso, hora_salida, fecha_retorno, hora_retorno, motivo, estado, observaciones, firmado_jefe_area, firmado_rrhh, marcado_reincidente)
VALUES
    (1, '2024-07-15', '08:00:00', '2024-07-15', '12:00:00', 'Cita médica programada', 'PENDIENTE_JEFE', '', 0, 0, 0),
    (1, '2024-06-05', '14:00:00', '2024-06-05', '17:00:00', 'Trámite personal en entidad pública', 'APROBADO_JEFE', 'Aprobado por disponibilidad', 1, 0, 0),
    (4, '2024-05-20', '09:00:00', '2024-05-20', '13:00:00', 'Asistencia a capacitación externa', 'DENEGADO_JEFE', 'No se justificó la necesidad', 1, 0, 1),
    (4, '2024-04-10', '07:30:00', '2024-04-10', '11:30:00', 'Atención médica familiar', 'RECHAZADO_EJECUCION', 'Incumplió hora de retorno', 1, 1, 1);

-- Actualizar firmas para reflejar el flujo del ejemplo
UPDATE permiso SET firmado_rrhh = 1 WHERE estado IN ('APROBADO_RRHH', 'DENEGADO_RRHH', 'RECHAZADO_EJECUCION');

