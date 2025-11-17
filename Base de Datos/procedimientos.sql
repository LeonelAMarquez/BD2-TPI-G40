USE SistemaPedidos
GO

CREATE PROCEDURE sp_ReporteProveedorDetalle(
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

----------------------------------------------------------------------------------------------------------------------------------

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

SELECT 
    id_pedido,
    id_cliente,
    estado,
    fecha_pedido
FROM Pedido 
ORDER BY id_pedido;
GO

EXEC SP_CambiarEstadoPedido 5, 'Procesando';
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

SELECT 
    p.id_producto,
    p.nombre,
    s.cantidad as stock_actual,
    s.fecha_actualizacion
FROM Producto p
INNER JOIN Stock s ON p.id_producto = s.id_producto
WHERE p.id_producto = 1;
GO

EXEC SP_ReponerStock @id_producto = 1, @cantidad = 5;
GO

-----------------------------------------------------------------------------------------------------------------------------------------

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
