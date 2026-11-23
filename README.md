# 🛒 E-Commerce Sales Database & SQL Analytics (`ECommerceDB`)

An end-to-end relational database design and business intelligence query bank built in **MySQL 8.0+**[cite: 22]. This project models a complete online retail ecosystem—from product catalogs and customer orders to shipping logistics, promotional discounts, and product reviews—and answers 52 business questions using advanced SQL[cite: 22].

---

### 🏗️ Database Schema Architecture (9 Relational Tables)
The database (`ECommerceDB`) is normalized with enforced **Primary Key (`PK`)**, **Foreign Key (`FK`)**, `UNIQUE`, and `CHECK` constraints[cite: 22]:

| Table Name | Records | Description |
| :--- | :---: | :--- |
| **`Categories`** | 80 | Product department and category classifications[cite: 22] |
| **`Products`** | 85 | Product catalog with pricing, stock quantities, and category links[cite: 22] |
| **`Customers`** | 85 | Global customer directory with contact details, locations, and join dates[cite: 22] |
| **`Orders`** | 90 | Customer order headers tracking dates and order status (`Delivered`, `Shipped`, `Processing`, `Returned`, `Cancelled`)[cite: 22] |
| **`OrderDetails`** | 100 | Order line items capturing quantities sold and unit prices[cite: 22] |
| **`Reviews`** | 80 | Customer product ratings (`1–5` scale) and feedback comments[cite: 22] |
| **`Shipping`** | 85 | Fulfillment tracking with ship dates, delivery dates, and carriers (`FedEx`, `DHL`, `UPS`, `USPS`, `BlueDart`)[cite: 22] |
| **`Discounts`** | 80 | Time-bound product-level promotional discount campaigns[cite: 22] |
| **`Coupons`** | 80 | Promo codes with discount values and expiration dates[cite: 22] |

---

### 📊 Analytics Query Bank Breakdown (52 Queries)
The SQL script (`ECommerce_Project67.sql`) is organized into four progressive analytical sections (over 80% utilizing `JOIN`s and/or subqueries)[cite: 22]:

* **Section A — Basic Aggregates & Filtering (`Q1–Q10`):** Catalog size, average pricing, low-stock inventory alerts (`< 50` units), order status distribution, and active coupon tracking[cite: 22].
* **Section B — Multi-Table `JOIN` Analytics (`Q11–Q30`):** Order line-item revenue, category sales performance, `LEFT JOIN` orphan detection (unreviewed products, unshipped orders, inactive customers), carrier transit times (`DATEDIFF`), and monthly revenue trends[cite: 22].
* **Section C — Subquery-Driven Insights (`Q31–Q45`):** Scalar, correlated, `NOT IN`, and `NOT EXISTS` subqueries identifying above-average order values, second-highest priced items per category, cross-category shoppers, and category-specific discount outliers[cite: 22].
* **Section D — Advanced SQL: CTEs & Window Functions (`Q46–Q52`):** Cumulative monthly running revenue (`SUM() OVER`), intra-category revenue rankings (`RANK() OVER PARTITION BY`), and **Customer Lifetime Value (CLV)** segmentation (`Platinum`, `Gold`, `Silver`, `Bronze`) using `WITH` CTEs and `CASE` logic[cite: 22].

---

### 🚀 How to Run Locally
1. Download `ECommerce_Project67.sql` from this repository[cite: 22].
2. Open **MySQL Workbench** (or any MySQL 8.0+ client)[cite: 22].
3. Load and execute the entire script top-to-bottom—it automatically creates `ECommerceDB`, builds all 9 tables, inserts the sample records, and runs all 52 analytical queries[cite: 22].
   ```bash
   mysql -u root -p < ECommerce_Project67.sql
