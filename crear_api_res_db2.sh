#!/bin/bash

# ===== CONFIGURACIÓN =====
DB_NAME="api_res_db2"
DB_USER="pablo"
DB_PASSWORD="Pablo35_"
DB_HOST="127.0.0.1"

# =========================

echo "Creando base de datos y tablas..."

mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" <<EOF

CREATE DATABASE IF NOT EXISTS $DB_NAME
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE $DB_NAME;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE categorias (
  id int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(100) NOT NULL,
  descripcion text DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE clientes (
  id int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(100) NOT NULL,
  email varchar(150) NOT NULL,
  telefono varchar(20) DEFAULT NULL,
  direccion varchar(200) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE productos (
  id int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  precio float NOT NULL,
  stock int(11) DEFAULT 0,
  createdAt datetime NOT NULL,
  updatedAt datetime NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedidos (
  id int(11) NOT NULL AUTO_INCREMENT,
  cliente_id int(11) NOT NULL,
  fecha datetime DEFAULT current_timestamp(),
  total decimal(10,2) DEFAULT 0.00,
  estado enum('pendiente','pagado','enviado','entregado','cancelado') DEFAULT 'pendiente',
  PRIMARY KEY (id),
  KEY cliente_id (cliente_id),
  CONSTRAINT pedidos_ibfk_1 FOREIGN KEY (cliente_id)
    REFERENCES clientes (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE detalles_pedido (
  id int(11) NOT NULL AUTO_INCREMENT,
  pedido_id int(11) NOT NULL,
  producto_id int(11) NOT NULL,
  cantidad int(11) NOT NULL DEFAULT 1,
  precio_unitario decimal(10,2) NOT NULL,
  subtotal decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY pedido_id (pedido_id),
  KEY producto_id (producto_id),
  CONSTRAINT detalles_pedido_ibfk_3 FOREIGN KEY (pedido_id)
    REFERENCES pedidos (id),
  CONSTRAINT detalles_pedido_ibfk_4 FOREIGN KEY (producto_id)
    REFERENCES productos (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;

EOF

echo "✅ Base de datos y tablas creadas correctamente"
