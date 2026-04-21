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

-- ========================================
-- Query 3: Customer Lifespan Calculation
-- ========================================
-- Purpose:
-- Measure the duration of each customer's engagement by calculating the time between their first and last purchase.
--
-- Business Context:
-- Customer lifespan helps quantify how long customers remain active.
-- A lifespan of 0 days indicates one-time buyers, while longer lifespans indicate repeat engagement and higher retention.
--
-- Output:
-- - first_purchase: Customer’s first transaction date
-- - last_purchase: Customer’s most recent transaction date
-- - lifespan_days: Total active duration in days

SELECT
    CustomerID,
    MIN(date(InvoiceDate)) AS first_purchase,
    MAX(date(InvoiceDate)) AS last_purchase,
    CAST(julianday(MAX(date(InvoiceDate))) - julianday(MIN(date(InvoiceDate))) AS INTEGER) AS lifespan_days
FROM ecommerce_cleaned
GROUP BY CustomerID
LIMIT 20;

-- ========================================
-- Query 4: Average Customer Lifespan
-- ========================================
-- Purpose:
-- Calculate the average duration customers remain active across the dataset.
--
-- Business Context:
-- Average customer lifespan provides a high-level view of retention.
-- It is a key input for Customer Lifetime Value (CLV) calculations and helps evaluate overall customer engagement.
--
-- Output:
-- - avg_customer_lifespan: Average number of days customers remain active

SELECT
    ROUND(AVG(lifespan_days), 2) AS avg_customer_lifespan
FROM (
    SELECT
        CustomerID,
        CAST(julianday(MAX(date(InvoiceDate))) - julianday(MIN(date(InvoiceDate))) AS INTEGER) AS lifespan_days
    FROM ecommerce_cleaned
    GROUP BY CustomerID
);

-- ========================================
-- Query 5: Monthly Cohort Activity (Customer Retention Base Table)
-- ========================================
-- Purpose:
-- Group customers into cohorts based on their first purchase month and track their activity in subsequent months.
--
-- Business Context:
-- Cohort analysis allows us to measure customer retention over time by observing how many customers from each cohort return in future periods.
-- This helps identify retention trends and drop-off patterns across different customer groups.
--
-- Output:
-- - cohort_month: Month of customer's first purchase
-- - txn_month: Month of activity
-- - active_customers: Number of customers active in that month

WITH cohort AS (
    SELECT
        CustomerID,
        strftime('%Y-%m', MIN(InvoiceDate)) AS cohort_month
    FROM ecommerce_cleaned
    GROUP BY CustomerID
),
transactions AS (
    SELECT
        CustomerID,
        strftime('%Y-%m', InvoiceDate) AS txn_month
    FROM ecommerce_cleaned  
)
SELECT
    c.cohort_month,
    t.txn_month,
    COUNT(DISTINCT t.CustomerID) AS active_customers
FROM cohort c
JOIN transactions t 
    ON c.CustomerID = t.CustomerID
GROUP BY c.cohort_month, t.txn_month
ORDER BY c.cohort_month, t.txn_month;