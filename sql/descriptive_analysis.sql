-- ========================================
-- BatchBridge: Descriptive Analysis (SQL)
-- ========================================
-- Goal: Recreate key business KPIs and trends using SQL
-- Dataset: ecommerce_cleaned (SQLite)

-- ========================================
-- 1. Monthly Revenue & Transactions
-- ========================================
-- Purpose: Analyze revenue trends and seasonality over time

SELECT
    strftime('%Y-%m', InvoiceDate) AS month,
    SUM(SalesAmount) AS total_sales,
    COUNT(DISTINCT InvoiceNo) AS total_transactions
FROM ecommerce_cleaned
GROUP BY month
ORDER BY month;


-- ========================================
-- 2. Average Order Value (AOV)
-- ========================================
-- Purpose: Measure average revenue per transaction

SELECT
    SUM(SalesAmount) * 1.0 / COUNT(DISTINCT InvoiceNo) AS avg_order_value
FROM ecommerce_cleaned;


-- ========================================
-- 3. Transactions per Customer
-- ========================================
-- Purpose: Identify high-frequency (power) customers

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS transactions
FROM ecommerce_cleaned
GROUP BY CustomerID
ORDER BY transactions DESC
LIMIT 10;


-- ========================================
-- 4. Repeat Customer Rate
-- ========================================
-- Purpose: Measure customer retention and loyalty

WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM ecommerce_cleaned
    GROUP BY CustomerID
)
SELECT
    COUNT(CASE WHEN order_count > 1 THEN 1 END) * 1.0 / COUNT(*) AS repeat_customer_rate
FROM customer_orders;


-- ========================================
-- 5. Top Countries by Revenue
-- ========================================
-- Purpose: Identify key geographic markets

SELECT
    Country,
    SUM(SalesAmount) AS total_sales
FROM ecommerce_cleaned
GROUP BY Country
ORDER BY total_sales DESC
LIMIT 10;


-- ========================================
-- 6. Top Products by Revenue
-- ========================================
-- Purpose: Identify best-selling products driving revenue

SELECT
    Description,
    SUM(SalesAmount) AS total_sales
FROM ecommerce_cleaned
GROUP BY Description
ORDER BY total_sales DESC
LIMIT 10;

