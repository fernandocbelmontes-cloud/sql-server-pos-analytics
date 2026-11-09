USE PROYECTO_POS;
GO

-- =========================================================================
-- 1. PROCEDIMIENTOS ALMACENADOS (ENCAPSULAMIENTO DE LÓGICA)
-- =========================================================================

-- Procedimiento: Buscar productos con stock mínimo operativo
CREATE PROC BuscarProductos
AS
BEGIN
	SELECT ID_producto, nombre, descripcion, precio, stock
	FROM Productos
	WHERE stock > 10;
END;
GO

-- Procedimiento: Insertar nuevos productos de forma estandarizada
CREATE PROC AgregarProducto
	@nombre VARCHAR(50),
	@descripcion VARCHAR(100),
	@precio DECIMAL(12,2),
	@stock INT
AS
BEGIN
	INSERT INTO Productos (nombre, descripcion, precio, stock)
	VALUES (@nombre, @descripcion, @precio, @stock);
END;
GO

-- Procedimiento: Obtener stock disponible con parámetros de salida (OUTPUT)
CREATE PROC ObtenerStockProducto
	@ID_producto INT,
	@stock INT OUTPUT
AS
BEGIN
	SELECT @stock = stock
	FROM Productos
	WHERE ID_producto = @ID_producto;
END;
GO

-- =========================================================================
-- 2. TRANSACCIONES COMPLEJAS (INTEGRIDAD DE DATOS EN VENTAS)
-- =========================================================================
BEGIN TRANSACTION;
BEGIN TRY
	-- Registrar cabecera de la venta
	INSERT INTO Ventas (ID_cliente, fecha, total)
	VALUES (2, GETDATE(), 300.00);

	-- Capturar el ID de la venta generado dinámicamente
	DECLARE @ID_venta INT;
	SET @ID_venta = SCOPE_IDENTITY();

	-- Registrar el detalle de la venta vinculado al ID capturado
	INSERT INTO DetallesVentas (ID_venta, ID_producto, cantidad, precio)
	VALUES (@ID_venta, 1, 2, 150.00);

	-- Actualizar el inventario operativo de forma síncrona
	UPDATE Productos
	SET stock = stock - 2
	WHERE ID_producto = 1;

	-- Si todo se ejecuta sin errores, confirmar la transacción permanentemente
	COMMIT TRANSACTION;
	PRINT 'Transacción de venta confirmada exitosamente.';
END TRY
BEGIN CATCH
	-- Si ocurre algún fallo en el bloque, deshacer todos los cambios relacionales
	ROLLBACK TRANSACTION;
	PRINT 'Error detectado en la venta. Se ha ejecutado un ROLLBACK de seguridad.';
END CATCH;
GO
