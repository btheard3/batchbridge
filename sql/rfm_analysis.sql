-- ========================================
-- BatchBridge: RFM Analysis (SQL)
-- ========================================
-- Goal: Calculate Recency, Frequency, Monetary metrics
-- and create customer segments using SQLite

-- ========================================
-- 1. Base RFM Metrics
-- ========================================

WITH snapshot AS (
    SELECT MAX(date(InvoiceDate)) AS max_date
    FROM ecommerce_cleaned
),
customer_rfm AS (
    SELECT 
        CustomerID,
        MAX(date(InvoiceDate)) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(SalesAmount) AS Monetary
    FROM ecommerce_cleaned
    GROUP BY CustomerID
)
SELECT 
    c.CustomerID,
    CAST(julianday(s.max_date) - julianday(c.last_purchase_date) AS INTEGER) AS Recency,
    c.Frequency,
    ROUND(c.Monetary, 2) AS Monetary
FROM customer_rfm c
CROSS JOIN snapshot s
ORDER BY Monetary DESC
LIMIT 20;

-- ========================================
-- 2. RFM Scoring (1–5 buckets)
-- ========================================

WITH snapshot AS (
    SELECT MAX(date(InvoiceDate)) AS max_date
    FROM ecommerce_cleaned
),
customer_rfm AS (
    SELECT
        CustomerID,
        MAX(date(InvoiceDate)) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(SalesAmount) AS Monetary
    FROM ecommerce_cleaned
    GROUP BY CustomerID
),
rfm_base AS (
    SELECT 
        c.CustomerID,
        CAST(julianday(s.max_date) - julianday(c.last_purchase_date) AS INTEGER) AS Recency,
        c.Frequency,
        c.Monetary,
    FROM customer_rfm c
    CROSS JOIN snapshot s
) 

SELECT 
    CustomerID,
    Recency,
    Frequency,
    Monetary,

    -- Recency Score (LOW = better)
    CASE
        WHEN Recency <= 10 THEN 5
        WHEN Recency <= 30 THEN 4
        WHEN Recency <= 60 THEN 3
        WHEN Recency <= 120 THEN 2
        ELSE 1
    END AS R_score,

    -- Frequency Score (HIGH = better)
    CASE
        WHEN Frequency >= 100 THEN 5
        WHEN Frequency >= 50 THEN 4
        WHEN Frequency >= 20 THEN 3
        WHEN Frequency >= 5 THEN 2
        ELSE 1
    END AS F_score,

    -- Monetary Score (HIGH = better)
    CASE
        WHEN Monetary >= 100000 THEN 5
        WHEN Monetary >= 50000 THEN 4
        WHEN Monetary >= 20000 THEN 3
        WHEN Monetary >= 5000 THEN 2
        ELSE 1
    END AS M_score

FROM rfm_base
ORDER BY Monetary DESC
LIMIT 20;

-- ========================================
-- 3. Customer Segmentation (SQL)
-- ========================================

WITH snapshot AS (
    SELECT MAX(date(InvoiceDate)) AS max_date
    FROM ecommerce_cleaned
),
customer_rfm AS (
    SELECT
        CustomerID,
        MAX(date(InvoiceDate)) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(SalesAmount) AS Monetary
    FROM ecommerce_cleaned
    GROUP BY CustomerID
),
rfm_base AS (
    SELECT
        c.CustomerID,
        CAST(julianday(s.max_date) - julianday(c.last_purchase_date) AS INTEGER) AS Recency,
        c.Frequency,
        c.Monetary
    FROM customer_rfm c
    CROSS JOIN snapshot s
),
rfm_scores AS (
    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,

        CASE
            WHEN Recency <= 10 THEN 5
            WHEN Recency <= 30 THEN 4
            WHEN Recency <= 60 THEN 3
            WHEN Recency <= 120 THEN 2
            ELSE 1
        END AS R_score,

        CASE
            WHEN Frequency >= 100 THEN 5
            WHEN Frequency >= 50 THEN 4
            WHEN Frequency >= 20 THEN 3
            WHEN Frequency >= 5 THEN 2
            ELSE 1
        END AS F_score,

        CASE
            WHEN Monetary >= 100000 THEN 5
            WHEN Monetary >= 50000 THEN 4
            WHEN Monetary >= 20000 THEN 3
            WHEN Monetary >= 5000 THEN 2
            ELSE 1
        END AS M_score
    FROM rfm_base
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    ROUND(Monetary, 2) AS Monetary,
    R_score,
    F_score,
    M_score,
    CASE
        WHEN R_score >= 4 AND F_score >= 4 AND M_score >= 4 THEN 'VIP'
        WHEN R_score >= 4 AND F_score >= 4 AND M_score < 4 THEN 'Loyal'
        WHEN R_score <= 2 AND F_score >= 3 THEN 'At Risk'
        ELSE 'Regular'
    END AS Segment
FROM rfm_scores
ORDER BY Monetary DESC
LIMIT 20;
