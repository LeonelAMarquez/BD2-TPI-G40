USE SistemaPedidos
GO

CREATE PROCEDURE sp_ReporteProeedorDetalle(
    @id_proveedor INT
)
AS
BEGIN
    SELECT PR.nombre_Proveedor,
           P.id_producto,
           P.nombre AS Producto,
           S.cantidad AS stock_actual,
           ISNULL(SUM(DP.cantidad), 0) AS Unidades_vendidas,
           ISNULL(SUM(DP.subtotal), 0) AS total_facturado
    FROM Proveedor PR
    INNER JOIN Producto P ON PR.id_proveedor = P.id_proveedor
    LEFT JOIN Stock S ON P.id_producto = S.id_producto
    LEFT JOIN DetalleDelPedido DP ON P.id_producto = DP.id_producto
    WHERE PR.id_proveedor = @id_proveedor
    GROUP BY PR.nombre_proveedor, P.id_producto, P.nombre, S.cantidad;
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
CREATE PROCEDURE ActualizaPrecioDeProducto
    @id_producto INT,
    @nuevo_precio DECIMAL(10,2)
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('El producto no existe.', 16, 1);
        RETURN;
    END
    
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

-- Procedimiento para actualizar el estado de un pedido
CREATE PROCEDURE ActualizarEstadoPedido
    @id_pedido INT,
    @empresa NVARCHAR(100),
    @numero_guia NVARCHAR(50),
    @estado NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pedido WHERE id_pedido = @id_pedido)
    BEGIN
        RAISERROR('El pedido ingresado no existe.', 16, 1);
        RETURN;
    END

    IF @estado NOT IN ('Devuelto', 'Entregado', 'Enviado', 'En Proceso')
    BEGIN
        RAISERROR('Estado inválido. Debe ser: Devuelto, Entregado, Enviado o En Proceso.', 16, 1);
        RETURN;
    END
    
    INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio, fecha_envio)
    VALUES (@id_pedido, @empresa, @numero_guia, @estado, GETDATE());

    UPDATE Pedido
    SET estado = @estado
    WHERE id_pedido = @id_pedido;

    SELECT 'Estado del pedido modificado.' AS mensaje;
END;
GO
