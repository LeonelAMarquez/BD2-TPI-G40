USE SistemaPedidos
GO

CREATE VIEW vw_ResumenGeneralPedidos AS
SELECT 
    p.id_pedido AS CodigoPedido,
    CONCAT(c.nombre, ' ', c.apellido) AS NombreCompletoCliente,
    c.email AS CorreoCliente,
    p.estado AS EstadoActualPedido,
    p.fecha_pedido AS FechaCreacionPedido,
    COUNT(dp.id_producto) AS CantidadProductos,
    SUM(dp.cantidad) AS UnidadesTotales,
    SUM(dp.subtotal) AS MontoTotalCalculado,
    ISNULL(SUM(pg.monto), 0) AS MontoTotalPagado,
    (SUM(dp.subtotal) - ISNULL(SUM(pg.monto), 0)) AS SaldoPendiente,
    MAX(pg.fecha_pago) AS UltimoPagoRegistrado,
    MAX(l.fecha_envio) AS FechaUltimoEnvio,
    MAX(l.estado_envio) AS EstadoLogistico,
    MAX(l.empresa_transporte) AS EmpresaTransporte
FROM Pedido p
INNER JOIN Cliente c 
    ON p.id_cliente = c.id_cliente
INNER JOIN DetalleDelPedido dp 
    ON p.id_pedido = dp.id_pedido
LEFT JOIN Pagos pg 
    ON p.id_pedido = pg.id_pedido
LEFT JOIN Logistica l 
    ON p.id_pedido = l.id_pedido
GROUP BY 
    p.id_pedido, 
    CONCAT(c.nombre, ' ', c.apellido), 
    c.email, 
    p.estado, 
    p.fecha_pedido;
GO

--vista pedidos clientes:
CREATE VIEW vw_PedidosCliente
AS
SELECT C.nombre + ' ' + C.apellido AS Cliente, PE.fecha_pedido, PE.estado, PE.total FROM Cliente C
INNER JOIN Pedido PE ON C.id_cliente = PE.id_cliente;
go
