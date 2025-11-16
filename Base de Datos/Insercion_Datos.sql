USE SistemaPedidos;
GO

-- =============================================
-- INSERTS: Usuario
-- =============================================
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('admin', 'admin123', 'Administrador');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('vendedor1', 'vend123', 'Vendedor');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('vendedor2', 'vend456', 'Vendedor');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente1', 'pass1#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente2', 'pass2#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente3', 'pass3#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente4', 'pass4#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente5', 'pass5#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente6', 'pass6#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente7', 'pass7#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente8', 'pass8#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente9', 'pass9#', 'Cliente');
INSERT INTO Usuario (nombre_usuario, contrasena, rol) VALUES ('cliente10', 'pass10#', 'Cliente');

-- =============================================
-- INSERTS: CLIENTE
-- =============================================
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (4, 'Juan', 'Pérez', 'cliente1@gmail.com', '1148676778', 'Calle Falsa 962', 'La Plata', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (5, 'María', 'Gómez', 'cliente2@gmail.com', '1144815362', 'Calle Falsa 555', 'Córdoba', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (6, 'Carlos', 'Rodríguez', 'cliente3@gmail.com', '1149207323', 'Calle Falsa 918', 'Buenos Aires', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (7, 'Ana', 'López', 'cliente4@gmail.com', '1140574681', 'Calle Falsa 966', 'Mendoza', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (8, 'Pedro', 'Fernández', 'cliente5@gmail.com', '1149836620', 'Calle Falsa 311', 'Rosario', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (9, 'Lucía', 'Sánchez', 'cliente6@gmail.com', '1149460847', 'Calle Falsa 682', 'Rosario', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (10, 'Diego', 'Ramírez', 'cliente7@gmail.com', '1148635759', 'Calle Falsa 781', 'Córdoba', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (11, 'Sofía', 'Torres', 'cliente8@gmail.com', '1146407941', 'Calle Falsa 810', 'Mendoza', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (12, 'Martín', 'García', 'cliente9@gmail.com', '1147396890', 'Calle Falsa 722', 'Buenos Aires', 'Argentina');
INSERT INTO Cliente (id_usuario, nombre, apellido, email, telefono, direccion, ciudad, pais) VALUES (13, 'Valentina', 'Morales', 'cliente10@gmail.com', '1149991602', 'Calle Falsa 398', 'Córdoba', 'Argentina');

-- =============================================
-- INSERTS: PROVEEDOR
-- =============================================
INSERT INTO Proveedor (nombre_proveedor, ruc, direccion, telefono, email) VALUES ('Coca-Cola FEMSA', '30-12345678-9', 'Av. Corrientes 1234', '1123456789', 'contacto@cocacola.com');
INSERT INTO Proveedor (nombre_proveedor, ruc, direccion, telefono, email) VALUES ('Quilmes', '30-87654321-0', 'Ruta 36 km 45', '1145678901', 'ventas@quilmes.com');
INSERT INTO Proveedor (nombre_proveedor, ruc, direccion, telefono, email) VALUES ('PepsiCo', '30-11223344-5', 'Av. Rivadavia 5555', '1133344455', 'info@pepsico.com');
INSERT INTO Proveedor (nombre_proveedor, ruc, direccion, telefono, email) VALUES ('Heineken', '30-99887766-3', 'Av. Libertador 4321', '1166667777', 'contact@heineken.com');
INSERT INTO Proveedor (nombre_proveedor, ruc, direccion, telefono, email) VALUES ('Red Bull', '30-55443322-1', 'Calle Mitre 1010', '1177788899', 'ventas@redbull.com');

-- =============================================
-- INSERTS: CONTACTO
-- =============================================
INSERT INTO Contacto (id_proveedor, nombre_contacto, telefono, email, cargo) VALUES (1, 'Contacto Coca-Cola FEMSA', '1157512915', 'contacto1@coca-cola.com', 'Ventas');
INSERT INTO Contacto (id_proveedor, nombre_contacto, telefono, email, cargo) VALUES (2, 'Contacto Quilmes', '1156291249', 'contacto2@quilmes.com', 'Ventas');
INSERT INTO Contacto (id_proveedor, nombre_contacto, telefono, email, cargo) VALUES (3, 'Contacto PepsiCo', '1154143732', 'contacto3@pepsico.com', 'Ventas');
INSERT INTO Contacto (id_proveedor, nombre_contacto, telefono, email, cargo) VALUES (4, 'Contacto Heineken', '1154464014', 'contacto4@heineken.com', 'Ventas');
INSERT INTO Contacto (id_proveedor, nombre_contacto, telefono, email, cargo) VALUES (5, 'Contacto Red Bull', '1155896981', 'contacto5@red.com', 'Ventas');

-- =============================================
-- INSERTS: PRODUCTO
-- =============================================
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Coca-Cola 1L', 'Gaseosa cola 1 litro', 120.5, 1);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Sprite 1L', 'Gaseosa lima-limón 1 litro', 118.0, 1);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Quilmes Cristal 1L', 'Cerveza rubia 1 litro', 220.0, 2);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Heineken 1L', 'Cerveza importada 1 litro', 250.0, 4);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Pepsi 1L', 'Gaseosa cola 1 litro', 115.0, 3);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('7Up 1L', 'Gaseosa lima-limón 1 litro', 117.0, 3);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Red Bull 250ml', 'Energizante 250ml', 350.0, 5);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Agua Eco de los Andes 1L', 'Agua mineral natural', 90.0, 3);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Gatorade 500ml', 'Bebida deportiva sabor naranja', 180.0, 3);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Cerveza Stella Artois 1L', 'Cerveza premium', 260.0, 4);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Vino Malbec 750ml', 'Vino tinto argentino', 550.0, 2);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Vino Blanco Chardonnay 750ml', 'Vino blanco', 520.0, 2);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Cerveza Andes IPA 1L', 'Cerveza artesanal', 270.0, 2);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Agua Villavicencio 1L', 'Agua mineral natural', 95.0, 3);
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) VALUES ('Speed 250ml', 'Energizante', 340.0, 5);

-- =============================================
-- INSERTS: STOCK
-- =============================================
INSERT INTO Stock (id_producto, cantidad) VALUES (1, 126);
INSERT INTO Stock (id_producto, cantidad) VALUES (2, 476);
INSERT INTO Stock (id_producto, cantidad) VALUES (3, 177);
INSERT INTO Stock (id_producto, cantidad) VALUES (4, 110);
INSERT INTO Stock (id_producto, cantidad) VALUES (5, 337);
INSERT INTO Stock (id_producto, cantidad) VALUES (6, 485);
INSERT INTO Stock (id_producto, cantidad) VALUES (7, 373);
INSERT INTO Stock (id_producto, cantidad) VALUES (8, 134);
INSERT INTO Stock (id_producto, cantidad) VALUES (9, 463);
INSERT INTO Stock (id_producto, cantidad) VALUES (10, 458);
INSERT INTO Stock (id_producto, cantidad) VALUES (11, 285);
INSERT INTO Stock (id_producto, cantidad) VALUES (12, 477);
INSERT INTO Stock (id_producto, cantidad) VALUES (13, 174);
INSERT INTO Stock (id_producto, cantidad) VALUES (14, 371);
INSERT INTO Stock (id_producto, cantidad) VALUES (15, 85);

-- =============================================
-- INSERTS: PEDIDOS, DETALLES, PAGOS, LOGISTICA
-- =============================================
INSERT INTO Pedido (id_cliente, estado) VALUES (5, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (1, 9, 3, 180.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (1, 8, 3, 90.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (1, 12, 3, 520.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (1, 'Transferencia', 4291);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (1, 'OCA', 'G00001', 'En proceso');
INSERT INTO Pedido (id_cliente, estado) VALUES (6, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (2, 7, 10, 350.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (2, 2, 1, 118.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (2, 'Tarjeta', 1359);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (2, 'Andreani', 'G00002', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (4, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (3, 9, 8, 180.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (3, 10, 2, 260.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (3, 1, 4, 120.5);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (3, 14, 9, 95.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (3, 'Tarjeta', 3877);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (3, 'Andreani', 'G00003', 'Enviado');
INSERT INTO Pedido (id_cliente, estado) VALUES (10, 'Procesando');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (4, 6, 9, 117.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (4, 11, 7, 550.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (4, 7, 9, 350.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (4, 'Transferencia', 4277);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (4, 'Correo Argentino', 'G00004', 'Enviado');
INSERT INTO Pedido (id_cliente, estado) VALUES (3, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (5, 11, 2, 550.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (5, 7, 10, 350.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (5, 1, 2, 120.5);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (5, 'Efectivo', 2342);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (5, 'Andreani', 'G00005', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (5, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (6, 7, 4, 350.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (6, 13, 7, 270.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (6, 15, 10, 340.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (6, 2, 1, 118.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (6, 'Efectivo', 1122);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (6, 'Correo Argentino', 'G00006', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (2, 'Enviado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (7, 12, 2, 520.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (7, 14, 10, 95.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (7, 'Efectivo', 2003);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (7, 'Correo Argentino', 'G00007', 'Enviado');
INSERT INTO Pedido (id_cliente, estado) VALUES (4, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (8, 11, 5, 550.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (8, 4, 4, 250.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (8, 9, 8, 180.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (8, 'Efectivo', 3551);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (8, 'OCA', 'G00008', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (5, 'Procesando');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (9, 7, 1, 350.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (9, 8, 3, 90.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (9, 'Efectivo', 4941);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (9, 'OCA', 'G00009', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (9, 'Procesando');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (10, 9, 10, 180.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (10, 4, 1, 250.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (10, 'Tarjeta', 3700);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (10, 'Andreani', 'G00010', 'En proceso');
INSERT INTO Pedido (id_cliente, estado) VALUES (2, 'Pendiente');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (11, 13, 10, 270.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (11, 8, 9, 90.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (11, 6, 1, 117.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (11, 'Tarjeta', 3635);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (11, 'Andreani', 'G00011', 'En proceso');
INSERT INTO Pedido (id_cliente, estado) VALUES (5, 'Enviado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (12, 14, 10, 95.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (12, 4, 6, 250.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (12, 3, 10, 220.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (12, 'Transferencia', 1085);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (12, 'OCA', 'G00012', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (6, 'Procesando');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (13, 11, 9, 550.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (13, 15, 8, 340.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (13, 2, 4, 118.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (13, 14, 9, 95.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (13, 'Tarjeta', 4945);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (13, 'Andreani', 'G00013', 'Enviado');
INSERT INTO Pedido (id_cliente, estado) VALUES (2, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (14, 6, 3, 117.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (14, 15, 10, 340.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (14, 12, 1, 520.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (14, 'Efectivo', 2116);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (14, 'Andreani', 'G00014', 'Enviado');
INSERT INTO Pedido (id_cliente, estado) VALUES (8, 'Procesando');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (15, 3, 6, 220.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (15, 11, 7, 550.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (15, 'Transferencia', 3316);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (15, 'Correo Argentino', 'G00015', 'Entregado');
INSERT INTO Pedido (id_cliente, estado) VALUES (4, 'Enviado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (16, 9, 4, 180.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (16, 1, 10, 120.5);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (16, 'Transferencia', 1496);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (16, 'OCA', 'G00016', 'Enviado');
INSERT INTO Pedido (id_cliente, estado) VALUES (4, 'Pendiente');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (17, 14, 9, 95.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (17, 10, 6, 260.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (17, 6, 9, 117.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (17, 12, 2, 520.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (17, 'Efectivo', 949);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (17, 'OCA', 'G00017', 'En proceso');
INSERT INTO Pedido (id_cliente, estado) VALUES (6, 'Entregado');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (18, 15, 9, 340.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (18, 14, 7, 95.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (18, 'Transferencia', 2385);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (18, 'Andreani', 'G00018', 'En proceso');
INSERT INTO Pedido (id_cliente, estado) VALUES (2, 'Pendiente');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (19, 2, 9, 118.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (19, 1, 8, 120.5);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (19, 5, 7, 115.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (19, 10, 6, 260.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (19, 'Transferencia', 1466);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (19, 'Correo Argentino', 'G00019', 'En proceso');
INSERT INTO Pedido (id_cliente, estado) VALUES (3, 'Pendiente');
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (20, 15, 3, 340.0);
INSERT INTO DetalleDelPedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (20, 10, 2, 260.0);
INSERT INTO Pagos (id_pedido, metodo_pago, monto) VALUES (20, 'Transferencia', 3710);
INSERT INTO Logistica (id_pedido, empresa_transporte, numero_guia, estado_envio) VALUES (20, 'OCA', 'G00020', 'En proceso');

UPDATE P
SET total = (
    SELECT SUM(DP.cantidad * DP.precio_unitario)
    FROM DetalleDelPedido DP
    WHERE DP.id_pedido = P.id_pedido
)
FROM Pedido P;

-- Inserte productos sin stock y con stock bajo para pruebas (Leo)
INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) 
VALUES 
('Fanta 1L', 'Gaseosa sabor naranja 1 litro', 125.0, 1),
('Cerveza Patagonia Amber 1L', 'Cerveza artesanal amber', 280.0, 2),
('Agua con gas 1L', 'Agua mineral con gas', 100.0, 3);

INSERT INTO Stock (id_producto, cantidad) 
VALUES 
(16, 0), 
(17, 0),  
(18, 0);  

INSERT INTO Producto (nombre, descripcion, precio, id_proveedor) 
VALUES 
('Cerveza Imperial 1L', 'Cerveza premium importada', 320.0, 4),
('Monster Energy 500ml', 'Bebida energética', 380.0, 5),
('Agua saborizada 1L', 'Agua con sabor a limón', 110.0, 3);

INSERT INTO Stock (id_producto, cantidad) 
VALUES 
(19, 3),  
(20, 7),   
(21, 2);   