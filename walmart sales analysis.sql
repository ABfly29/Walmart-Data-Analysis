CREATE DATABASE IF NOT EXISTS salesdatawalmart;

CREATE TABLE sales
(
Invoice_ID	VARCHAR(30) NOT NULL PRIMARY KEY,
Branch	VARCHAR(10) NOT NULL,
City	VARCHAR(100) NOT NULL,
Customer_type	VARCHAR(100) NOT NULL,
Gender	VARCHAR(20) NOT NULL,
Product_line	VARCHAR(100) NOT NULL,
Unit_price	DECIMAL(10,2) NOT NULL,
Quantity	INT NOT NULL,
VAT	     DECIMAL(10,2) NOT NULL,
Total	DECIMAL(12,4) NOT NULL,
Date	DATE NOT NULL,
Time	TIME NOT NULL,
payment_method	VARCHAR(50),
cogs	DECIMAL(10,2),
gross_margin_percentage DECIMAL(10,2), 	
gross_income	DECIMAL(10,2),
Rating   DECIMAL(10,2)

);

SELECT * FROM sales;

--FEATURE ENGINEERING

SELECT 
    time,
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = 
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
    END;

SELECT * FROM sales

SELECT date, TO_CHAR(date, 'Day') AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day VARCHAR(20);

UPDATE sales
SET day = TO_CHAR(date, 'Day');

SELECT * FROM sales

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = TO_CHAR(date, 'Month');


SELECT date, month_name FROM sales;


--Business Questions to answer

--How many unique cities does the data have

SELECT 
DISTINCT  city
FROM sales

--In which city is each branch?
SELECT 
DISTINCT branch
FROM sales

SELECT 
DISTINCT city,branch
from sales

--How many unique product lines does the data have?

SELECT 
DISTINCT product_line
FROM sales

--What is the most common payment method?

SELECT payment_method,
COUNT(payment_method) as count
FROM sales
GROUP BY payment_method
ORDER BY count DESC

--What is the most selling product line?

SELECT product_line,
COUNT(product_line) as count_product
FROM sales
GROUP BY product_line
ORDER BY count_product DESC 

--What is the total revenue by month?
SELECT 
month_name as month,
SUM(TOTAL) AS total_revenue 
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC

--What month had the largest COGS?

SELECT 
month_name as month,
SUM(cogs) as cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC

--What product line had the largest revenue?
SELECT
product_line as productsline,
SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC

--What is the city with the largest revenue?

SELECT 
city, 
SUM(total) as total_revenues
FROM sales
GROUP BY city
ORDER BY total_revenues DESC

--What product line had the largest VAT?

SELECT
product_line,
AVG(VAT) as avg_tax
from sales
GROUP BY product_line
ORDER BY avg_tax DESC

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT product_line, total,
       CASE 
           WHEN total > (SELECT AVG(total) FROM sales) THEN 'Good'
           ELSE 'Bad'
       END AS performance
FROM sales;

--Which branch sold more products than average product sold?

SELECT
branch,
SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)


--What is the most common product line by gender?

SELECT
    gender,
    product_line,
    COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;


--What is the average rating of each product line?
SELECT
AVG(rating) AS avg_rating,
product_line
from sales
GROUP BY product_line
ORDER BY avg_rating DESC

--SALES ANALYSIS

--Number of sales made in each time of the day per weekday

SELECT
time_of_day,
COUNT(*) as total_sales
FROM sales
WHERE day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
GROUP BY time_of_day
ORDER BY total_sales DESC


--Which of the customer types brings the most revenue?

SELECT
customer_type,
SUM(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC


--Which city has the largest tax percent/ VAT (Value Added Tax)?


SELECT 
city,
AVG(vat) as avg_tax
FROM sales
GROUP BY city
ORDER BY avg_tax DESC


--Which customer type pays the most in VAT?
SELECT 
customer_type,
AVG(vat) as avg_tax
FROM sales
GROUP BY customer_type
ORDER BY avg_tax DESC


--CUSTOMER INFO

--How many unique customer types does the data have?

SELECT
DISTINCT customer_type
from sales

--How many unique payment methods does the data have?

SELECT
DISTINCT payment_method
from sales


--What is the most common customer type?
SELECT
customer_type,
COUNT(customer_type) as customer_cust
from sales
GROUP BY customer_type

--What is the gender of most of the customers?

SELECT
gender,
COUNT(gender)
from sales
GROUP BY gender

--What is the gender distribution per branch?

SELECT 
    branch,
    gender,
    COUNT(*) AS gender_cnt
FROM sales
WHERE branch IN ('A', 'B', 'C')
GROUP BY branch, gender
ORDER BY branch, gender_cnt DESC;

--Which time of the day do customers give most ratings?


SELECT 
time_of_day,
AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating


SELECT * FROM sales


