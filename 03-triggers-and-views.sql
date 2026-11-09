USE PROYECTO_POS;
GO

-- =========================================================================
-- 1. TRIGGERS OPERATIVOS (AUTOMATIZACIÓN Y MANEJO DE ERRORES)
-- =========================================================================

-- Trigger: Actualización automática de stock con prevención de inventario negativo
CREATE TRIGGER ActualizarStockManejoErrores
ON DetallesVentas
AFTER INSERT
AS
BEGIN
	BEGIN TRY
		-- Actualizar el stock reduciendo la cantidad vendida
		UPDATE Productos
		SET stock = Productos.stock - i.cantidad
		FROM Productos
		INNER JOIN inserted i ON i.ID_producto = Productos.ID_producto;

		-- Validación crítica: Comprobar inconsistencias de stock negativo
		IF EXISTS (SELECT 1 FROM Productos WHERE stock < 0)
		BEGIN
			RAISERROR ('Error Operativo: Stock negativo detectado en el inventario.', 16, 1);
			ROLLBACK TRANSACTION;
		END
	END TRY
	BEGIN CATCH
		PRINT 'Se ha producido un error al actualizar el stock: ' + ERROR_MESSAGE();
		ROLLBACK TRANSACTION;
	END CATCH;
END;
GO

-- Trigger: Prevenir la eliminación de clientes con historial de transacciones activo
CREATE TRIGGER PrevenirEliminacionCliente
ON Clientes
INSTEAD OF DELETE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Ventas WHERE Ventas.ID_cliente IN (SELECT ID_cliente FROM deleted))
	BEGIN
		PRINT 'Restricción Comercial: No se puede eliminar el cliente porque tiene ventas históricas asociadas.';
	END
	ELSE
	BEGIN
		DELETE FROM Clientes WHERE ID_cliente IN (SELECT ID_cliente FROM deleted);
	END
END;
GO

-- =========================================================================
-- 2. INFRAESTRUCTURA DE AUDITORÍA EMPRESARIAL
-- =========================================================================
CREATE TABLE AuditoriaVentas (
	ID_auditoria INT PRIMARY KEY IDENTITY(1,1),
	ID_venta INT,
	fecha_cambio DATETIME,
	antiguo_total DECIMAL(12,2),
	nuevo_total DECIMAL(12,2)
);
GO

-- Trigger: Registro histórico automático de cambios financieros en las ventas
CREATE TRIGGER RegistrarCambiosVentas
ON Ventas
AFTER UPDATE
AS
BEGIN
	INSERT INTO AuditoriaVentas (ID_venta, fecha_cambio, antiguo_total, nuevo_total)
	SELECT
		d.ID_venta,
		GETDATE(),
		d.total,
		i.total
	FROM deleted d
	INNER JOIN inserted i ON i.ID_venta = d.ID_venta;
END;
GO
