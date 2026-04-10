
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30),
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    city VARCHAR(100) NOT NULL,
    street_address TEXT NOT NULL,
    postal_code VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE
);


CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(category_id),
    supplier_id INT NOT NULL REFERENCES suppliers(supplier_id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);


CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    address_id INT NOT NULL REFERENCES addresses(address_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP CHECK (order_date > '2026-01-01'),
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(50) DEFAULT 'Pending'
);


CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    row_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * price_at_purchase) STORED
);


CREATE TABLE payment_transactions (
    transaction_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(50) NOT NULL
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    user_id INT NOT NULL REFERENCES users(user_id),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT
);

INSERT INTO categories (category_id, category_name, description)
VALUES 
    (1, 'Electronics', 'Gadgets, computers and smart devices'),
    (2, 'Accessories', 'Cases, chargers and more')
ON CONFLICT (category_id) DO NOTHING;

INSERT INTO suppliers (supplier_id, supplier_name, contact_name, email, phone_number, address)
VALUES 
    (1, 'Nomad Tech Distribution', 'Alibi Kassymov', 'opt@nomadtech.kz', '+77011234567', 'Almaty, Dostyk 12'),
    (2, 'Global Parts', 'Sarah Connor', 'sales@global.com', '+15559998877', 'California, Cyberdyne St 101')
ON CONFLICT (supplier_id) DO NOTHING;

INSERT INTO users (user_id, username, email, password, phone_number, gender)
VALUES 
    (1, 'serzhan_pro', 'serzhan@nomad.kz', 'hash_777_secure', '+77071112233', 'M'),
    (2, 'aijan_m', 'aijan@mail.kz', 'hash_abc_123', '+77025554433', 'F')
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO addresses (address_id, user_id, city, street_address, postal_code, is_default)
VALUES 
    (1, 1, 'Atyrau', 'Satpayev St. 15, apt 4', '060000', TRUE),
    (2, 2, 'Almaty', 'Abay Ave. 52, apt 10', '050000', TRUE)
ON CONFLICT (address_id) DO NOTHING;

INSERT INTO products (product_id, category_id, supplier_id, name, description, price, stock_quantity)
VALUES 
    (1, 1, 1, 'Smartphone Nomad X1', 'Flagship nomadic smartphone', 999.99, 50),
    (2, 2, 2, 'Fast Charger 65W', 'Ultra-fast GaN charger', 45.00, 200)
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO product_images (image_id, product_id, image_url, is_main)
VALUES 
    (1, 1, 'https://nomad.kz/img/x1_front.jpg', TRUE),
    (2, 1, 'https://nomad.kz/img/x1_back.jpg', FALSE),
    (3, 2, 'https://nomad.kz/img/charger.jpg', TRUE)
ON CONFLICT (image_id) DO NOTHING;

INSERT INTO orders (order_id, user_id, address_id, order_date, total_amount, status)
VALUES 
    (1, 1, 1, '2026-04-10 10:00:00', 1044.99, 'Processing'),
    (2, 2, 2, '2026-04-11 15:30:00', 45.00, 'Shipped')
ON CONFLICT (order_id) DO NOTHING;

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price_at_purchase)
VALUES 
    (1, 1, 1, 1, 999.99),
    (2, 1, 2, 1, 45.00),
    (3, 2, 2, 1, 45.00)
ON CONFLICT (order_item_id) DO NOTHING;

INSERT INTO payment_transactions (transaction_id, order_id, payment_method, amount, status)
VALUES 
    (1, 1, 'Kaspi QR', 1044.99, 'Completed'),
    (2, 2, 'Credit Card', 45.00, 'Success')
ON CONFLICT (transaction_id) DO NOTHING;

INSERT INTO reviews (review_id, product_id, user_id, rating, comment)
VALUES 
    (1, 1, 1, 5, 'Best phone for the steppe trips!'),
    (2, 2, 2, 4, 'Very fast, but gets a bit warm.')
ON CONFLICT (review_id) DO NOTHING;

