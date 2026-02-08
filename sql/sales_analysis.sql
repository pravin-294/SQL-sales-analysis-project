USE mysql_practice;
SELECT * FROM sales_store;
DESC sales_store;


-- Disable safe update mode temporarily
SET SQL_SAFE_UPDATES = 0;

-- Date standardized using format validation to avoid data loss
UPDATE sales_store
SET purchase_date =
    CASE
        WHEN purchase_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(purchase_date, '%Y-%m-%d')
        WHEN purchase_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(purchase_date, '%d-%m-%Y')
        ELSE NULL
    END;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- SETTING PROPER DATA TYPES

ALTER TABLE sales_store
MODIFY transaction_id     VARCHAR(50),
MODIFY customer_id        VARCHAR(50),
MODIFY customer_name      VARCHAR(100),
MODIFY customer_age       INT,
MODIFY gender             VARCHAR(10),
MODIFY product_id         VARCHAR(50),
MODIFY product_name       VARCHAR(100),
MODIFY product_category   VARCHAR(50),
MODIFY quantiy            INT,
MODIFY prce               INT,
MODIFY payment_mode       VARCHAR(20),
MODIFY purchase_date      DATE,
MODIFY time_of_purchase   TIME,
MODIFY status             VARCHAR(20);


# CREATING A COPY 
CREATE TABLE sales_s AS
SELECT * FROM sales_store;

# ADDING PRIMARY KEY TO FIRST COLUMN
ALTER TABLE sales_s
ADD COLUMN row_id BIGINT AUTO_INCREMENT PRIMARY KEY;

SELECT * FROM sales_s;

/*============================================================================================================================================================================
-- DATA CLEANING
==============================================================================================================================================================================
-- step 1 : TO CHECK FOR DUPLICATES.
===============================================================================================================================================================================*/

SELECT transaction_id, COUNT(*)
FROM sales_s
GROUP BY transaction_id
HAVING COUNT(transaction_id) > 1;

/* duplicates
TXN855235
TXN342128
TXN240646
TXN981773 */

# CHECKING IN DETAIL
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
    FROM sales_s
)
SELECT * FROM cte
WHERE row_num > 1;

# CHECKING THAT DUPLICATE TRANSACTION ID'S HAVING ENTIRE RECORDS ARE DUPLICATE OR NOT 
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
    FROM sales_s
)
SELECT * FROM cte
WHERE transaction_id IN ('TXN855235','TXN342128','TXN240646','TXN981773');

# DELETING THE RECORD WHERE ROW_NUM IS 2 BECAUSE THERE ENITRE RECORDS ARE DUPLICATES.
WITH cte AS (
    SELECT row_id,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY purchase_date, time_of_purchase) AS row_num
    FROM sales_s
)
DELETE FROM sales_s
WHERE row_id IN (
    SELECT row_id
    FROM cte
    WHERE row_num = 2
);

/*=========================================================================================================================================================================
-- STEP 2: CORRECTION OF HEADERS NAME
==========================================================================================================================================================================*/
SELECT * FROM sales_s;

ALTER TABLE sales_s
RENAME COLUMN quantiy TO quantity;


ALTER TABLE sales_s
RENAME COLUMN prce TO price;

/*=========================================================================================================================================================================
-- STEP 3: CHECKING DATA TYPE
==========================================================================================================================================================================*/
DESC sales_s;

/*=========================================================================================================================================================================
-- STEP 4: TO CHECK NULL VALUES.
==========================================================================================================================================================================*/

-- CHECKING FOR MISSING STRINGS
SELECT COUNT(*) FROM sales_s;
desc sales_s;

SELECT COUNT(*)
FROM sales_s
WHERE customer_id = '';


