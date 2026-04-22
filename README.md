## Customer Analytics & Retention Intelligence (SQL | Python | Excel)

# **Overview**

This project analyzes ~18,500+ cleaned transactional records across 4,300+ customers to identify retention patterns, quantify churn, and measure customer lifetime value (CLV).

Using SQL and Python, the analysis translates raw transaction data into actionable insights on customer behavior, revenue concentration, and churn risk.

# **Business Problem**

The business is generating $8.9M+ in total revenue, but:

- ~61.6% of customers are inactive (churned) under a 30-day definition
- A majority of customers fail to return after their first purchase
- High-value customers are disengaging, creating significant revenue leakage risk

Without intervention, the business risks losing a substantial portion of future revenue due to poor retention and lack of targeted re-engagement strategies

# **Objective**

- Segment customers based on behavior (RFM)
- Measure churn and retention patterns
- Quantify customer lifetime value (CLV)
- Identify revenue risk and retention opportunities

# **Key Metrics**

- Total Revenue: $8.9M+
- Total Transactions: 18,500+
- Total Customers: 4,300+
- Average Order Value (AOV): ~$480
- Repeat Purchase Rate: ~65.6%
- Churn Rate (30-day definition): ~61.6%
- Average Customer Lifespan: ~130 days

# **Approach**

**Data Preparation & EDA**
- Cleaned and validated transactional data
- Removed duplicates, nulls, and invalid transactions
- Explored distributions and purchasing behavior

**Descriptive Analysis (SQL + Python)**
- Monthly revenue and transaction trends
- Average order value (AOV) and purchase frequency
- Repeat customer rate (~65%)
- Country-level performance

**Customer Segmentation (RFM)**

Customers were segmented using:

- Recency (time since last purchase)
- Frequency (purchase count)
- Monetary value (total spend)

Segments:

- VIP
- Loyal
- At Risk
- Regular

**Retention Analysis**
- Churn defined as no purchase within 30 days
- Cohort analysis used to track retention over time
- Built retention matrix and heatmap

Key finding:
- **Retention drops sharply after the first purchase**, indicating weak early-stage engagement

**Customer Lifetime Value (CLV)**

CLV was calculated using:

CLV = Average Order Value × Purchase Frequency × Customer Lifespan

CLV was analyzed across customer segments to understand long-term revenue contribution.

**Key Insights**
- 61.6% churn rate indicates a major retention problem
- Most customers drop off shortly after their first purchase
- At Risk customers have the highest average CLV (~$430+), exceeding VIP customers (~$220)
- This suggests that the most valuable customers are actively disengaging

# **Business Impact**

This analysis reveals:

- A large portion of revenue is tied to customers at risk of churn
- The business has a high-value customer retention problem, not just a volume problem
- Targeted retention strategies (discounts, re-engagement campaigns) could recover significant revenue
- Customer prioritization can be optimized by focusing on high-CLV At Risk segments

# **Visualizations**

**Retention Heatmap**

![Retention Heatmap](reports/retention_heatmap.png)

This heatmap shows customer retention by cohort over time.
There is a sharp drop-off after the first purchase, highlighting early churn risk.

**CLV by Customer Segment**

![CLV by Customer Segment](reports/clv_by_segment.png)

This chart shows that At Risk customers generate the highest lifetime value, indicating revenue concentration among disengaging customers.

**Excel Dashboard**

![Excel Dashboard](reports/excel_dashboard.png)

This dashboard summarizes key KPIs including revenue, transactions, customer count, AOV, and repeat rate, providing a high-level view of business performance.

**Tech Stack**
- SQL (SQLite)
- Python (pandas, numpy, matplotlib, seaborn)
- Jupyter Notebooks

**Conclusion**

This project demonstrates how transactional data can be used to:

- Identify churn and retention issues 
- Quantify customer value
- Detect revenue leakage
- Enable data-driven customer strategy

