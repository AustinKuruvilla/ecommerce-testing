USE ecommerce_test;

INSERT INTO customers (email, password_hash) VALUES
    ('qa.customer@example.test', '$2b$12$replace_with_a_test_hash');

INSERT INTO products (sku, name, unit_price, inventory_quantity) VALUES
    ('QA-TSHIRT-001', 'Blue Top', 29.99, 25),
    ('QA-JEANS-001', 'Men Tshirt', 19.99, 40),
    ('QA-DRESS-001', 'Summer White Top', 35.00, 12);