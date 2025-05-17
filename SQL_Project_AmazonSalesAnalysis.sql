-- Aim of the project
/*
The major aim of this project is to gain insights into the sales data of Amazon to understand 
the different factors that affect sales of the different branches.
*/

-- Data
/*
Data contains sales transactions from three different branches of Amazon.
Branches:
-> Mandalay 
-> Yangon
-> Naypyitaw

Data contains 17 columns & 1000 rows
*/

-- Execution approach:
-- STEP 1: DATA BASE and TABLE creation 
/* 
I first right-cicked on an existing database (classicmodels), chose "Create Schema" option and 
gave the name "amazon" to the new database I intended to create. Then I selected the database amazon 
by double clicking on it and directly created a table "Transactions" with the columns/attributes 
along with their data types as per the project guidelines, and changed the data type for Payment_method column 
as it was decimal in guidelines but in the CSV file, the data was in alphabetical form. 
*/ 

CREATE TABLE Transactions(
Invoice_id VARCHAR(30),
Branch VARCHAR(30),
City VARCHAR(30),
Customer_type VARCHAR(30),
Gender VARCHAR(10),
Product_line VARCHAR(30),
Unit_price DECIMAL(10, 2),
Quantity INT,
VAT FLOAT(6, 4),
Total DECIMAL(10, 2), 
`Date` DATE,
`Time` TIME,
Payment_method VARCHAR(30),
Cogs DECIMAL(10, 2),
Gross_margin_percentage FLOAT(11, 9), 
Gross_income DECIMAL(10, 2),
Rating FLOAT(2, 1)
);

-- After the "Transactions" table has been created, I imported the data from the provided CSV file
-- using "Table Data Import Wizard" option which was available when I right-clicked on the database name under schemas section.

-- to see if all the data has been imported, I ran the below query. 
select * from Transactions;

-- to check if data types of columns is aligned as intended, I ran this query.
describe transactions;

-- As per the guidelines of project, for future engineering, I created a new column "TimeOfDay" using 
-- ALTER method as below

ALTER TABLE Transactions
ADD COLUMN TimeOfDay VARCHAR(15);


SET SQL_SAFE_UPDATES = 0;
-- To update the part of the day(morning, afternoon, evening), I ran the below query but 
-- it was not allowing as safe update mode was active. With the above query, I disabled it then ran the 
-- below code using CASE method.

UPDATE Transactions
SET TimeOfDay = CASE
					WHEN Hour(Time) BETWEEN 6 AND 11 THEN 'Morning'
                    WHEN Hour(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
                    Else 'Evening'
				END;

-- To check if the new column has been created, I ran this query again.
select * from Transactions;

-- Further, I created another column "Dayname", as per the project guidelines, to know the day name of transaction
-- using the beloq query
ALTER TABLE Transactions 
ADD COLUMN Dayname VARCHAR(15);

-- To add the name of day in newly created "Dayname" column, I ran the below query as this separates 
-- the name of the day from a date. 
UPDATE Transactions
SET Dayname = DAYNAME(date);

-- To check if the new column "Dayname" has been created, I ran this query again.
select * from Transactions;

-- Repeated the process, which I followed to create Dayname & TimeOfDay columns, to create another column
-- Monthname with the below query as it separates monthname from a date.
ALTER TABLE Transactions 
ADD COLUMN Monthname VARCHAR(15);

UPDATE Transactions
SET Monthname = MONTHNAME(date);


-- STEP 2: Business Questions
-- 1. What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT city) AS Distinct_cities FROM Transactions;
-- Result : 3

-- 2. For each branch, what is the corresponding city?
SELECT DISTINCT Branch, City FROM Transactions;
-- A : Yangon
-- B : Mandalay
-- c : Naypyitaw

-- 3. What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT Product_line) AS DistPrd_lines_count FROM Transactions;
-- Result: 6

SELECT DISTINCT Product_line AS DistPrd_lines FROM Transactions;

-- 4. Which payment method occurs most frequently?
SELECT Payment_method, COUNT(*) AS Count
FROM Transactions
GROUP BY Payment_method
ORDER BY count DESC
LIMIT 1;
-- Result : Cash

