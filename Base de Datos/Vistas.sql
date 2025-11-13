USE SistemaPedidos
GO

-- Vista del cálculo automático del total de cada pedido

CREATE VIEW vw_PedidosTotales AS
SELECT 
    p.id_pedido,
    p.id_cliente,
    SUM(dp.subtotal) AS total_calculado
FROM Pedido p
JOIN DetalleDelPedido dp ON p.id_pedido = dp.id_pedido
GROUP BY p.id_pedido, p.id_cliente;
GO

--vista productos con stock:
CREATE VIEW vw_ProductosConStock
AS
SELECT PR.nombre_proveedor AS Proveedor, P.nombre AS Cliente, P.precio, S.cantidad FROM Proveedor PR
INNER JOIN Producto P ON PR.id_proveedor = P.id_proveedor
INNER JOIN Stock S ON P.id_producto = S.id_producto
WHERE S.cantidad >= 0;
go

--vista pedidos clientes:
CREATE VIEW vw_PedidosCliente
AS
SELECT C.nombre + ' ' + C.apellido AS Cliente, PE.fecha_pedido, PE.estado, PE.total FROM Cliente C
INNER JOIN Pedido PE ON C.id_cliente = PE.id_cliente;
go