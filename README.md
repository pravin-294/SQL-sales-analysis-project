# SQL-sales-analysis-project

## 📌 Project Overview
This project is an **end-to-end SQL sales data analysis project** that demonstrates how raw retail sales data can be cleaned, transformed, and analyzed to generate meaningful business insights.

The project simulates a **real-world retail analytics workflow**, starting from an unclean dataset and ending with business-driven analytical queries using **MySQL**.

---

## 🎯 Objectives
- Clean and standardize raw sales data  
- Handle missing values, duplicates, and inconsistent formats  
- Prepare an analysis-ready dataset  
- Answer important business questions using SQL  
- Demonstrate strong SQL fundamentals and analytical thinking  

---

## 🗃️ Dataset Description
The dataset represents **retail sales transactions**, where each row corresponds to a customer purchase.

### Tables Used
- **sales_store** → Raw, uncleaned sales data  
- **sales_s** → Cleaned and analysis-ready data  

### Key Columns
- Transaction details: `transaction_id`, `purchase_date`, `time_of_purchase`, `status`  
- Customer details: `customer_id`, `customer_name`, `customer_age`, `gender`  
- Product details: `product_id`, `product_name`, `product_category`, `price`, `quantity`  
- Payment details: `payment_mode`  

---

## 🧹 Data Cleaning & Preparation
The following data cleaning steps were performed using SQL:

- Standardized `purchase_date` into `YYYY-MM-DD` format  
- Corrected column data types (`INT`, `VARCHAR`, `DATE`, `TIME`)  
- Removed duplicate transactions using `ROW_NUMBER()` and CTEs  
- Converted blank values into `NULL`  
- Removed records with invalid transaction IDs  
- Standardized categorical values:
  - Gender (`M`, `F` → `Male`, `Female`)
  - Payment mode (`CC` → `Credit Card`)  
- Created a clean analytics table (`sales_s`)  

---

## 📊 Business Questions Answered
1. Top 5 most-selling products by quantity  
2. Most frequently cancelled products  
3. Peak time of day for purchases  
4. Top 5 highest-spending customers  
5. Highest revenue-generating product categories  
6. Cancellation and return rates per category  
7. Most preferred payment mode  
8. Impact of age groups on purchasing behavior  
9. Monthly sales trends  
10. Gender-wise product category preferences  

---

## 💼 Business Impact
The analysis helps businesses to:
- Optimize inventory and stock planning  
- Identify high-value customers  
- Reduce cancellations and returns  
- Improve marketing strategies  
- Understand seasonal and demographic trends  
- Enhance customer payment experience  

---

## 🛠️ SQL Skills Demonstrated
- Data Cleaning and Transformation  
- CASE WHEN and Conditional Aggregation  
- Common Table Expressions (CTEs)  
- Window Functions (ROW_NUMBER)  
- Date and Time Functions  
- GROUP BY, ORDER BY, and ROLLUP  
- Business-focused SQL querying  

---

## 📄 Project Documentation
Detailed project documentation is available here:

**docs/SQL_sales_analysis_project.pdf**

---

## 🚀 How to Run the Project
1. Import `sales_store.csv` into MySQL  
2. Run `sales_analysis.sql` step by step  
3. The cleaned table `sales_s` will be created  
4. Execute analysis queries to reproduce insights  

---

## 👤 Author
**Pravin Kamble**  
Aspiring Data Analyst  
Skills: SQL | Data Cleaning | Data Analysis | Business Analytics  

---

## ⭐ Why This Project Matters
This project demonstrates:
- Real-world data cleaning challenges  
- End-to-end SQL analytics workflow  
- Strong problem-solving and analytical thinking  
- Ability to convert raw data into business insights  


