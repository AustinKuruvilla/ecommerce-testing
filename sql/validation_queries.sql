USE ecommerce_test;

-- Order totals should equal the sum of their item subtotals.
SELECT o.order_id, o.order_total,
       SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_total
HAVING o.order_total <> SUM(oi.quantity * oi.unit_price);

-- This query should return no rows when inventory is valid.
SELECT product_id, sku, inventory_quantity
FROM products
WHERE inventory_quantity < 0;

-- Find order items whose stored unit price differs from the current catalog.
SELECT oi.order_id, p.sku, oi.unit_price AS order_price, p.unit_price AS current_price
FROM order_items AS oi
JOIN products AS p ON p.product_id = oi.product_id
WHERE oi.unit_price <> p.unit_price;