SELECT
  SUM(transaction_id IS NULL OR transaction_id = '')     AS transaction_id_missing,
  SUM(customer_id IS NULL OR customer_id = '')           AS customer_id_missing,
  SUM(customer_name IS NULL OR customer_name = '')       AS customer_name_missing,
  SUM(customer_age IS NULL OR customer_age = '')                              AS customer_age_missing,
  SUM(gender IS NULL OR gender = '')                     AS gender_missing,
  SUM(product_id IS NULL OR product_id = '')             AS product_id_missing,
  SUM(product_name IS NULL OR product_name = '')         AS product_name_missing,
  SUM(product_category IS NULL OR product_category = '') AS product_category_missing,
  SUM(quantity IS NULL OR quantity= '')                  AS quantity_missing,
  SUM(price IS NULL OR price='')                         AS price_missing,
  SUM(payment_mode IS NULL OR payment_mode = '')         AS payment_mode_missing,
  SUM(purchase_date IS NULL)                             AS purchase_date_missing,
  SUM(time_of_purchase IS NULL OR time_of_purchase = '')                          AS time_of_purchase_missing,
  SUM(status IS NULL OR status = '')                     AS status_missing
FROM sales_s;


SELECT *
FROM sales_s
WHERE customer_id = '' OR customer_id IS NULL;

-- CONVERTING THE MISSING VALUES INTO NULLS
UPDATE sales_s
SET customer_id = NULL
WHERE customer_id = '';

-- CHECKING NULLS 
SELECT
    SUM(transaction_id IS NULL)   AS transaction_id_nulls,
    SUM(customer_id IS NULL)      AS customer_id_nulls,
    SUM(customer_name IS NULL)    AS customer_name_nulls,
    SUM(customer_age IS NULL)     AS customer_age_nulls,
    SUM(gender IS NULL)           AS gender_nulls,
    SUM(product_id IS NULL)       AS product_id_nulls,
    SUM(product_name IS NULL)     AS product_name_nulls,
    SUM(product_category IS NULL) AS product_category_nulls,
    SUM(quantity IS NULL)         AS quantity_nulls,
    SUM(price IS NULL)             AS prce_nulls,
    SUM(payment_mode IS NULL)     AS payment_mode_nulls,
    SUM(purchase_date IS NULL)    AS purchase_date_nulls,
    SUM(time_of_purchase IS NULL) AS time_of_purchase_nulls,
    SUM(status IS NULL)           AS status_nulls
FROM sales_s;


SELECT * FROM sales_s
WHERE transaction_id IS NULL
OR 
customer_id IS NULL
OR 
customer_name IS NULL
OR 
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR
product_name IS NULL
OR
product_category IS NULL
OR
quantity IS NULL
OR
price IS NULL
OR 
payment_mode IS NULL
OR
purchase_date IS NULL
OR
time_of_purchase IS NULL
OR
status IS NULL
;

-- TREATING NULLS 
DELETE FROM sales_s
WHERE transaction_id IS NULL;

SELECT * FROM sales_s
WHERE customer_name = 'Ehsaan Ram' ;   #'CUST9494'

UPDATE sales_s
SET customer_id = 'CUST9494'
WHERE transaction_id = 'TXN977900';

SELECT * FROM sales_s
WHERE customer_name = 'Damini Raju';     #'CUST1401'

UPDATE sales_s
SET customer_id = 'CUST1401'
WHERE transaction_id = 'TXN985663';

SELECT * FROM sales_s
WHERE transaction_id = 'TXN432798';

SELECT * FROM sales_s
WHERE customer_id = 'CUST1003';

UPDATE sales_s
SET customer_name='Mahika Saini',customer_age=35,gender='Male'
WHERE transaction_id='TXN432798';

/*============================================================================================================================================================
STEP 5: DATA CLEANING
===============================================================================================================================================================*/
#gender
UPDATE sales_s 
SET gender = 'Female'
WHERE customer_id = 'CUST1003';

UPDATE sales_s
SET gender = 'Female'
WHERE customer_id IN ('CUST4481', 'CUST9221');    # IN USED INSTEAD OF = BECAUSE IT ALLOWS MULTIPLE VALUES.


SELECT * FROM sales_s;

SELECT DISTINCT gender
FROM sales_s;

SELECT * FROM sales_s
WHERE gender= 'F';

UPDATE sales_s
SET gender = 'Female'
WHERE gender ='F';

SELECT * FROM sales_s
WHERE gender= 'M';

UPDATE sales_s
SET gender = 'Male'
WHERE gender ='M';

#payment_mode
SELECT DISTINCT payment_mode
FROM sales_s;                #CC IS credit card so we replace it

