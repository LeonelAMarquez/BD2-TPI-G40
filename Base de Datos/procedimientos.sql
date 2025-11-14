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

--Procedure para crear nuevo pedido
CREATE PROCEDURE SP_CrearPedidoBasico
    @id_cliente INT,
    @id_producto1 INT = NULL, @cantidad1 INT = NULL,
    @id_producto2 INT = NULL, @cantidad2 INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;
    
    INSERT INTO Pedido (id_cliente, estado) 
    VALUES (@id_cliente, 'Pendiente');
    
    DECLARE @nuevo_pedido INT = SCOPE_IDENTITY();
    
    IF @id_producto1 IS NOT NULL
        INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario)
        SELECT @nuevo_pedido, @id_producto1, @cantidad1, precio
        FROM Producto WHERE id_producto = @id_producto1;
    
    IF @id_producto2 IS NOT NULL
        INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario)
        SELECT @nuevo_pedido, @id_producto2, @cantidad2, precio
        FROM Producto WHERE id_producto = @id_producto2;
    
    COMMIT TRANSACTION;
    SELECT 'Pedido ' + CAST(@nuevo_pedido AS VARCHAR(10)) + ' creado' as resultado;
END;
GO

-- Procedure para cambiar estado de pedido
CREATE PROCEDURE SP_CambiarEstadoPedido
    @id_pedido INT,
    @nuevo_estado NVARCHAR(50)
AS
BEGIN
    UPDATE Pedido 
    SET estado = @nuevo_estado 
    WHERE id_pedido = @id_pedido;
    
    IF @@ROWCOUNT > 0
        SELECT 'Estado actualizado correctamente' as mensaje;
    ELSE
        SELECT 'Pedido no encontrado' as mensaje;
END;
GO

--Procedure para buscar clientes por ciudad
CREATE PROCEDURE SP_BuscarClientesPorCiudad
    @ciudad NVARCHAR(100) = NULL
AS
BEGIN
    SELECT 
        id_cliente,
        nombre + ' ' + apellido as nombre_completo,
        email,
        telefono,
        ciudad
    FROM Cliente
    WHERE (@ciudad IS NULL OR ciudad = @ciudad)
    ORDER BY nombre, apellido;
END;
GO

--Procedure para reponer stock
CREATE PROCEDURE SP_ReponerStock
    @id_producto INT,
    @cantidad INT
AS
BEGIN
    UPDATE Stock 
    SET cantidad = cantidad + @cantidad,
        fecha_actualizacion = GETDATE()
    WHERE id_producto = @id_producto;
    
    SELECT 'Stock actualizado: ' + CAST(@cantidad AS VARCHAR(10)) + ' unidades agregadas' as resultado;
END;
GO

-- Procedimiento para actualizar el precio de algun producto
CREATE PROCEDURE ActualizarPrecioProducto
    @id_producto INT,
    @nuevo_precio DECIMAL(10,2)
AS
BEGIN
    IF @nuevo_precio <= 0
    BEGIN
        RAISERROR('El precio debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    UPDATE Producto
    SET precio = @nuevo_precio
    WHERE id_producto = @id_producto;

    SELECT 'Precio actualizado correctamente.' AS mensaje;
END;
GO

-- Procedimiento para registrar el envio de un producto
CREATE PROCEDURE RegistrarEnvio
    @id_pedido INT,
    @empresa NVARCHAR(100),
    @numero_guia NVARCHAR(50)
AS
BEGIN
    INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio, fecha_envio)
    VALUES (@id_pedido, @empresa, @numero_guia, 'Enviado', GETDATE());

    UPDATE Pedido
    SET estado = 'Enviado'
    WHERE id_pedido = @id_pedido;

    SELECT 'Envio registrado y pedido marcado como Enviado.' AS mensaje;
END;
GO