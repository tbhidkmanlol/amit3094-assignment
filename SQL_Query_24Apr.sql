-- ====================================PRODUCT Table============================================

-- Drop the existing table if it exists
DROP TABLE NBUSER.PRODUCT;

-- Create the new table with QUANTITY column
CREATE TABLE NBUSER.PRODUCT (
    ID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR(100) NOT NULL,
    PRICE DECIMAL(10,2) NOT NULL,
    IMAGE VARCHAR(255),
    DESCRIPTION VARCHAR(500),
    QUANTITY INT DEFAULT 0 NOT NULL
);

-- Insert test data with descriptions and quantities
INSERT INTO NBUSER.PRODUCT (NAME, PRICE, IMAGE, DESCRIPTION, QUANTITY) VALUES 
('Cable Type-C', 19.50, 'Images/Cable1.jpeg', 'High-speed USB-C charging cable, supports 100W fast charging, 1.8m length', 150),
('Cable Lightning', 20.50, 'Images/Cable2.webp', 'Apple-certified Lightning cable, 2m length, durable braided design', 120),
('Car Charger', 39.99, 'Images/CarCharger.jpg', 'Dual-port car charger with PD fast charging and QC3.0 support', 85),
('Bluetooth Earphone', 99.99, 'Images/Earphone.jpeg', 'Wireless Bluetooth earphones with active noise cancellation, 24-hour battery life', 65),
('Bluetooth Keyboard', 279.50, 'Images/Keyboard.webp', 'Mechanical Bluetooth keyboard with multi-device switching and RGB backlight', 40),
('Phone Case 16Pro', 14.99, 'Images/PhoneCase1.jpg', 'iPhone 16 Pro protective case, shockproof and scratch-resistant', 200),
('Phone Holder', 29.99, 'Images/PhoneHolder.jpg', '360-degree rotating phone stand for car and desktop use', 90),
('Screen Protector Clear', 50.00, 'Images/ScreenProtector1.png', 'HD tempered glass screen protector, 9H hardness, anti-fingerprint', 180),
('Screen Protector Privacy', 60.00, 'Images/ScreenProtector2.webp', 'Privacy tempered glass screen protector with 45-degree viewing angle protection', 110),
('Plug Extension', 80.00, 'Images/PlugExtension.jpg', '3-port plug extender with USB charging and overload protection', 55);




-- ======================================REVIEW Table=========================================================


DROP TABLE NBUSER.REVIEW;

CREATE TABLE NBUSER.REVIEW (
    REVIEW_ID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    PRODUCT_ID INT NOT NULL,
    CUSTOMER_NAME VARCHAR(100) NOT NULL,
    RATING INT NOT NULL CHECK (RATING BETWEEN 1 AND 5),
    COMMENT VARCHAR(500),
    REVIEW_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ADMIN_REPLY VARCHAR(500),
    REPLY_DATE TIMESTAMP,
    FOREIGN KEY (PRODUCT_ID) REFERENCES NBUSER.PRODUCT(ID)
);




-- =====================================User Table===========================================



CREATE TABLE users (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(10) NOT NULL CHECK (role IN ('CUSTOMER', 'ADMIN', 'MANAGER')),
    customer_name VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    PRIMARY KEY (id)
);

INSERT INTO users (username, password, role) VALUES ('manager', 'manager123', 'MANAGER');



--  ====------------------------for report function below (statistic) / manager access-------------------===

-- ================================= ORDERS Table ============================================


CREATE TABLE NBUSER.ORDERS (
    ORDER_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    ORDER_NUMBER VARCHAR(50) NOT NULL,
    CUSTOMER_ID INTEGER,
    ORDER_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TOTAL_AMOUNT DOUBLE,
    SHIPPING_FEE DOUBLE,
    TAX_AMOUNT DOUBLE,
    PAYMENT_METHOD VARCHAR(20),
    PAYMENT_STATUS VARCHAR(20),
    SHIPPING_STATUS VARCHAR(20),
    BILLING_ADDRESS VARCHAR(255),
    SHIPPING_ADDRESS VARCHAR(255),
    CUSTOMER_EMAIL VARCHAR(100),
    CUSTOMER_PHONE VARCHAR(20),
    PRIMARY KEY (ORDER_ID)
);

-- ===============================ORDER_ITEMS Table===============================================


CREATE TABLE NBUSER.ORDER_ITEMS (
    ITEM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    ORDER_ID INTEGER NOT NULL,
    PRODUCT_ID INTEGER NOT NULL,
    QUANTITY INTEGER NOT NULL,
    PRICE_PER_UNIT DOUBLE NOT NULL,
    SUBTOTAL DOUBLE NOT NULL,
    PRIMARY KEY (ITEM_ID)
);


-- ============================SALES_REPORT View============================================

DROP VIEW NBUSER.SALES_REPORT;

CREATE VIEW NBUSER.SALES_REPORT AS
SELECT 
    o.ORDER_DATE,
    o.ORDER_ID,
    o.ORDER_NUMBER,
    o.CUSTOMER_ID,
    o.PAYMENT_METHOD,
    o.TOTAL_AMOUNT,
    o.TAX_AMOUNT,
    o.SHIPPING_FEE,
    oi.PRODUCT_ID,
    p.NAME AS PRODUCT_NAME,
    oi.QUANTITY,
    oi.PRICE_PER_UNIT,
    oi.SUBTOTAL
FROM 
    NBUSER.ORDERS o
    JOIN NBUSER.ORDER_ITEMS oi ON o.ORDER_ID = oi.ORDER_ID
    JOIN NBUSER.PRODUCT p ON oi.PRODUCT_ID = p.ID;



-- ===============================TOP_PRODUCTS View=================================================


DROP VIEW NBUSER.TOP_PRODUCTS;

CREATE VIEW NBUSER.TOP_PRODUCTS AS
SELECT 
    p.ID AS PRODUCT_ID,
    p.NAME AS PRODUCT_NAME,
    SUM(oi.QUANTITY) AS TOTAL_QUANTITY_SOLD,
    SUM(oi.SUBTOTAL) AS TOTAL_REVENUE
FROM 
    NBUSER.PRODUCT p
    JOIN NBUSER.ORDER_ITEMS oi ON p.ID = oi.PRODUCT_ID
    JOIN NBUSER.ORDERS o ON oi.ORDER_ID = o.ORDER_ID
GROUP BY 
    p.ID, p.NAME
ORDER BY 
    TOTAL_QUANTITY_SOLD DESC; 




