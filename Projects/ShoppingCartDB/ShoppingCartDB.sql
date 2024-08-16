-- Create ProductsMenu Table
CREATE TABLE products_menu (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Create Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50)
);

-- Create Cart Table
CREATE TABLE cart (
    product_id INT,
    qty INT,
    user_id INT,
    PRIMARY KEY (product_id, user_id),
    FOREIGN KEY (product_id) REFERENCES products_menu(id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create OrderHeader Table
CREATE TABLE order_header (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create OrderDetails Table
CREATE TABLE order_details (
    order_header INT,
    prod_id INT,
    qty INT,
    FOREIGN KEY (order_header) REFERENCES order_header(order_id),
    FOREIGN KEY (prod_id) REFERENCES products_menu(id)
);

-- Insert into products_menu
INSERT INTO products_menu (id, name, price) VALUES (1, 'Coke', 10.00);
INSERT INTO products_menu (id, name, price) VALUES (2, 'Chips', 5.00);

-- Insert into users
INSERT INTO users (user_id, username) VALUES (1, 'Rishen');
INSERT INTO users (user_id, username) VALUES (2, 'John');

-- Add Coke to the Cart for User 1 (Rishen)
DO $$
BEGIN
    -- Try to update the cart
    UPDATE cart
    SET qty = qty + 1
    WHERE product_id = 1 AND user_id = 1;

    -- Check if the update affected any rows
    IF NOT FOUND THEN
        -- No rows were updated, so insert a new row
        INSERT INTO cart (product_id, qty, user_id) VALUES (1, 1, 1);
    END IF;
END $$;

-- Add Chips to the Cart for User 1 (Rishen)
DO $$
BEGIN
    -- Try to update the cart
    UPDATE cart
    SET qty = qty + 1
    WHERE product_id = 2 AND user_id = 1;

    -- Check if the update affected any rows
    IF NOT FOUND THEN
        -- No rows were updated, so insert a new row
        INSERT INTO cart (product_id, qty, user_id) VALUES (2, 1, 1);
    END IF;
END $$;

-- Remove Coke from the Cart for User 1 (Rishen)
DO $$
BEGIN
    -- Check if the quantity is greater than 1
    IF (SELECT qty FROM cart WHERE product_id = 1 AND user_id = 1) > 1 THEN
        -- If yes, decrement the quantity
        UPDATE cart
        SET qty = qty - 1
        WHERE product_id = 1 AND user_id = 1;
    ELSE
        -- If the quantity is 1 or less, delete the item
        DELETE FROM cart
        WHERE product_id = 1 AND user_id = 1;
    END IF;
END $$;

-- Insert into order_header for User 1 (Rishen)
INSERT INTO order_header (order_id, user_id, order_date) 
VALUES (1, 1, NOW());

-- Insert Cart contents into order_details for User 1 (Rishen)
INSERT INTO order_details (order_header, prod_id, qty)
SELECT 1, product_id, qty FROM cart WHERE user_id = 1;

-- Clear the Cart after checkout for User 1 (Rishen)
DELETE FROM cart WHERE user_id = 1;


-- Add Chips to the Cart for User 2 (John)
DO $$
BEGIN
    -- Try to update the cart
    UPDATE cart
    SET qty = qty + 1
    WHERE product_id = 2 AND user_id = 2;

    -- Check if the update affected any rows
    IF NOT FOUND THEN
        -- No rows were updated, so insert a new row
        INSERT INTO cart (product_id, qty, user_id) VALUES (2, 1, 2);
    END IF;
END $$;

-- Add Coke to the Cart for User 2 (John)
DO $$
BEGIN
    -- Try to update the cart
    UPDATE cart
    SET qty = qty + 1
    WHERE product_id = 1 AND user_id = 2;

    -- Check if the update affected any rows
    IF NOT FOUND THEN
        -- No rows were updated, so insert a new row
        INSERT INTO cart (product_id, qty, user_id) VALUES (1, 1, 2);
    END IF;
END $$;

-- Remove Chips from the Cart for User 2 (John)
DO $$
BEGIN
    -- Check if the quantity is greater than 1
    IF (SELECT qty FROM cart WHERE product_id = 2 AND user_id = 2) > 1 THEN
        -- If yes, decrement the quantity
        UPDATE cart
        SET qty = qty - 1
        WHERE product_id = 2 AND user_id = 2;
    ELSE
        -- If the quantity is 1 or less, delete the item
        DELETE FROM cart
        WHERE product_id = 2 AND user_id = 2;
    END IF;
END $$;

-- Insert into order_header for User 2 (John)
INSERT INTO order_header (order_id, user_id, order_date) 
VALUES (2, 2, NOW());

-- Insert Cart contents into order_details for User 2 (John)
INSERT INTO order_details (order_header, prod_id, qty)
SELECT 2, product_id, qty FROM cart WHERE user_id = 2;

-- Clear the Cart after checkout for User 2 (John)
DELETE FROM cart WHERE user_id = 2;

-- Print all orders for a specific date
SELECT 
    users.username AS customer_name,
    products_menu.name AS product_name,
    order_details.qty AS quantity,
    order_header.order_date
FROM 
    order_header
INNER JOIN 
    order_details ON order_header.order_id = order_details.order_header
INNER JOIN 
    products_menu ON order_details.prod_id = products_menu.id
INNER JOIN 
    users ON order_header.user_id = users.user_id
WHERE 
    DATE(order_header.order_date) = '2024-08-16';