UPDATE sales_s
SET payment_mode='Credit Card'
WHERE payment_mode ='CC';

/*=======================================================================================================================================================================
-- DATA ANALYSIS --
=========================================================================================================================================================================*/
SELECT * FROM sales_s;

-- 1. WHAT IS THE TOP 5 MOST SELLING PRODUCTS BY QUANTITY?

SELECT DISTINCT status
FROM sales_s;

SELECT product_name, SUM(quantity) AS total_quantity_sold
FROM sales_s
WHERE status = 'delivered'
GROUP BY product_name 
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- BUISNESS PROBLEM: WE DON'T KNOW WHICH PRODUCT ARE MOST IN DEMAND.
-- BUISNESS IMPACT: HELPS PRIOTIZE STOCK AND BOOST SALES THOUGH TARGETED PROMOTIONS. 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. WHICH PRODUCTS ARE MOST FREQUENTLY CANCELED?
SELECT product_name, COUNT(*) AS total_cancelled_product 
FROM sales_s
WHERE status= 'cancelled'
GROUP BY product_name
ORDER BY total_cancelled_product DESC
LIMIT 5;

 -- BUISNESS PROBLEM: FREQUENTLY CANCELLATIONS AFFECT REVENUE AND CUSTOMER TRUST. 
 -- BUISNESS IMPACT: IDENTIFY POOR-PERFORMING PRODUCTS TO IMPROVE QUANTITY OR REMOVE FROM CATALOG. 
 
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 -- 3. WHAT TIME OF THE DAY HAS THE HIGHEST NUMBER OF PURCHASE?
 
 SELECT * FROM sales_s;
