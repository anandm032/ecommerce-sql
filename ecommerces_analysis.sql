SELECT * FROM customers;
SELECT id, name, category, price
FROM products
ORDER BY price DESC;
SELECT o.id, 
       c.name AS customer, 
       o.order_date, 
       o.status
FROM orders o
JOIN customers c 
     ON o.customer_id = c.id
WHERE o.order_date >= '2025-08-01'
  AND o.order_date < '2025-09-01';
SELECT p.id, 
       p.name AS product, 
       p.category,
       SUM(oi.quantity * oi.unit_price) AS total_sales,
       SUM(oi.quantity) AS total_qty
FROM order_items oi
JOIN products p 
     ON oi.product_id = p.id
GROUP BY p.id
ORDER BY total_sales DESC;
SELECT p.name,
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p 
     ON p.id = oi.product_id
GROUP BY p.id
ORDER BY total_sales DESC
LIMIT 3;
SELECT c.id AS customer_id, 
       c.name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o 
     ON c.id = o.customer_id
JOIN order_items oi 
     ON o.id = oi.order_id
GROUP BY c.id
ORDER BY total_spent DESC;
SELECT o.id AS order_id, 
       c.name AS customer,
       o.order_date, 
       o.status,
       (SELECT SUM(quantity * unit_price)
        FROM order_items
        WHERE order_items.order_id = o.id) AS order_total
FROM orders o
JOIN customers c 
     ON o.customer_id = c.id;
SELECT ct.customer_id, 
       ct.name, 
       ct.total_spent
FROM (
    SELECT c.id AS customer_id, 
           c.name,
           COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o 
         ON c.id = o.customer_id
    LEFT JOIN order_items oi 
         ON o.id = oi.order_id
    GROUP BY c.id
) ct
WHERE ct.total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
        FROM customers c
        LEFT JOIN orders o 
             ON c.id = o.customer_id
        LEFT JOIN order_items oi 
             ON o.id = oi.order_id
        GROUP BY c.id
    )
);
SELECT * 
FROM customer_totals
ORDER BY total_spent DESC;
EXPLAIN QUERY PLAN
SELECT p.id, 
       p.name AS product, 
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p 
     ON oi.product_id = p.id
GROUP BY p.id;
