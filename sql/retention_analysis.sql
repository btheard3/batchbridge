-- ========================================
-- BatchBridge: Retention Analysis (SQL)
-- ========================================
-- Goal: Define churn and calculate retention-related metrics

WITH snapshot AS (
    SELECT MAX(date(InvoiceDate)) AS max_date
    FROM ecommerce_cleaned
),
customer_last_purchase AS (
    SELECT
        CustomerID,
        MAX(date(InvoiceDate)) AS last_purchase
    FROM ecommerce_cleaned
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    CAST(julianday(s.max_date) - julianday(c.last_purchase) AS INTEGER) AS days_since_last_purchase,
    CASE
        WHEN (julianday(s.max_date) - julianday(c.last_purchase)) > 30 THEN 1
        ELSE 0
    END AS is_churned
FROM customer_last_purchase c
CROSS JOIN snapshot s
LIMIT 20;

WITH snapshot AS (
    SELECT MAX(date(InvoiceDate)) AS max_date
    FROM ecommerce_cleaned
),
customer_last_purchase AS (
    SELECT
        CustomerID,
        MAX(date(InvoiceDate)) AS last_purchase
    FROM ecommerce_cleaned
    GROUP BY CustomerID
),
churned AS (
    SELECT 
        CustomerID,
        CASE
            WHEN (julianday(s.max_date) - julianday(c.last_purchase)) > 30 THEN 1
            ELSE 0
        END AS is_churned
    FROM customer_last_purchase c
    CROSS JOIN snapshot s
)
SELECT 
    ROUND(AVG(is_churned) * 100, 2) AS churn_rate_percent
FROM churned;