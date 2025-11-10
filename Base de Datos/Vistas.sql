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