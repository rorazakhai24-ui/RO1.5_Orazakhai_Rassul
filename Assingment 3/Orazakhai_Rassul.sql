DROP USER IF EXISTS db_admin_user;
DROP USER IF EXISTS db_reader_user;
DROP ROLE IF EXISTS nomad_store_admin;
DROP ROLE IF EXISTS nomad_store_readonly;

CREATE ROLE nomad_store_admin;
CREATE ROLE nomad_store_readonly;

GRANT ALL ON SCHEMA nomad_store TO nomad_store_admin;
GRANT USAGE ON SCHEMA nomad_store TO nomad_store_readonly;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA nomad_store TO nomad_store_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA nomad_store TO nomad_store_readonly;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA nomad_store TO nomad_store_admin;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA nomad_store TO nomad_store_readonly;

ALTER DEFAULT PRIVILEGES IN SCHEMA nomad_store GRANT ALL ON TABLES TO nomad_store_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA nomad_store GRANT SELECT ON TABLES TO nomad_store_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA nomad_store GRANT ALL ON SEQUENCES TO nomad_store_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA nomad_store GRANT SELECT, USAGE ON SEQUENCES TO nomad_store_readonly;

CREATE USER db_admin_user WITH PASSWORD 'admin_secure_777' SUPERUSER;
GRANT nomad_store_admin TO db_admin_user;

CREATE USER db_reader_user WITH PASSWORD 'reader_secure_123';
GRANT nomad_store_readonly TO db_reader_user;

REVOKE UPDATE, DELETE ON ALL TABLES IN SCHEMA nomad_store FROM nomad_store_readonly;

/*
Схема       | Имя                                         | Тип                | Права доступа
------------+---------------------------------------------+--------------------+-------------------------------------
nomad_store | addresses                                   | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | addresses_address_id_seq                    | последовательность | 
nomad_store | categories                                  | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | categories_category_id_seq                  | последовательность | 
nomad_store | order_items                                 | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | order_items_order_item_id_seq                | последовательность | 
nomad_store | orders                                      | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | orders_order_id_seq                         | последовательность | 
nomad_store | payment_transactions                        | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | payment_transactions_transaction_id_seq     | последовательность | 
nomad_store | product_images                              | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | product_images_image_id_seq                 | последовательность | 
nomad_store | products                                    | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | products_product_id_seq                     | последовательность | 
nomad_store | reviews                                     | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | reviews_review_id_seq                       | последовательность | 
nomad_store | suppliers                                   | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | suppliers_supplier_id_seq                   | последовательность | 
nomad_store | users                                       | таблица            | postgres=arwdDxtm/postgres +
            |                                             |                    | nomad_store_admin=arwdDxtm/postgres  +
            |                                             |                    | nomad_store_readonly=r/postgres
nomad_store | users_user_id_seq                           | последовательность | 
(20 строк)
*/

SET search_path TO nomad_store, public;

SET ROLE db_admin_user;
SELECT current_user;
SELECT COUNT(*) FROM nomad_store.products;

BEGIN;
INSERT INTO nomad_store.categories (category_name, description) VALUES ('Admin Test Cat', 'Testing Admin') RETURNING *;
COMMIT;

BEGIN;
UPDATE nomad_store.categories SET description = 'Admin Updated' WHERE category_name = 'Admin Test Cat';
COMMIT;

BEGIN;
DELETE FROM nomad_store.categories WHERE category_name = 'Admin Test Cat';
COMMIT;

RESET ROLE;

SET ROLE db_reader_user;
SELECT current_user;
SELECT COUNT(*) FROM nomad_store.products;

BEGIN;
INSERT INTO nomad_store.categories (category_name, description) VALUES ('Fail', 'Fail');
ROLLBACK;

BEGIN;
UPDATE nomad_store.products SET price = price * 1.10;
ROLLBACK;

BEGIN;
DELETE FROM nomad_store.users WHERE user_id = 1;
ROLLBACK;

RESET ROLE;


TRUNCATE TABLE 
    nomad_store.payment_transactions, 
    nomad_store.order_items, 
    nomad_store.reviews, 
    nomad_store.orders, 
    nomad_store.product_images, 
    nomad_store.products, 
    nomad_store.addresses, 
    nomad_store.users, 
    nomad_store.suppliers, 
    nomad_store.categories 
RESTART IDENTITY CASCADE;

INSERT INTO nomad_store.categories (category_name, description) VALUES 
    ('Smartphones & Gadgets', 'Latest Apple iPhones, Samsung, and premium devices'),
    ('Streetwear & Apparel', 'Hype clothing, sneakers, hoodies, and accessories'),
    ('Gaming Gear', 'Mechanical keyboards, gaming mice, and monitors'),
    ('Drinks & Snacks', 'Energy drinks, imported sweets, and snacks'),
    ('Books & Study', 'Programming guides, self-development, and manga');