-- 5. Which product line has the highest sales?
SELECT Product_line, SUM(total) AS Total_sales
FROM Transactions
GROUP BY Product_line
ORDER BY Total_sales DESC
LIMIT 1;
-- Result : Food and beverages

-- 6. How much revenue is generated each month?
SELECT Monthname, SUM(total) AS Monthly_revenue
FROM Transactions
GROUP BY Monthname
ORDER BY Monthly_revenue DESC;
-- Result :-
-- January	: 116292.11
-- March 	: 108867.38
-- February	: 95727.58

-- 7. In which month did the cost of goods sold reach its peak?
SELECT Monthname, SUM(cogs) AS Total_cogs
FROM Transactions
GROUP BY Monthname
ORDER BY Total_cogs DESC
LIMIT 1;
-- Result:
-- January 	: 110754.16


-- 8. Which product line generated the highest revenue?
SELECT Product_line, SUM(total) AS Revenue
FROM Transactions
GROUP BY Product_line
ORDER BY Revenue DESC
LIMIT 1;
-- Result: Food and beverages

-- 9. In which city was the highest revenue recorded?
SELECT City, SUM(total) AS Revenue
FROM Transactions
GROUP BY City
ORDER BY Revenue DESC
LIMIT 1;

-- 10. Which product line incurred the highest Value Added Tax?
SELECT Product_line, SUM(vat) AS Total_vat
FROM Transactions
GROUP BY Product_line
ORDER BY Total_vat DESC
LIMIT 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, 
-- otherwise "Bad."
SELECT Product_line,
		CASE
			WHEN SUM(total) > (SELECT AVG(total) FROM Transactions) THEN 'Good'
            ELSE 'Bad'
            END AS Performance
FROM Transactions
GROUP BY Product_line;


-- 12. Identify the branch that exceeded the average number of products sold.
SELECT Branch, SUM(quantity) AS Total_quantity
FROM Transactions
GROUP BY Branch
HAVING Total_quantity > (SELECT AVG(Quantity) FROM Transactions);

-- 13. Which product line is most frequently associated with each gender?
SELECT Gender, Product_line, COUNT(*) AS Count
FROM Transactions
GROUP BY Gender, Product_line
HAVING COUNT(*) = (
    SELECT MAX(Product_count) FROM (
        SELECT Gender AS G, Product_line AS Pl, COUNT(*) AS product_count
        FROM Transactions
        GROUP BY Gender, Product_line
    ) AS Sub
    WHERE Sub.G = Transactions.Gender
);

-- 14. Calculate the average rating for each product line.
SELECT Product_line, ROUND(AVG(Rating), 2) AS Avg_rating
FROM Transactions
GROUP BY Product_line;

-- 15. Count the sales occurrences for each time of day on every weekday.
SELECT Dayname, TimeOfDay, COUNT(*) AS Sales_count
FROM Transactions
GROUP BY Dayname, TimeOfDay
ORDER BY Dayname, TimeOfDay;

-- 16. Identify the customer type contributing the highest revenue.
SELECT Customer_type, SUM(total) AS Revenue
FROM Transactions
GROUP BY Customer_type
ORDER BY Revenue DESC
LIMIT 1;

-- 17. Determine the city with the highest VAT percentage.
SELECT City, AVG(vat) AS Avg_vat
FROM Transactions
GROUP BY City
ORDER BY Avg_vat DESC
LIMIT 1;

-- 18. Identify the customer type with the highest VAT payments.
SELECT Customer_type, SUM(vat) AS Total_vat
FROM Transactions
GROUP BY Customer_type
ORDER BY Total_vat DESC
LIMIT 1;

-- 19. What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT Customer_type) AS Cust_type_count FROM Transactions;

-- 20. What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT Payment_method) AS Payment_method_count FROM Transactions;

-- 21. Which customer type occurs most frequently?
SELECT Customer_type, COUNT(*) AS Frequency
FROM Transactions
GROUP BY Customer_type
ORDER BY Frequency DESC
LIMIT 1;

-- 22. Identify the customer type with the highest purchase frequency.
SELECT Customer_type, COUNT(*) AS Purchase_count
FROM Transactions
GROUP BY Customer_type
ORDER BY Purchase_count DESC
LIMIT 1;

