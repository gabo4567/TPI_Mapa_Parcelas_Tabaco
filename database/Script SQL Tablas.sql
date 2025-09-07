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