INSERT INTO nomad_store.suppliers (supplier_name, contact_name, email, phone_number, address) VALUES 
    ('Alser Computers', 'Dias Akhmetov', 'dias@alser.kz', '+77015551122', 'Almaty, Abaya 44'),
    ('Nike Central Asia', 'Arman Maratov', 'arman@nike.com.kz', '+77027773344', 'Almaty, Rozybakieva 247'),
    ('Mechta Distribution', 'Rustam Ibragimov', 'rustam@mechta.kz', '+77078889911', 'Astana, Kenesary 12'),
    ('RedBull Kazakhstan', 'Alina Saparova', 'alina@redbull.kz', '+77052223355', 'Almaty, Dostyk 85'),
    ('Meloman Books', 'Oleg Pak', 'oleg@meloman.kz', '+77471110099', 'Almaty, Gogolya 58');

INSERT INTO nomad_store.users (username, email, password, phone_number, gender) VALUES 
    ('serzhan_atyrau', 'serzhan@nomad.kz', 'secure_pass_777', '+77071112233', 'M'),
    ('alihan_pro', 'alihan@gmail.com', 'ali2005', '+77019998877', 'M'),
    ('malika_m', 'malika_best@mail.ru', 'mali_flower', '+77024445566', 'F'),
    ('daniyar_kz', 'dani@yandex.kz', 'danya999', '+77051112244', 'M'),
    ('asel_smart', 'asel_tech@outlook.com', 'asel_pass', '+77473338899', 'F');

INSERT INTO nomad_store.addresses (user_id, city, street_address, postal_code, is_default) VALUES 
    ((SELECT user_id FROM nomad_store.users WHERE username = 'serzhan_atyrau'), 'Atyrau', 'Satpayeva St. 15', '060000', TRUE),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'alihan_pro'), 'Almaty', 'Zhandosova St. 30', '050040', TRUE),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'malika_m'), 'Astana', 'Mangilik El Ave. 25', '010000', TRUE),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'daniyar_kz'), 'Shymkent', 'Tauke Khan Ave. 88', '160000', TRUE),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'asel_smart'), 'Aktau', '12th Microdistrict', '130000', TRUE);

INSERT INTO nomad_store.products (category_id, supplier_id, name, description, price, stock_quantity) VALUES 
    ((SELECT category_id FROM nomad_store.categories WHERE category_name = 'Smartphones & Gadgets'), (SELECT supplier_id FROM nomad_store.suppliers WHERE email = 'dias@alser.kz'), 'iPhone 15 Pro Max 256GB', 'Natural Titanium', 650000.00, 15),
    ((SELECT category_id FROM nomad_store.categories WHERE category_name = 'Streetwear & Apparel'), (SELECT supplier_id FROM nomad_store.suppliers WHERE email = 'arman@nike.com.kz'), 'Nike Air Force 1 Low', 'Classic All-White', 55000.00, 40),
    ((SELECT category_id FROM nomad_store.categories WHERE category_name = 'Gaming Gear'), (SELECT supplier_id FROM nomad_store.suppliers WHERE email = 'rustam@mechta.kz'), 'Logitech G Pro X Superlight', 'Gaming mouse', 68000.00, 25),
    ((SELECT category_id FROM nomad_store.categories WHERE category_name = 'Drinks & Snacks'), (SELECT supplier_id FROM nomad_store.suppliers WHERE email = 'alina@redbull.kz'), 'Monster Energy Ultra 0.5L', 'Sugar-free drink', 1200.00, 300),
    ((SELECT category_id FROM nomad_store.categories WHERE category_name = 'Books & Study'), (SELECT supplier_id FROM nomad_store.suppliers WHERE email = 'oleg@meloman.kz'), 'Learning SQL 3rd Edition', 'Practical database guide', 18000.00, 10);

INSERT INTO nomad_store.product_images (product_id, image_url, is_main) VALUES 
    ((SELECT product_id FROM nomad_store.products WHERE name = 'iPhone 15 Pro Max 256GB'), 'http://nomadstore.kz/static/iphone15.jpg', TRUE),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Nike Air Force 1 Low'), 'http://nomadstore.kz/static/airforce1.jpg', TRUE),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Logitech G Pro X Superlight'), 'http://nomadstore.kz/static/logitech_mouse.jpg', TRUE),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Monster Energy Ultra 0.5L'), 'http://nomadstore.kz/static/monster_ultra.jpg', TRUE),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Learning SQL 3rd Edition'), 'http://nomadstore.kz/static/sql_book.jpg', TRUE);

