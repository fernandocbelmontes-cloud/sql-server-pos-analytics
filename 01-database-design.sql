-- =========================================================================
-- 1. BASE DE DATOS Y ESTRUCTURAS RELACIONALES (DDL)
-- =========================================================================
CREATE DATABASE PROYECTO_POS;
GO
USE PROYECTO_POS;
GO

-- Creación de Tabla: Productos
CREATE TABLE Productos (
	ID_producto INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(100),
	precio DECIMAL(12,2) NOT NULL,
	stock INT NOT NULL
);

-- Creación de Tabla: Clientes
CREATE TABLE Clientes (
	ID_cliente INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(30) NOT NULL,
	email VARCHAR(50),
	ciudad VARCHAR(50)
);

-- Creación de Tabla: Ventas
CREATE TABLE Ventas (
	ID_venta INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_cliente INT NOT NULL,
	fecha DATETIME NOT NULL,
	total DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_VentasClientes FOREIGN KEY (ID_cliente) REFERENCES Clientes(ID_cliente)
);

-- Creación de Tabla: DetallesVentas
CREATE TABLE DetallesVentas (
	ID_detalle INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_venta INT NOT NULL,
	ID_producto INT NOT NULL,
	cantidad INT NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_DetalleVenta FOREIGN KEY (ID_venta) REFERENCES Ventas(ID_venta),
	CONSTRAINT FK_DetalleProducto FOREIGN KEY (ID_producto) REFERENCES Productos(ID_producto)
);
GO

-- =========================================================================
-- 2. POBLACIÓN DE DATOS (DML)
-- =========================================================================
INSERT INTO Productos (nombre, descripcion, precio, stock) VALUES
	('Laptop', 'Laptop de 15 pulgadas', 1500.00, 20),
	('Mouse', 'Mouse inalambrico', 50.00, 20),
	('Teclado', 'Teclado mecánico', 60.00, 14),
	('Monotor', 'Monotor de 24 pulgadas', 50.00, 20),
	('Impresora', 'Impresora láser', 300.00, 15),
	('Escáner', 'Escáner de documentos', 150.00, 25),
	('Mochila', 'Mochila para laptop', 45.00, 40),
	('Auriculares', 'Auriculares con cancelación de ruido', 80.00, 35),
	('Cámara', 'Cámara digital', 400.00, 10),
	('Proyector', 'Proyector portátil', 500.00, 5);

INSERT INTO Clientes (nombre, direccion, telefono, email, ciudad) VALUES
	('Juan Pérez', 'Calle falsa 123', '555-1234', 'juan@example.com', 'Ciudad de México'),
	('María López', 'Avenida Siempreviva 456', '555-5678', 'maria@exemplo.com', 'Bogotá'),
	('Carlos García', 'Boulevard de los Sueños 789', '555-9012', 'carlos@exemplo.com', 'Medellín'),
	('Ana Torres', 'Camino Real 321', '555-3456', 'ana@exemplo.com', 'Buenos Aires'),
	('Pedro Martínez', 'Plaza Central 1', '555-6789', 'pedro@exemplo.com', 'Caracas'),
	('Laura Fernández', 'Calle Luna 99', '555-4321', 'laura@exemplo.com', 'Lima'),
	('Sofía Ruiz', 'Avenida Libertad 45', '555-1122', 'sofia@exemplo.com', 'Caracas'),
	('Diego Jiménez', 'Calle Sol 33', '555-3344', 'diego@exemplo.com', 'Cancún'),
	('Cristina Gómez', 'Camino Viejo 77', '555-5566', 'cristina@exemplo.com', 'Bogotá'),
	('Roberto Díaz', 'Calle Mar 22', '555-7788', 'roberto@exemplo.com', 'Ciudad de México'),
	('Lucio Piñeros', 'Calle Central 23', '5665-5454', 'Lucio@exemplo.com', 'Bogotá');

INSERT INTO Ventas (ID_cliente, fecha, total) VALUES
	(2, '2024-07-15', 1725.00),
	(2, '2024-07-16', 125.00),
	(3, '2024-07-17', 275.00),
	(4, '2024-07-18', 450.00),
	(5, '2024-07-19', 650.00),
	(6, '2024-07-20', 820.00),
	(7, '2024-07-21', 910.00),
	(8, '2024-07-22', 230.00),
	(9, '2024-07-23', 180.00),
	(10, '2024-07-24', 300.00);

INSERT INTO DetallesVentas (ID_venta, ID_producto, cantidad, precio) VALUES
	(1, 1, 1, 1500.00),
	(1, 2, 1, 25.00),
	(2, 2, 2, 25.00),
	(3, 3, 3, 75.00),
	(4, 4, 1, 200.00),
	(5, 5, 1, 300.00),
	(6, 6, 1, 150.00),
	(7, 7, 1, 45.00),
	(8, 8, 1, 80.00),
	(9, 9, 1, 400.00);
GO
