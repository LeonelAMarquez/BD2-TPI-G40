--Leo

--Triggers (En prueba)

--Trigger para actualizar stock automáticamente
CREATE TRIGGER TR_ActualizarStock
ON DetalleDelPedido
AFTER INSERT
AS
BEGIN
    UPDATE s 
    SET s.cantidad = s.cantidad - i.cantidad,
        s.fecha_actualizacion = GETDATE()
    FROM Stock s
    INNER JOIN inserted i ON s.id_producto = i.id_producto;
END;
GO

--Trigger para validar stock antes de un pedido
CREATE TRIGGER TR_ValidarStock
ON DetalleDelPedido
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT i.id_producto
        FROM inserted i
        INNER JOIN Stock s ON i.id_producto = s.id_producto
        WHERE i.cantidad > s.cantidad
    )
    BEGIN
        RAISERROR('Stock insuficiente para uno o mas productos', 16, 1);
        RETURN;
    END
    INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario)
    SELECT id_pedido, id_producto, cantidad, precio_unitario
    FROM inserted;
END;
GO

--Vistas (No finales)

--Vista de inventario con información completa
CREATE VIEW VW_InventarioCompleto AS
SELECT 
    p.id_producto,
    p.nombre,
    p.descripcion,
    p.precio,
    s.cantidad,
    s.fecha_actualizacion,
    prov.nombre_proveedor,
    prov.telefono as telefono_proveedor,
    CASE 
        WHEN s.cantidad = 0 THEN 'Sin Stock'
        WHEN s.cantidad < 10 THEN 'Stock Bajo'
        ELSE 'Stock Normal'
    END as estado_stock
FROM Producto p
INNER JOIN Stock s ON p.id_producto = s.id_producto
INNER JOIN Proveedor prov ON p.id_proveedor = prov.id_proveedor;
GO

--Vista de pedidos con informacion completa
CREATE VIEW VW_PedidosCompletos AS
SELECT 
    ped.id_pedido,
    c.nombre + ' ' + c.apellido as cliente,
    c.ciudad,
    ped.fecha_pedido,
    ped.estado,
    ped.total,
    pag.metodo_pago,
    pag.monto as monto_pagado,
    log.empresa_transporte,
    log.estado_envio
FROM Pedido ped
INNER JOIN Cliente c ON ped.id_cliente = c.id_cliente
LEFT JOIN Pagos pag ON ped.id_pedido = pag.id_pedido
LEFT JOIN Logistica log ON ped.id_pedido = log.id_pedido;
GO

--Vista de ventas por producto
CREATE VIEW VW_VentasPorProducto AS
SELECT 
    p.id_producto,
    p.nombre,
    prov.nombre_proveedor,
    SUM(det.cantidad) as total_vendido,
    SUM(det.subtotal) as ingresos_totales,
    AVG(det.precio_unitario) as precio_promedio
FROM Producto p
INNER JOIN DetalleDelPedido det ON p.id_producto = det.id_producto
INNER JOIN Proveedor prov ON p.id_proveedor = prov.id_proveedor
INNER JOIN Pedido ped ON det.id_pedido = ped.id_pedido
WHERE ped.estado != 'Cancelado'
GROUP BY p.id_producto, p.nombre, prov.nombre_proveedor;
GO

CREATE TYPE DetallePedidoType AS TABLE (
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2)
);
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