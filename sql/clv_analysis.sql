-- ========================================
-- BatchBridge: Customer Lifetime Value (CLV) Analysis
-- ========================================
-- Goal: Estimate customer value over time and identify high-value segments

-- ========================================
-- Step 5: Customer Lifetime Value Base Table
-- ========================================
-- Purpose:
-- Aggregate total revenue and customer tenure to support CLV calculation

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_transactions,
    SUM(SalesAmount) AS total_revenue,
    AVG(SalesAmount) AS avg_order_value,
    MIN(date(InvoiceDate)) AS first_purchase,
    MAX(date(InvoiceDate)) AS last_purchase,
    CAST(julianday(MAX(date(InvoiceDate))) - julianday(MIN(date(InvoiceDate))) AS INTEGER) AS lifespan_days
FROM ecommerce_cleaned
GROUP BY CustomerID;