-- 23. Determine the predominant gender among customers.
SELECT Gender, COUNT(*) AS Count
FROM Transactions
GROUP BY Gender
ORDER BY Count DESC
LIMIT 1;

-- 24. Examine the distribution of genders within each branch.
SELECT Branch, Gender, COUNT(*) AS Count
FROM Transactions
GROUP BY Branch, Gender
ORDER BY Branch, Count DESC;

-- 25. Identify the time of day when customers provide the most ratings.
SELECT TimeOfDay, COUNT(*) AS Ratings_count
FROM Transactions
GROUP BY TimeOfDay
ORDER BY Ratings_count DESC
LIMIT 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.
SELECT * 
FROM 
	(
	SELECT Branch, TimeOfDay, AVG(Rating) AS Avg_rating,
	RANK() OVER(PARTITION BY BRANCH ORDER BY AVG(Rating) DESC) AS DaytimeRank
	FROM Transactions
	GROUP BY Branch, TimeOfDay) AS RankedTime
WHERE DaytimeRank = 1;


-- 27. Identify the day of the week with the highest average ratings.
SELECT Dayname, AVG(Rating) AS Avg_rating
FROM Transactions
GROUP BY Dayname
ORDER BY Avg_rating DESC
LIMIT 1;


-- 28. Determine the day of the week with the highest average ratings for each branch.
SELECT *
FROM 
	(SELECT Branch, Dayname, AVG(Rating) AS Avg_Rating, 
	RANK() OVER(PARTITION BY Branch ORDER BY AVG(Rating) DESC) AS RatingRanks
	FROM Transactions
	GROUP BY Branch, Dayname) AS Ranked
WHERE RatingRanks = 1;



-- Analysis
/*
1. Product Analysis
Key Findings

Total Product Lines: There are 6 distinct product lines.
('Health and beauty', 'Electronic accessories', 'Home and lifestyle', 'Sports and travel', 'Food and beverages', 'Fashion accessories')

Top Performing Product Line: is Food and Beverages with total sales of '56144.96'.

High VAT Product Line: Again "Food and Beverages" because the product line which incurs the most VAT matches 
the one with the highest sales, as VAT is proportional to total sales.

Performance Labeling: Product lines have been categorized as Good if their total sales exceed 
the average across all product lines; the rest are marked as Bad.

Gender Preference: Health and Beauty is more frequently purchased by males.

Ratings: Product lines also vary in customer satisfaction, with some having higher average ratings than 
others.

Summary & Insight
-> Top-selling product lines can be promoted further whevere they score high on customer ratings.
-> Low-performing or low-rated lines may need better marketing, product updates, or promotional bundles.
-> Gender-based preferences suggest an opportunity for targeted marketing campaigns.


2. Sales Analysis
Key Findings
Popular Payment Method: is Cash, showing customer convenience trends.

Monthly Revenue: Revenue trends show a peak in January month.

COGS Peak: Cost of Goods Sold is also highest in that same month, indicating a direct link to sales volume.

Revenue by City: 'Naypyitaw' contributed the highest revenue overall.

Branch Performance: 'Branch A' stands out with above-average product quantity sold.

Sales Timing: Sales are most active during Afternoon.

Customer Ratings Over Time: Customers give more ratings in the Afternoon.

Summary & Insight
-> Focus marketing and promotions during high-revenue months and times of day.
-> Staffing, logistics, and inventory should be optimized for these peak times.
-> Cities or branches with lower sales might need local promotions or strategic changes.
-> Consider deeper time-of-day analysis for feedback trends to boost service quality.


3. Customer Analysis
Key Findings
Customer Types: Two main types - Member & Normal with differing behaviors.

Revenue Contribution: Member customer type generates more revenue.

Purchase Frequency: This same group, member, also makes more purchases.

Gender Distribution: Male gender is more frequent across all sales.

Branch Demographics: Branches A & B have almost the same gender distribution but C has slightly higher for 
both the genders. 

City & VAT: City 'Naypyitaw' has higher average VAT, correlating with higher revenue.

Customer Ratings: Ratings are high during Afternoon and on Monday.

Summary & Insight
-> Gender-focused campaigns could be used in locations where a particular gender dominates.
-> Understanding when customers are happiest based on rating helps to do better service planning.
-> Can use VAT and revenue data to adjust pricing strategies by region if needed.
*/