USE SistemaPedidos
GO

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

-- Trigger que alerta cuando hay un stock bajo del producto
CREATE TRIGGER TR_AlertarBajoStock
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
        PRINT '⚠ ALERTA: El stock de un producto bajó a menos de 5 unidades.';
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