SELECT 
    CASE 
        WHEN HOUR(time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT' 
        WHEN HOUR(time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
        WHEN HOUR(time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        WHEN HOUR(time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
    END AS time_of_day,
    COUNT(*) AS total_orders
FROM sales_s
WHERE time_of_purchase IS NOT NULL
GROUP BY time_of_day
ORDER BY total_orders DESC;

-- BUISNESS PROBLEM SOLVED: FIND PEAK SALES LOADS.
-- BUISNESS IMPACT: OPTIMIZE STAFFING, PROMOTIONS, AND SERVER LOADS.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. WHO ARE THE TOP 5 HIGHEST SPENDING CUSTOMERS?
 SELECT * FROM sales_s;

SELECT customer_name, 
      CONCAT('₹ ',FORMAT(SUM(price * quantity),'0')) AS total_spend
FROM sales_s
GROUP BY customer_name
ORDER BY SUM(price * quantity) DESC
LIMIT 5;

-- BUISNESS PROBLEM SOLVED: IDENTIFY VIP CUSTOMERS.
-- BUISNESS IMPACT: PERSONALIZED OFFERS, LOYALTY REWARDS, AND RETENTION. 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT * FROM sales_s;

-- 5. WHICH PRODUCT CATEGORY GENERATES THE HIGHEST REVENUE?

SELECT product_category, 
      CONCAT('₹ ',FORMAT (SUM(price * quantity),'0')) AS highest_revenue
FROM sales_s
GROUP BY product_category
ORDER BY SUM(price * quantity) DESC
LIMIT 5;

-- BUISNESS PROBLEM SOLVED: IDENTIFY TOP-PERFORMING PRODUCT CATEGORIES.
-- BUISNESS IMPACT: REFINE PRODUCT STRATEGY,SUPPLY CHAIN, AND PROMOTION.
-- ALLOWING BUISNESS TO INVEST MORE IN HIGH-MARGIN OR HIGH-DEMAND CATEGORIES.  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6. WHAT IS THE RETURN/CANCELLATION RATE PER PRODUCT CATEGORY?
 SELECT * FROM sales_s;

-- CANCELLATION 
SELECT product_category,
    CONCAT(FORMAT(
            (SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
            3),' %'
    ) AS cancelled_percent
FROM sales_s
GROUP BY product_category
ORDER BY 
    (SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) DESC;

    

-- RETURN
SELECT product_category,
    CONCAT(FORMAT(
            (SUM(CASE WHEN status = 'returned' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
            3),' %'
    ) AS return_percent
FROM sales_s
GROUP BY product_category
ORDER BY 
    (SUM(CASE WHEN status = 'returned' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT * FROM sales_s;

-- 7. WHAT IS THE MOST PREFERRED PAYMENT MODE?
SELECT DISTINCT payment_mode, COUNT(*) AS total_count
FROM sales_s
GROUP BY payment_mode
ORDER BY COUNT(*) DESC;

-- BUISNESS PROBLEM SOLVED: KNOW WHICH PAYMENT OPTIONS CUSTOMERS PREFER.
-- BUISNESS IMPACT: STREAMLINE PAYMENT PROCESSING, PRIORITISE POPULAR MODES. 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT * FROM sales_s;
-- 8. HOW DOES AGE GROUP AFFECT PURCHASE BEHAVIOR?

SELECT MIN(customer_age) AS MINIMUM_AGE , MAX(customer_age) AS MAXIMUM_AGE    -- MIN 18 AND MAX 60
FROM sales_s;

SELECT 
      CASE 
          WHEN  customer_age BETWEEN 18 AND 25 THEN '18-25'
          WHEN  customer_age BETWEEN 26 AND 35 THEN '26-35'
          WHEN  customer_age BETWEEN 36 AND 50 THEN '36-50'
          ELSE '51+'
	 END AS customer_age_group,
     CONCAT('₹ ',FORMAT( SUM(price * quantity), 0)) AS total_purchase
FROM sales_s
GROUP BY 
     CASE 
          WHEN  customer_age BETWEEN 18 AND 25 THEN '18-25'
          WHEN  customer_age BETWEEN 26 AND 35 THEN '26-35'
          WHEN  customer_age BETWEEN 36 AND 50 THEN '36-50'
          ELSE '51+'
	 END 
 ORDER BY SUM(price * quantity) DESC;    
 
 -- BUISNESS PROBLEM SOLVED: UNDERSTAND CUSTOMER DEMOGRAPHICS.
 -- BUISNESS IMPACT: TARGESTED MARKETING AND PRODUCT RECOMMENDATIONS BY AGE GROUP. 
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  SELECT * FROM sales_s;

-- 9. WHAT'S THE MONTHLY SALES TREND?
# METHOD 1

SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') AS month_year,
    CONCAT('₹ ',FORMAT(SUM(price * quantity),0)) AS total_sales_in_rupees,
    SUM(quantity) AS total_quantity
FROM sales_s
GROUP BY DATE_FORMAT(purchase_date, '%Y-%m')
ORDER BY month_year;
  
# METHOD 2
SELECT 
    YEAR(purchase_date) AS years,
    MONTH(purchase_date) AS Months,
	CONCAT('₹ ',FORMAT(SUM(price * quantity),0)) AS total_sales_in_rupees,
    SUM(quantity) AS total_quantity
FROM sales_s
GROUP BY YEAR(purchase_date),
		 MONTH(purchase_date)
ORDER BY Months;

-- BUISNESS PROBLEM SOLVED: SALES FLUCTUATIONS GO UNNOTICED.
-- BUISNESS IMPACT: PLAN INVENTORY AND MARKETING TO SEASONAL TRENDS. 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM sales_s;
 
 SELECT DISTINCT customer_name, gender
 FROM sales_s;
 
 UPDATE  sales_s
 SET gender = 'Male'
 WHERE customer_name = 'Aniruddh Sinha';

-- 10. ARE CERTAIN GENDERS BUYING MORE SPECIFIC PRODUCT CATEGORIES?
 # METHOD 1
 SELECT gender,product_category, COUNT(product_category) AS total_purchase
 FROM sales_s
 GROUP BY gender,product_category
 ORDER BY COUNT(product_category) DESC;

# METHOD 2
SELECT 
    product_category,
    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS Male,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS Female
FROM sales_s
GROUP BY product_category
#ORDER BY product_category 
WITH ROLLUP;

-- BUISNESS PROBLEM SOLVED: GENDER-BASED PRODUCT PREFERENCES.
-- BUISNESS IMPACT: PERSONALIZED ADS, GENDER-FOCUSED CAMPAIGNS. 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


