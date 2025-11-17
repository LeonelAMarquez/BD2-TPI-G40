USE SistemaPedidos
GO

--Trigger para actualizar stock automaticamente

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

SELECT 
    p.id_producto,
    p.nombre,
    s.cantidad as stock_actual,
    s.fecha_actualizacion
FROM Producto p
INNER JOIN Stock s ON p.id_producto = s.id_producto
WHERE p.id_producto = 1;
GO

INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario)
VALUES (4, 1, 5, 120.5); 
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

SELECT 
    p.id_producto,
    p.nombre,
    s.cantidad as stock_actual
FROM Producto p
INNER JOIN Stock s ON p.id_producto = s.id_producto
WHERE p.id_producto IN (1, 2, 15)
ORDER BY p.id_producto;
GO

BEGIN TRY
    INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario)
    VALUES (1, 1, 200, 120.5); 
    
    SELECT 'Inserción exitosa' as resultado;
END TRY
BEGIN CATCH
    SELECT 
        'Error: ' + ERROR_MESSAGE() as resultado
END CATCH;
GO

INSERT INTO Pedido (id_cliente, estado) VALUES (7, 'Pendiente');
DECLARE @pedido_prueba INT = SCOPE_IDENTITY();

BEGIN TRY
    INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario)
    VALUES (@pedido_prueba, 2, 5, 118.0); 
    
    SELECT 'Insercion exitosa - Stock suficiente' as resultado;
    
    SELECT * FROM DetalleDelPedido WHERE id_pedido = @pedido_prueba;
END TRY
BEGIN CATCH
    SELECT 'Error: ' + ERROR_MESSAGE() as resultado;
END CATCH;
GO

------------------------------------------------------------------------------------------------------------

-- Trigger que alerta cuando hay un stock bajo del producto
CREATE TRIGGER AlertarBajoStock
ON Stock
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE cantidad < 5
    )
    BEGIN
        PRINT 'ALERTA: El stock de un producto bajó a menos de 5 unidades.';
    END
END;
GO

-- Trigger que calcula el total del pedido al ingresar los datos
CREATE TRIGGER TR_CalcularTotalPedido
ON DetalleDelPedido
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET total = (
        SELECT SUM(subtotal)
        FROM DetalleDelPedido
        WHERE id_pedido = p.id_pedido
    )
    FROM Pedido p
    JOIN inserted i ON p.id_pedido = i.id_pedido;
END;
GO
-- Trigger  Cancelar pedidos del cliente eliminado
CREATE TRIGGER TRG_Cliente_Delete_CancelPedidos
ON Cliente
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Pedido
    SET estado = 'Cancelado'
    WHERE id_cliente IN (SELECT id_cliente FROM deleted);
END;
GO