INSERT INTO nomad_store.orders (user_id, address_id, order_date, total_amount, status) VALUES 
    ((SELECT user_id FROM nomad_store.users WHERE username = 'serzhan_atyrau'), (SELECT address_id FROM nomad_store.addresses WHERE city = 'Atyrau'), '2026-04-10 12:30:00', 650000.00, 'Delivered'),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'alihan_pro'), (SELECT address_id FROM nomad_store.addresses WHERE city = 'Almaty'), '2026-05-01 18:45:00', 57400.00, 'Cancelled'),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'malika_m'), (SELECT address_id FROM nomad_store.addresses WHERE city = 'Astana'), '2026-05-12 11:15:00', 55000.00, 'Shipped'),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'daniyar_kz'), (SELECT address_id FROM nomad_store.addresses WHERE city = 'Shymkent'), '2026-05-20 09:00:00', 18000.00, 'Pending'),
    ((SELECT user_id FROM nomad_store.users WHERE username = 'asel_smart'), (SELECT address_id FROM nomad_store.addresses WHERE city = 'Aktau'), '2026-05-24 21:10:00', 68000.00, 'Pending');

INSERT INTO nomad_store.order_items (order_id, product_id, quantity, price_at_purchase) VALUES 
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 650000.00), (SELECT product_id FROM nomad_store.products WHERE name = 'iPhone 15 Pro Max 256GB'), 1, 650000.00),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 57400.00), (SELECT product_id FROM nomad_store.products WHERE name = 'Nike Air Force 1 Low'), 1, 55000.00),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 57400.00), (SELECT product_id FROM nomad_store.products WHERE name = 'Monster Energy Ultra 0.5L'), 2, 1200.00),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 55000.00), (SELECT product_id FROM nomad_store.products WHERE name = 'Nike Air Force 1 Low'), 1, 55000.00),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 18000.00), (SELECT product_id FROM nomad_store.products WHERE name = 'Learning SQL 3rd Edition'), 1, 18000.00);

INSERT INTO nomad_store.payment_transactions (order_id, payment_method, amount, status) VALUES 
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 650000.00), 'Kaspi QR', 650000.00, 'Completed'),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 57400.00), 'Kaspi Gold', 57400.00, 'Completed'),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 55000.00), 'Halyk QR', 55000.00, 'Completed'),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 18000.00), 'Credit Card', 18000.00, 'Completed'),
    ((SELECT order_id FROM nomad_store.orders WHERE total_amount = 68000.00), 'Kaspi Gold', 68000.00, 'Failed');

INSERT INTO nomad_store.reviews (product_id, user_id, rating, comment) VALUES 
    ((SELECT product_id FROM nomad_store.products WHERE name = 'iPhone 15 Pro Max 256GB'), (SELECT user_id FROM nomad_store.users WHERE username = 'serzhan_atyrau'), 5, 'Телефон пушка!'),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Nike Air Force 1 Low'), (SELECT user_id FROM nomad_store.users WHERE username = 'alihan_pro'), 4, 'Классика, все топ.'),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Logitech G Pro X Superlight'), (SELECT user_id FROM nomad_store.users WHERE username = 'asel_smart'), 5, 'Мышка нереально легкая.'),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Monster Energy Ultra 0.5L'), (SELECT user_id FROM nomad_store.users WHERE username = 'alihan_pro'), 5, 'Лучший вкус.'),
    ((SELECT product_id FROM nomad_store.products WHERE name = 'Learning SQL 3rd Edition'), (SELECT user_id FROM nomad_store.users WHERE username = 'daniyar_kz'), 5, 'Книга очень полезная.');


SELECT name, price FROM nomad_store.products WHERE name = 'Logitech G Pro X Superlight';
UPDATE nomad_store.products SET price = 72000.00 WHERE name = 'Logitech G Pro X Superlight';

SELECT order_id, status FROM nomad_store.orders WHERE status = 'Pending';
UPDATE nomad_store.orders SET status = 'Processing' WHERE status = 'Pending';

SELECT p.name, p.price, c.category_name FROM nomad_store.products p JOIN nomad_store.categories c ON p.category_id = c.category_id WHERE c.category_name = 'Streetwear & Apparel';
UPDATE nomad_store.products p SET price = p.price * 0.95 FROM nomad_store.categories c WHERE p.category_id = c.category_id AND c.category_name = 'Streetwear & Apparel';

BEGIN;
DELETE FROM nomad_store.payment_transactions WHERE status = 'Failed';
SELECT COUNT(*) FROM nomad_store.payment_transactions WHERE status = 'Failed';
ROLLBACK;

ALTER USER db_admin_user NOSUPERUSER;