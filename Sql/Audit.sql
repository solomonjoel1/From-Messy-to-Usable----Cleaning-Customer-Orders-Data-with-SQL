SELECT * FROM raw_customers LIMIT 100;

SELECT * FROM raw_orders LIMIT 10;

-- 1. How many duplicate customer_id?
SELECT customer_id, COUNT(*) AS dup_count
FROM raw_customers
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY customer_id;

-- 2. How many duplicate order_id?
SELECT order_id, COUNT(*) AS dup_count
FROM raw_orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY order_id;

-- 3. NULLs in customers?
SELECT
  COUNT(*) AS total,
  COUNT(*) FILTER (WHERE customer_name IS NULL) AS null_name,
  COUNT(*) FILTER (WHERE city IS NULL) AS null_city,
  COUNT(*) FILTER (WHERE phone IS NULL) AS null_phone,
  COUNT(*) FILTER (WHERE email IS NULL) AS null_email
FROM raw_customers;

-- 4. NULLs in orders?
SELECT
  COUNT(*) AS total,
  COUNT(*) FILTER (WHERE order_date IS NULL) AS null_date,
  COUNT(*) FILTER (WHERE amount IS NULL) AS null_amount
FROM raw_orders;

-- 5. Messy city values - same city, different spelling
SELECT DISTINCT city FROM raw_customers ORDER BY city;

-- 6. Messy status values
SELECT DISTINCT status FROM raw_orders ORDER BY status;

-- 7. Orphan orders - orders with customer_id that doesn't exist
SELECT COUNT(*) AS orphan_orders
FROM raw_orders o
LEFT JOIN raw_customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 8. Negative / bad amounts
SELECT * FROM raw_orders WHERE amount = '-5000' LIMIT 5;




