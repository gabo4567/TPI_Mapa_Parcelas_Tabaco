DROP DATABASE IF EXISTS mapa_tabaco;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS mapa_tabaco;
USE mapa_tabaco;

-- Tabla de usuarios (productores)
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20)
);

-- Tabla de parcelas
CREATE TABLE parcela (
    id_parcela INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    ubicacion_geo TEXT NOT NULL, -- coordenadas o polígono en formato JSON
    superficie DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla de campañas (historial por año)
CREATE TABLE campania (
    id_campania INT AUTO_INCREMENT PRIMARY KEY,
    id_parcela INT NOT NULL,
    anio INT NOT NULL,
    FOREIGN KEY (id_parcela) REFERENCES parcela(id_parcela)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla de tareas agrícolas
CREATE TABLE tarea (
    id_tarea INT AUTO_INCREMENT PRIMARY KEY,
    id_campania INT NOT NULL,
    tipo ENUM('siembra', 'fertilizacion', 'fumigacion', 'curado', 'cosecha') NOT NULL,
    fecha DATE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (id_campania) REFERENCES campania(id_campania)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla de producción por campaña/parcela
CREATE TABLE produccion (
    id_produccion INT AUTO_INCREMENT PRIMARY KEY,
    id_campania INT NOT NULL UNIQUE,
    rendimiento_kg DECIMAL(10,2),
    calidad VARCHAR(50),
    notas TEXT,
    FOREIGN KEY (id_campania) REFERENCES campania(id_campania)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla de notificaciones / recordatorios
CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_envio DATETIME NOT NULL,   -- fecha y hora en que se enviará la notificación
    tipo ENUM('recordatorio', 'alerta', 'info') DEFAULT 'recordatorio',
    leido BOOLEAN DEFAULT FALSE,     -- para marcar si el usuario ya vio la notificación
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- REGISTROS DE EJEMPLO
-- =========================================

-- Usuarios
INSERT INTO usuario (nombre, email, contrasena, telefono) VALUES
('Juan Pérez', 'juanperez@example.com', 'contrasena123', '3777-123456'),
('María López', 'marialopez@example.com', 'contrasena456', '3777-654321');

-- Parcelas
INSERT INTO parcela (id_usuario, nombre, ubicacion_geo, superficie) VALUES
(1, 'Parcela Norte', '{"coordenadas":[{"lat":-29.1478,"lng":-59.2679},{"lat":-29.1480,"lng":-59.2681},{"lat":-29.1475,"lng":-59.2683},{"lat":-29.1478,"lng":-59.2679}]}', 2.5),
(2, 'Parcela Sur', '{"coordenadas":[{"lat":-29.1500,"lng":-59.2650},{"lat":-29.1502,"lng":-59.2655},{"lat":-29.1498,"lng":-59.2657},{"lat":-29.1500,"lng":-59.2650}]}', 3.0);

-- Campañas
INSERT INTO campania (id_parcela, anio) VALUES
(1, 2024),
(2, 2024);

-- Tareas agrícolas
INSERT INTO tarea (id_campania, tipo, fecha, descripcion) VALUES
(1, 'siembra', '2024-03-01', 'Siembra de tabaco Virginia'),
(1, 'fertilizacion', '2024-03-15', 'Aplicación de fertilizante NPK'),
(2, 'siembra', '2024-03-05', 'Siembra de tabaco Burley'),
(2, 'fumigacion', '2024-04-01', 'Fumigación contra plagas');

-- Producción
INSERT INTO produccion (id_campania, rendimiento_kg, calidad, notas) VALUES
(1, 1500.50, 'Alta', 'Buen rendimiento en la parcela norte'),
(2, 1200.75, 'Media', 'Algunas plantas afectadas por plagas');

-- Notificaciones
INSERT INTO notificacion (id_usuario, mensaje, fecha_envio, tipo, leido) VALUES
(1, 'Recordatorio: Fertilización pendiente en Parcela Norte', '2024-03-14 08:00:00', 'recordatorio', FALSE),
(2, 'Alerta: Fumigación en Parcela Sur programada mañana', '2024-03-31 07:00:00', 'alerta', FALSE);
