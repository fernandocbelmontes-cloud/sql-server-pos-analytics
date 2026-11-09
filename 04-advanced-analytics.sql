USE PROYECTO_POS;
GO

-- =========================================================================
-- 1. MÉTRICAS OPERATIVAS GLOBALES Y FUNCIONES NATIVAS
-- =========================================================================
SELECT SUM(total) AS TotalIngresos FROM Ventas;
SELECT AVG(precio) AS PrecioPromedio FROM Productos;
SELECT COUNT(*) AS TotalClientes FROM Clientes;
SELECT MIN(precio) AS PrecioMinimo, MAX(precio) AS PrecioMaximo FROM Productos;

-- Análisis de Fechas e Intervalos Operativos
SELECT fecha, DATEADD(DAY, 30, fecha) AS FechaVencimientoFactura FROM Ventas;
SELECT fecha, DATEDIFF(DAY, fecha, GETDATE()) AS DiasTranscurridosDesdeVenta FROM Ventas;
SELECT fecha, FORMAT(fecha, 'dd/MM/yyyy') AS FechaFormatoEstandar FROM Ventas;

-- Manipulación Avanzada de Cadenas y Funciones Matemáticas
SELECT nombre, LEN(nombre) AS LongitudCaracteres, UPPER(nombre) AS NombreMayuscula FROM Productos;
SELECT CONCAT(nombre, ' - ', descripcion) AS CatalogoProductoDetallado FROM Productos;
SELECT precio, ABS(precio - 100) AS DesviacionAbsoluta, ROUND(precio, 1) AS PrecioRedondeado REAL FROM Productos;

-- =========================================================================
-- 2. SUBCONSULTAS AVANZADAS, FILTROS COMPLEJOS Y AGREGACIONES
-- =========================================================================

-- Análisis de Productos con Ventas de Alta Densidad (Uso de EXISTS correlacionado)
SELECT nombre, precio
FROM Productos p
WHERE EXISTS (
	SELECT 1 
	FROM DetallesVentas dv 
	WHERE dv.ID_producto = p.ID_producto AND dv.cantidad > 1
);

-- Subconsultas Derivadas: Agregación de Ventas Totales por Perfil de Cliente
SELECT 
	c.nombre AS Cliente,
	VentasTotales.TotalVentas
FROM Clientes c
INNER JOIN (
	SELECT ID_cliente, SUM(total) AS TotalVentas
	FROM Ventas
	GROUP BY ID_cliente
) AS VentasTotales ON c.ID_cliente = VentasTotales.ID_cliente;

-- Filtrado Avanzado por Agregación Directa (HAVING)
SELECT 
	p.nombre AS NombreProducto,
	SUM(dv.cantidad) AS TotalUnidadesVendidas
FROM Productos p
INNER JOIN DetallesVentas dv ON dv.ID_producto = p.ID_producto
GROUP BY p.nombre
HAVING SUM(dv.cantidad) > 1;

-- =========================================================================
-- 3. COMMON TABLE EXPRESSIONS (CTE) Y ESTRUCTURAS JERÁRQUICAS (RECURSIVAS)
-- =========================================================================

-- Creación del Entorno Jerárquico de Categorías
CREATE TABLE Categorias (
	ID INT PRIMARY KEY,
	Nombre NVARCHAR(100) NOT NULL,
	ID_Padre INT NULL
);

INSERT INTO Categorias (ID, Nombre, ID_Padre) VALUES
	(1, 'Electrónica', NULL),
	(2, 'Computadoras', 1),
	(3, 'Teléfonos', 1),
	(4, 'Laptops', 2),
	(5, 'Escritorios', 2),
	(6, 'Smartphones', 3),
	(7, 'Accesorios', 3);
GO

-- CTE Recursiva para Mapeo de Niveles Organizacionales de Inventario
WITH CategoriaJerarquica AS (
	-- Miembro Ancla: Categorías Raíz
	SELECT ID, Nombre, ID_Padre, 1 AS Nivel
	FROM Categorias
	WHERE ID_Padre IS NULL

	UNION ALL

	-- Miembro Recursivo: Subcategorías vinculadas al nivel superior
	SELECT c.ID, c.Nombre, c.ID_Padre, cj.Nivel + 1
	FROM Categorias c
	INNER JOIN CategoriaJerarquica cj ON cj.ID = c.ID_Padre
)
SELECT ID, Nombre, ID_Padre, Nivel
FROM CategoriaJerarquica
ORDER BY Nivel, ID;
GO
