-- grupo 40
CREATE DATABASE SistemaPedidos;
GO

USE SistemaPedidos;
GO

CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario NVARCHAR(100) NOT NULL UNIQUE,
    contrasena NVARCHAR(255) NOT NULL,
    rol NVARCHAR(50) NOT NULL CHECK (rol IN ('Cliente', 'Administrador', 'Vendedor')),
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) UNIQUE NOT NULL,
    telefono NVARCHAR(20),
    direccion NVARCHAR(255),
    ciudad NVARCHAR(100),
    pais NVARCHAR(100),
    CONSTRAINT FK_Cliente_Usuario FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Proveedor (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    nombre_proveedor NVARCHAR(150) NOT NULL,
    ruc NVARCHAR(20) UNIQUE,
    direccion NVARCHAR(255),
    telefono NVARCHAR(20),
    email NVARCHAR(100)
);
GO

CREATE TABLE Contacto (
    id_contacto INT IDENTITY(1,1) PRIMARY KEY,
    id_proveedor INT NOT NULL,
    nombre_contacto NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    email NVARCHAR(100),
    cargo NVARCHAR(50),
    CONSTRAINT FK_Contacto_Proveedor FOREIGN KEY (id_proveedor)
        REFERENCES Proveedor(id_proveedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(255),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    id_proveedor INT NOT NULL,
    CONSTRAINT FK_Producto_Proveedor FOREIGN KEY (id_proveedor)
        REFERENCES Proveedor(id_proveedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Stock (
    id_stock INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL UNIQUE,
    cantidad INT NOT NULL DEFAULT 0 CHECK (cantidad >= 0),
    fecha_actualizacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Stock_Producto FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME DEFAULT GETDATE(),
    estado NVARCHAR(50) DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Procesando', 'Enviado', 'Entregado', 'Cancelado')),
    total DECIMAL(12,2) NULL,  -- Puede calcularse en consultas
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE DetalleDelPedido (
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal AS (cantidad * precio_unitario) PERSISTED,
    PRIMARY KEY (id_pedido, id_producto),
    CONSTRAINT FK_Detalle_Pedido FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Pagos (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    metodo_pago NVARCHAR(50) NOT NULL CHECK (metodo_pago IN ('Efectivo', 'Tarjeta', 'Transferencia', 'Otro')),
    monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    fecha_pago DATETIME DEFAULT GETDATE(),
    observaciones NVARCHAR(255),
    CONSTRAINT FK_Pago_Pedido FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Logistica (
    id_logistica INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    empresa_transporte NVARCHAR(100),
    numero_guia NVARCHAR(50),
    fecha_envio DATETIME,
    fecha_entrega DATETIME,
    estado_envio NVARCHAR(50) DEFAULT 'En proceso' CHECK (estado_envio IN ('En proceso', 'Enviado', 'Entregado', 'Devuelto')),
    CONSTRAINT FK_Logistica_Pedido FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO
