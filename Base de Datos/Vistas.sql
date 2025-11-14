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

-- Muestra a los clientes deudores
CREATE VIEW ClientesConDeuda AS
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    c.email,
    p.id_pedido,
    SUM(dp.subtotal) AS total_pedido,
    ISNULL(SUM(pg.monto), 0) AS total_pagado,
    (SUM(dp.subtotal) - ISNULL(SUM(pg.monto), 0)) AS saldo_pendiente
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
JOIN DetalleDelPedido dp ON p.id_pedido = dp.id_pedido
LEFT JOIN Pagos pg ON p.id_pedido = pg.id_pedido
GROUP BY 
    c.id_cliente, c.nombre, c.apellido, c.email, p.id_pedido
HAVING SUM(dp.subtotal) > ISNULL(SUM(pg.monto), 0);
GO

-- Muestra los productos que mas se vendieron en el ultimo mes(30 dias)
CREATE VIEW ProductosMasVendidos30Dias AS
SELECT 
    pr.id_producto,
    pr.nombre AS nombre_producto,
    SUM(dp.cantidad) AS total_vendido
FROM DetalleDelPedido dp
INNER JOIN Pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN Producto pr ON dp.id_producto = pr.id_producto
WHERE p.fecha_pedido >= DATEADD(DAY, -30, GETDATE()) 
GROUP BY pr.id_producto, pr.nombre
ORDER BY total_vendido DESC;
GO