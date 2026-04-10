CREATE SCHEMA IF NOT EXISTS nomad_store;

CREATE TABLE IF NOT EXISTS nomad_store.users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30),
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F', 'O')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nomad_store.addresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES nomad_store.users(user_id) ON DELETE CASCADE,
    city VARCHAR(100) NOT NULL,
    street_address TEXT NOT NULL,
    postal_code VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS nomad_store.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS nomad_store.suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address TEXT
);

CREATE TABLE IF NOT EXISTS nomad_store.products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES nomad_store.categories(category_id),
    supplier_id INT NOT NULL REFERENCES nomad_store.suppliers(supplier_id),
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE IF NOT EXISTS nomad_store.product_images (
    image_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES nomad_store.products(product_id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    is_main BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS nomad_store.orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES nomad_store.users(user_id),
    address_id INT NOT NULL REFERENCES nomad_store.addresses(address_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP CHECK (order_date > '2026-01-01'),
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(50) DEFAULT 'Pending'
);

CREATE TABLE IF NOT EXISTS nomad_store.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES nomad_store.orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES nomad_store.products(product_id),