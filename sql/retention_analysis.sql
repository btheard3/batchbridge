-- ========================================
-- BatchBridge: Retention Analysis (SQL)
-- ========================================
-- Goal: Define churn and calculate retention-related 

-- ========================================
-- Query 1: Customer Churn Flag (Days Since Last Purchase)
-- ========================================
-- Purpose:
-- Identify how recently each customer has made a purchase and flag whether they are churned.
--
-- Business Context:
-- Customers who have not purchased within a defined time window (30 days) are considered inactive.
-- This helps identify customers at risk of being lost and supports retention strategy development.
--
-- Output:
-- - days_since_last_purchase: Number of days since last transaction
-- - is_churned: 1 = churned (inactive), 0 = active

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

-- ========================================
-- Query 2: Overall Customer Churn Rate
-- ========================================
-- Purpose:
-- Calculate the percentage of customers who are classified as churned.
--
-- Business Context:
-- Churn rate measures the proportion of customers who have stopped engaging with the business.
-- A high churn rate indicates potential issues with retention and customer lifetime value.
--
-- Output:
-- - churn_rate_percent: Percentage of customers considered churned under the 30-day rule

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