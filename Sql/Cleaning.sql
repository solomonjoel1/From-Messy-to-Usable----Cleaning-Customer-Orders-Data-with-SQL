DROP TABLE IF EXISTS clean_customers;
DROP TABLE IF EXISTS clean_orders;

CREATE TABLE clean_customers AS
SELECT DISTINCT ON (customer_id)
  customer_id,
  INITCAP(TRIM(customer_name)) AS customer_name,
  INITCAP(TRIM(city)) AS city,
  CASE WHEN phone IS NULL OR TRIM(phone) = 'unknown' THEN NULL
    ELSE REPLACE(TRIM(phone), '-', '') END AS phone,
  CASE WHEN email IS NULL OR TRIM(email) = 'no-email' THEN NULL
    ELSE LOWER(TRIM(email)) END AS email
FROM raw_customers
WHERE customer_id IS NOT NULL
  AND customer_name IS NOT NULL
  AND city IS NOT NULL
ORDER BY customer_id;

CREATE TABLE clean_orders AS
SELECT
  order_id,
  customer_id,
  CASE
    WHEN order_date IS NULL THEN NULL
    WHEN order_date LIKE '%/%' THEN TO_DATE(order_date, 'DD/MM/YYYY')
    ELSE TO_DATE(order_date, 'YYYY-MM-DD')
  END AS order_date_clean,
  CASE WHEN amount IS NULL THEN NULL
    ELSE CAST(REPLACE(TRIM(amount), ',', '') AS NUMERIC) END AS amount_clean,
  INITCAP(TRIM(status)) AS status_clean
FROM raw_orders
WHERE order_id IS NOT NULL
  AND order_date IS NOT NULL
  AND amount IS NOT NULL
  AND CAST(REPLACE(TRIM(amount), ',', '') AS NUMERIC) > 0;

DELETE FROM clean_orders
WHERE customer_id NOT IN (SELECT customer_id FROM clean_customers);


-- Find amounts that are NOT numbers
SELECT DISTINCT amount, COUNT(*) AS how_many
FROM raw_orders
GROUP BY amount
ORDER BY amount;


DROP TABLE IF EXISTS clean_customers;
DROP TABLE IF EXISTS clean_orders;

CREATE TABLE clean_customers AS
SELECT DISTINCT ON (customer_id)
  customer_id,
  INITCAP(TRIM(customer_name)) AS customer_name,
  INITCAP(TRIM(city)) AS city,
  CASE WHEN phone IS NULL OR TRIM(phone) = 'unknown' THEN NULL
    ELSE REPLACE(TRIM(phone), '-', '') END AS phone,
  CASE WHEN email IS NULL OR TRIM(email) = 'no-email' THEN NULL
    ELSE LOWER(TRIM(email)) END AS email
FROM raw_customers
WHERE customer_id IS NOT NULL
  AND customer_name IS NOT NULL
  AND city IS NOT NULL
ORDER BY customer_id;

CREATE TABLE clean_orders AS
SELECT
  order_id,
  customer_id,
  CASE
    WHEN order_date IS NULL THEN NULL
    WHEN order_date LIKE '%/%' THEN TO_DATE(order_date, 'DD/MM/YYYY')
    ELSE TO_DATE(order_date, 'YYYY-MM-DD')
  END AS order_date_clean,
  -- SAFER AMOUNT: only CAST if it looks like a number
  CASE
    WHEN TRIM(amount) ~ '^-?[0-9,]+\.?[0-9]*$'
    THEN CAST(REPLACE(TRIM(amount), ',', '') AS NUMERIC)
    ELSE NULL
  END AS amount_clean,
  INITCAP(TRIM(status)) AS status_clean
FROM raw_orders
WHERE order_id IS NOT NULL
  AND order_date IS NOT NULL
  AND amount IS NOT NULL;

-- Remove rows where amount was bad / negative / zero
DELETE FROM clean_orders WHERE amount_clean IS NULL OR amount_clean <= 0;

-- Remove orphan orders
DELETE FROM clean_orders
WHERE customer_id NOT IN (SELECT customer_id FROM clean_customers);





SELECT COUNT(*) FROM clean_customers;
SELECT COUNT(*) FROM clean_orders;
SELECT * FROM clean_customers LIMIT 100;
SELECT * FROM clean_orders LIMIT 100;