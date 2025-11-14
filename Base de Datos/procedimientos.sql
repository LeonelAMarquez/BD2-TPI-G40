USE SistemaPedidos
GO

--procedimiento almacenado registrar pago
CREATE PROCEDURE sp_RegistrarPago(
	@id_pedido INT,
	@monto DECIMAL(10,2),
	@metodo_pago NVARCHAR(50)
)
AS
BEGIN
	
	BEGIN TRY
		BEGIN TRANSACTION;
			-- 1. Validacion de si el pedido existe
			IF NOT EXISTS (SELECT 1 FROM Pedido WHERE id_pedido = @id_pedido)
				RETURN;

		    -- 2. Insert del pago
			INSERT INTO Pagos(id_pedido, monto, fecha_pago, metodo_pago)
			VALUES(@id_pedido, @monto, GETDATE(), @metodo_pago);

			-- 3. Consultar total del pedido
			DECLARE @totalPedido DECIMAL(12,2);
			DECLARE @totalPagado DECIMAL(12,2);

			SELECT @totalPedido = total FROM Pedido WHERE id_pedido = @id_pedido;
			SELECT @totalPagado = SUM(monto) FROM Pagos WHERE id_pedido = @id_pedido;

			-- 4. Actualizacio del estado
			IF @totalPagado >= @totalPedido
			BEGIN
				UPDATE Pedido SET estado = 'Entregado' WHERE id_pedido = @id_pedido;	
			END
			ELSE BEGIN
				UPDATE Pedido SET estado = 'Procesando' WHERE id_pedido = @id_pedido;
			END;

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		RAISERROR('NO SE PUDO REGITRAR EL PAGO.', 16, 1);
	END CATCH;

END;
go

-- procedimiento almacendo para registrar las ventas en un periodo de dos fechas
CREATE PROCEDURE sp_ReporteVentasPorPeriodo(
    @fechaInicio DATE,
    @fechaFin DATE
)
AS
BEGIN
    SELECT
    C.nombre + ' ' + C.apellido AS Cliente,
    P.id_pedido, P.fecha_pedido,
    P.total,
    SUM(DP.cantidad) AS CantidadProductos
    FROM Cliente C
    INNER JOIN Pedido P ON C.id_cliente = P.id_cliente
    INNER JOIN DetalleDelPedido DP ON P.id_pedido = DP.id_pedido
    WHERE P.fecha_pedido BETWEEN @fechaInicio AND @fechaFin
    GROUP BY C.nombre, C.apellido, P.id_pedido, P.fecha_pedido, P.total
    ORDER BY P.fecha_pedido ASC;
END;
go

-----------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_AgregarProductoBebida
    @nombre NVARCHAR(150),
    @descripcion NVARCHAR(255),
    @precio DECIMAL(10,2),
    @marca NVARCHAR(50),
    @id_proveedor INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar marca permitida
    IF UPPER(@marca) NOT IN ('INCA', 'BAGGIO', 'SIDRA', 'SIDRAS')
    BEGIN
        PRINT 'Marca no permitida. Solo se aceptan INCA, BAGGIO o SIDRAS.';
        RETURN;
    END;

    -- Validar proveedor existente
    IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        PRINT 'El proveedor especificado no existe.';
        RETURN;
    END;

    -- Insertar nuevo producto
    INSERT INTO Producto (nombre, descripcion, precio, id_proveedor)
    VALUES (@nombre, @descripcion, @precio, @id_proveedor);

    DECLARE @nuevo_id INT = SCOPE_IDENTITY();

    -- Crear registro en tabla Stock
    INSERT INTO Stock (id_producto, cantidad)
    VALUES (@nuevo_id, 0);

    PRINT 'Producto agregado correctamente: ' + @nombre + ' (' + @marca + ')';
END;
GO
