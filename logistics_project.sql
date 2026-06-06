/* =========================================
   REAL-TIME LOGISTICS TRACKING SYSTEM
   DBMS PROJECT
========================================= */

CREATE DATABASE logistics_db;
USE logistics_db;

/* =========================================
   PRODUCT TABLE
========================================= */

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    weight FLOAT,
    price DECIMAL(10,2)
);

/* =========================================
   WAREHOUSE TABLE
========================================= */

CREATE TABLE Warehouse (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(100)
);

/* =========================================
   SHIPMENT TABLE
========================================= */

CREATE TABLE Shipment (
    shipment_id INT PRIMARY KEY,
    product_id INT,
    source_warehouse INT,
    destination_warehouse INT,
    status VARCHAR(20),

    FOREIGN KEY (product_id)
        REFERENCES Product(product_id),

    FOREIGN KEY (source_warehouse)
        REFERENCES Warehouse(warehouse_id),

    FOREIGN KEY (destination_warehouse)
        REFERENCES Warehouse(warehouse_id)
);

/* =========================================
   TRACKING TABLE
========================================= */

CREATE TABLE Tracking (
    tracking_id INT PRIMARY KEY,
    shipment_id INT,
    location VARCHAR(100),
    status VARCHAR(20),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (shipment_id)
        REFERENCES Shipment(shipment_id)
);

/* =========================================
   INSERT DATA - PRODUCT
========================================= */

INSERT INTO Product VALUES
(1, 'Laptop', 2.5, 75000.00),
(2, 'Mobile Phone', 0.5, 20000.00),
(3, 'Headphones', 0.3, 3000.00);

/* =========================================
   INSERT DATA - WAREHOUSE
========================================= */

INSERT INTO Warehouse VALUES
(101, 'Delhi'),
(102, 'Mumbai'),
(103, 'Bangalore');

/* =========================================
   INSERT DATA - SHIPMENT
========================================= */

INSERT INTO Shipment VALUES
(201, 1, 101, 102, 'In Transit'),
(202, 2, 102, 103, 'In Transit'),
(203, 3, 101, 103, 'Delivered');

/* =========================================
   INSERT DATA - TRACKING
========================================= */

INSERT INTO Tracking VALUES

-- Shipment 201 (Laptop)
(1, 201, 'Delhi', 'Dispatched', '2026-04-10 10:00:00'),
(2, 201, 'Jaipur', 'In Transit', '2026-04-11 14:00:00'),
(3, 201, 'Mumbai', 'Delivered', '2026-04-12 18:00:00'),

-- Shipment 202 (Mobile Phone)
(4, 202, 'Mumbai', 'Dispatched', '2026-04-11 09:00:00'),
(5, 202, 'Pune', 'In Transit', '2026-04-11 18:00:00'),

-- Shipment 203 (Headphones)
(6, 203, 'Delhi', 'Dispatched', '2026-04-09 08:00:00'),
(7, 203, 'Hyderabad', 'In Transit', '2026-04-09 20:00:00'),
(8, 203, 'Bangalore', 'Delivered', '2026-04-10 16:00:00');

/* =========================================
   VIEW - CURRENT SHIPMENT STATUS
========================================= */

CREATE VIEW CurrentShipmentStatus AS
SELECT shipment_id, location, status
FROM Tracking
WHERE (shipment_id, timestamp) IN (
    SELECT shipment_id, MAX(timestamp)
    FROM Tracking
    GROUP BY shipment_id
);

/* =========================================
   QUERY 1 - FULL HISTORY OF SHIPMENT 203
========================================= */

SELECT *
FROM Tracking
WHERE shipment_id = 203
ORDER BY timestamp;

/* =========================================
   QUERY 2 - CURRENT STATUS OF ALL SHIPMENTS
========================================= */

SELECT *
FROM CurrentShipmentStatus;

/* =========================================
   QUERY 3 - COUNT OF SHIPMENTS BY STATUS
========================================= */

SELECT status,
       COUNT(*) AS total
FROM Shipment
GROUP BY status;

/* =========================================
   QUERY 4 - TOTAL VALUE OF ALL PRODUCTS
========================================= */

SELECT SUM(price) AS total_value
FROM Product;

/* =========================================
   QUERY 5 - SHIPMENT WITH PRODUCT DETAILS
========================================= */

SELECT s.shipment_id,
       p.product_name,
       p.price,
       s.status
FROM Shipment s
JOIN Product p
ON s.product_id = p.product_id;

/* =========================================
   QUERY 6 - FULL TRACKING WITH PRODUCT NAME
========================================= */

SELECT t.shipment_id,
       p.product_name,
       t.location,
       t.status,
       t.timestamp
FROM Tracking t
JOIN Shipment s
ON t.shipment_id = s.shipment_id
JOIN Product p
ON s.product_id = p.product_id
ORDER BY t.timestamp;

/* =========================================
   QUERY 7 - DELIVERED SHIPMENTS
========================================= */

SELECT *
FROM Shipment
WHERE status = 'Delivered';

/* =========================================
   QUERY 8 - LATEST LOCATION OF SHIPMENT 201
========================================= */

SELECT location
FROM Tracking
WHERE shipment_id = 201
ORDER BY timestamp DESC
LIMIT 1;

/* =========================================
   QUERY 9 - NUMBER OF TRACKING UPDATES
========================================= */

SELECT shipment_id,
       COUNT(*) AS updates
FROM Tracking
GROUP BY shipment_id;

/* =========================================
   QUERY 10 - MOST EXPENSIVE PRODUCT
========================================= */

SELECT *
FROM Product
ORDER BY price DESC
LIMIT 1;

/* =========================================
   QUERY 11 - SHIPMENTS FROM WAREHOUSE 101
========================================= */

SELECT *
FROM Shipment
WHERE source_warehouse = 101;

/* =========================================
   QUERY 12 - AVERAGE PRODUCT PRICE
========================================= */

SELECT AVG(price) AS avg_price
FROM Product;

/* =========================================
   QUERY 13 - PRODUCTS CURRENTLY IN TRANSIT
========================================= */

SELECT p.product_name,
       s.shipment_id
FROM Shipment s
JOIN Product p
ON s.product_id = p.product_id
WHERE s.status = 'In Transit';

/* =========================================
   QUERY 14 - SHIPMENTS PER WAREHOUSE
========================================= */

SELECT source_warehouse,
       COUNT(*) AS shipment_count
FROM Shipment
GROUP BY source_warehouse;

/* =========================================
   QUERY 15 - COMPLETE SHIPMENT JOURNEY
========================================= */

SELECT shipment_id,
       location,
       status,
       timestamp
FROM Tracking
ORDER BY shipment_id, timestamp;