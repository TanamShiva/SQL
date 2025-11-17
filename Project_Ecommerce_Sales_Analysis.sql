-- Project: E-Commerce Sales Analysis
-- Datasets: Sales, Products, Prices
-- Period: Apr 2022 — Jun 2022
-- Goal: 
-- 1. To be able to create database & table structures as per the csv file, which has been dowloaded from kaggle.
-- 2. and load data into MySQL workbench from CSV files.
-- 3. and generate questions using CHATGPT and solve them.


CREATE DATABASE Ecommerce_Sales;
USE Ecommerce_Sales;

CREATE TABLE Sales(
	OrderID VARCHAR(100) primary key,
	OrderDate date,
	Status VARCHAR(50),
	Fulfilment VARCHAR(50),
	SalesChannel VARCHAR(50),
	ShipServiceLevel VARCHAR(50),
	Style VARCHAR(50),
	SKU VARCHAR(50),
	Category VARCHAR(50),
	Size VARCHAR(25),
    ASIN VARCHAR(50),
	CourierStatus VARCHAR(50),
	Qty INT,
	Amount DECIMAL(10, 2),
	ShipCity VARCHAR(100),
	ShipState VARCHAR(50),
	ShipPostalCode VARCHAR(25),
	B2B VARCHAR(25),
    FulfilledBy VARCHAR(25)
);

SELECT * FROM sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET ShipState = "Arunachal Pradesh"
WHERE ShipState = "Ar";

UPDATE sales
SET ShipState = "Nagaland"
WHERE ShipCity = "Dimapur";

UPDATE sales
SET ShipState = "Odisha"
WHERE ShipState = "Orissa";

UPDATE sales
SET ShipState = "Punjab"
WHERE ShipState = "Punjabmohalizirakpur";

UPDATE sales
SET ShipState = "Puducherry"
WHERE ShipState = "Pondicherry";

UPDATE sales
SET ShipState = "Rajasthan"
WHERE ShipState IN ("Rajashthan", "Rajsthan", "Rj");

UPDATE sales
SET ShipState = "Andaman Nicobar"
WHERE ShipState = "Andaman  Nicobar";


SELECT DISTINCT ShipState FROM sales
ORDER BY ShipState;

SELECT count(OrderID) FROM sales;

/*
First, I've tried 'Table Data Import Wiward' option by doing righ-click while staying on the database name under 
schemas section but it was VERY slow and I observed two things while the data was being imported in this way.
1. Data had a few duplicate OrderIDs
2. Amount column had empty cells 
Due to these two reasons, the import wizard was showing some error messages. 
I cancelled that process, made necessary changes in the data and followed the below approach to complete data import quickly

*/

TRUNCATE TABLE sales;

SHOW VARIABLES LIKE 'secure_file_priv'; -- this query line shows where to save data files when '--secure-file-priv option' is enabled

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/1.Amazon Sale Report2.csv'
IGNORE
INTO TABLE Sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, OrderDate, Status, Fulfilment, SalesChannel, ShipServiceLevel, Style, SKU, Category, Size, ASIN, CourierStatus, Qty, Amount, ShipCity, ShipState, ShipPostalCode, B2B, FulfilledBy);

/*
I first ran the above query with a different file path and without IGNORE key at the second line but 
it gave me the below errors:
1. Duplicate entry 'xxxxxxxxxxxxxxxx' for key 'sales.PRIMARY'
2. 'Error: The MySQL server is running with the --secure-file-priv option'
So, I saved the data file in the above path and added IGNORE key at the second line of the query to skip duplicates and 
ensure smooth data import. Finally, the data is imported but with some less rows due to quality issues.
*/

SELECT * FROM sales;

SHOW WARNINGS; -- observed a yellow triangle mark under Action Output section, so tried thie query line and there was no warning



CREATE TABLE Products(
SKUCode VARCHAR(50), 
DesignNo VARCHAR(25), 
Stock INT, 
Category VARCHAR(25), 
Size VARCHAR(10), 
Color VARCHAR(25)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2.Products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM products;



CREATE TABLE Prices(
SKU VARCHAR(100), 
StyleId VARCHAR(100),
Catalog VARCHAR(50),
Category VARCHAR(50),
Weight DECIMAL(5,2),
TP DECIMAL(10,2),
MRPOld DECIMAL(10,2),
FinalMRPOld DECIMAL(10,2),
AjioMRP DECIMAL(10,2),
AmazonMRP DECIMAL(10,2),
AmazonFBAMRP DECIMAL(10,2),
FlipkartMRP DECIMAL(10,2),
LimeroadMRP DECIMAL(10,2),
MyntraMRP DECIMAL(10,2),
PaytmMRP DECIMAL(10,2),
SnapdealMRP DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/3.Prices.csv'
INTO TABLE prices
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM prices;

----------------------------------------------------------------------------------------------------------------------
-- Level 1: Basic (Data Familiarity & Aggregation)

-- Show the total number of orders, total revenue, and total quantity sold from the sales table.
SELECT
	COUNT(OrderID) AS TotalOrders,
    SUM(Qty * Amount) AS TotalRevenue,
    SUM(Qty) AS TotalQuantity
FROM sales;

-- List all unique sales channels available in the data.
SELECT
	distinct SalesChannel
FROM sales;

-- Find the top 5 ship states by total order count.
SELECT 
	ShipState,
    COUNT(OrderID) AS OrdersCount
FROM sales
GROUP BY ShipState
ORDER BY OrdersCount DESC
LIMIT 5;

DELETE FROM sales
WHERE orderdate = 0000-00-00; # There was 1 row with empty value. So, ran this code to delete that row.

-- Retrieve all records from sales where status = 'Cancelled'.
SELECT * FROM sales
WHERE Status = "Cancelled";

-- Show total sales amount for each month (in yyyy-mm format).
SELECT 
	DATE_FORMAT(OrderDate, '%Y-%m') AS YearMonth,
    SUM(Qty * Amount) AS TotalSales
FROM sales
GROUP BY YearMonth
ORDER BY YearMonth;

-- Find the distinct product categories from the products table.
SELECT
	DISTINCT Category
FROM products
ORDER BY Category;

-- What is the average selling amount per order?
SELECT 
	ROUND((SUM(Amount) / COUNT(DISTINCT OrderId)),2) AS AvgAmountPerOrder
FROM sales;

-- Display the total revenue for each fulfilment type.
SELECT 
	fulfilment,
    SUM(Qty * Amount) AS TotalRevenue
FROM sales
GROUP BY fulfilment;

-- Show the earliest and latest order dates.
SELECT
	MIN(OrderDate) AS EarliestOrdDate,
    MAX(OrderDate) AS LatestOrdDate
FROM sales;

-- Find the number of unique SKUs sold.
SELECT COUNT(distinct SKU) AS Unique_SKU_Count FROM Sales;

----------------------------------------------------------------------------------------------------------------------
-- Level 2: Intermediate (Joins, Filtering, Grouping)
-- Join sales and products to find total quantity sold per category.
SELECT
	p.Category,
    SUM(s.Qty) AS TotalQuantity
FROM sales s
JOIN products p ON s.SKU = p.SKUCode
GROUP BY Category
ORDER BY Category;

-- Get the top 10 SKUs with the highest total sales amount.
SELECT
	SKU,
    SUM(Amount) AS TotalSalesAmount
FROM sales
GROUP BY SKU
ORDER BY TotalSalesAmount DESC
LIMIT 10;

-- Find which category has the highest average order value (AOV).
SELECT
	p.Category,
    ROUND((SUM(s.Amount) / COUNT(DISTINCT s.OrderId)), 2) AS AvgOrderValue
FROM products p 
JOIN sales s ON p.SKUCode = s.SKU
GROUP BY Category 
ORDER BY AvgOrderValue DESC
LIMIT 1;

-- Compare sales across channels — show channel, total revenue, and total orders.
SELECT
	SalesChannel,
	SUM(Amount) AS TotalRevenue,
	COUNT(DISTINCT OrderID) AS TotalOrders
FROM sales
GROUP BY SalesChannel
ORDER BY TotalRevenue;

-- Join sales and prices to show the difference between AmazonMRP and average selling amount for each SKU.
# SKUs are not matching between both sales & prices tables, hence the below query is not showing any result but the query logic is correct
SELECT
	AvgAmountTable.SKU, AvgAmountTable.AvgSellingAmount, AmazonMRP
FROM 
	(
	SELECT
		SKU,
		ROUND(AVG(AMOUNT), 2) AS AvgSellingAmount
	FROM sales 
	GROUP BY SKU
    ) AS AvgAmountTable 
JOIN prices ON AvgAmountTable.SKU = prices.SKU;

-- Which states have generated above-average total revenue?

SELECT
	ShipState,
    SUM(Amount) AS T_Revenue
FROM sales
GROUP BY ShipState
HAVING SUM(Amount) > 
				(
                SELECT AVG(TotalRevenue) 
                FROM
					(SELECT 
						SUM(Amount) AS TotalRevenue 
					FROM sales
					GROUP BY ShipState) AS TR
				)
ORDER BY T_Revenue DESC;

-- Find all orders shipped to Maharashtra with amount greater than ₹1000.
SELECT
	*
FROM sales
WHERE ShipState = "Maharashtra" AND Status = "Shipped" AND Amount > 1000; 

-- Show month-over-month growth in revenue (current month vs previous month).
SELECT 
	Current.Month AS Month,
    Current.MonthlyRevenue,
    Previous.MonthlyRevenue,
    ROUND((Current.MonthlyRevenue - Previous.MonthlyRevenue)/Previous.MonthlyRevenue * 100, 2) AS MoM_Growth
FROM
	(
	SELECT 
		DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
		SUM(Amount) AS MonthlyRevenue
	FROM sales
	GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
	) AS Current
LEFT JOIN
	(
	SELECT 
		DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
		SUM(Amount) AS MonthlyRevenue
	FROM sales
	GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
	) AS Previous
ON Previous.Month = DATE_FORMAT(DATE_SUB(CONCAT(Current.Month, '-01'), INTERVAL 1 MONTH), '%Y-%m');


-- Find total orders and total revenue per category per month.
SELECT
	p.Category,
    date_format(s.OrderDate, '%Y-%m') AS Month,
    COUNT(s.OrderID) AS TotalOrders,
    SUM(s.Amount) AS TotalRevenue
FROM products p
JOIN sales s ON p.SKUCode = s.SKU
GROUP BY p.Category, date_format(s.OrderDate, '%Y-%m')
ORDER BY Category, TotalRevenue DESC;

----------------------------------------------------------------------------------------------------------------------
-- Level 3: Advanced (CTEs, Window Functions, Insights)
-- Using a CTE, calculate each month’s total revenue and the difference vs previous month.
WITH MonthRevenue AS
(
SELECT 
	DATE_FORMAT(OrderDate, '%Y-%m') as Month,
    SUM(amount) as T_Revenue
FROM sales
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
)
SELECT 
	Cur.Month AS CurrentMonth,
    Cur.T_Revenue AS CurrentMonthRevenue,
    DATE_FORMAT(DATE_SUB(CONCAT(Cur.Month, '-01'), interval 1 month), '%Y-%m') AS PreviouMonth,
    Pre.T_Revenue AS PreviousMonthRevenue,
    (Cur.T_Revenue - Pre.T_Revenue) AS MonthlyDiff
FROM MonthRevenue Cur
LEFT JOIN MonthRevenue Pre
ON Pre.Month = DATE_FORMAT(DATE_SUB(CONCAT(Cur.Month, '-01'), interval 1 month), '%Y-%m');


-- Use a window function to rank SKUs by total sales amount within each category.
SELECT
	Category,
    SKU,
    SUM(Amount) AS TotalSales,
	RANK() OVER(partition by Category order by SUM(Amount) DESC) AS SKU_Rank
FROM sales
GROUP BY Category, SKU;


-- Find top 3 selling products per state (using DENSE_RANK() or ROW_NUMBER()).
WITH SKUSale AS
(
SELECT
	SKU,
    SUM(Amount) AS SaleAmount,
    ShipState
FROM sales
GROUP BY SKU, ShipState
),
SKUSaleRank AS
(
SELECT 
	*,
	row_number() OVER(partition by ShipState order by SaleAmount DESC) AS SKURank
FROM SKUSale
)
SELECT * FROM SKUSaleRank
WHERE SKURank <= 3;

-------- OR -------

SELECT * FROM
(
SELECT 
	SKU,
    ShipState,
    SaleAmount,
    row_number() OVER(partition by ShipState order by SaleAmount DESC) AS SKURank
FROM
(
SELECT
	SKU,
    SUM(Amount) AS SaleAmount,
    ShipState
FROM sales
GROUP BY SKU, ShipState) AS SKUSale
) 
AS SKUSaleRank
WHERE SKURank <=3;


-- Calculate average quantity per order for each category, and rank categories by this metric.
WITH AvgQuantity AS
(
SELECT
	Category,
    COUNT(OrderID) AS OrdersCount,
	SUM(Qty) AS AvgQty,
    ROUND(SUM(Qty) / COUNT(OrderID), 2) AS AvgQtyPerOrder
FROM sales
GROUP BY Category
)
SELECT 
	Category,
    AvgQtyPerOrder,
    RANK() OVER(order by AvgQtyPerOrder DESC) AS CatRank
FROM AvgQuantity;


-- Identify the SKU with the most consistent monthly revenue (smallest std deviation).
WITH SKUMonthlyRev AS
(
SELECT
	SKU,
    DATE_FORMAT(OrderDate, '%Y-%m') AS YrM,
    SUM(Amount) AS MRevenue
FROM sales
GROUP BY SKU, DATE_FORMAT(OrderDate, '%Y-%m')
)
SELECT
	SKU, 
    stddev(MRevenue) AS StDevitation
FROM SKUMonthlyRev
GROUP BY SKU
ORDER BY StDevitation ASC
LIMIT 1;


-- Use a CTE to calculate cumulative sales by month.
WITH MonthlyRevenue AS
(
SELECT
    DATE_FORMAT(OrderDate, '%Y-%m') AS YrM,
    SUM(Amount) AS MRevenue
FROM sales
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
),
CumulativeRevenue AS
(
SELECT
	M1.YrM,
    M1.MRevenue,
    SUM(M2.MRevenue) AS CumRevenue
FROM MonthlyRevenue M1
JOIN MonthlyRevenue M2 ON M2.YrM <= M1.YrM
GROUP BY M1.YrM
)
SELECT * FROM CumulativeRevenue
ORDER BY YrM;

-- OR ------

WITH MonthlyRevenue AS
(
SELECT
    DATE_FORMAT(OrderDate, '%Y-%m') AS YrM,
    SUM(Amount) AS MRevenue
FROM sales
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
)
SELECT 
	*,
    SUM(MRevenue) OVER(order by YrM ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumRevenue
FROM MonthlyRevenue;


-- Find total revenue contribution % by each sales channel (e.g., Amazon = 40%, Flipkart = 30%, etc.).
WITH ChannelRevenue AS
(
SELECT 
	SalesChannel, 
    SUM(Amount) AS ChannelAmount 
FROM sales
GROUP BY SalesChannel
),
TotalRevenue AS
(
SELECT SUM(Amount) AS TotalAMOUNT FROM sales
)
SELECT 
	SalesChannel,
    ChannelAmount,
    ROUND(ChannelAmount / TotalAMOUNT * 100) AS PercentContribution
FROM ChannelRevenue
CROSS JOIN TotalRevenue;


-- Determine which category has the highest revenue variance month-to-month.
WITH MRevenue AS
(
SELECT 
	Category,
    DATE_FORMAT(OrderDate, '%Y-%m') AS YrM,
    SUM(Amount) AS Revenue
FROM sales
GROUP BY Category, DATE_FORMAT(OrderDate, '%Y-%m')
),
MoM AS
(
SELECT 
	m1.Category,
    m1.YrM,
    m1.Revenue AS CMRev,
    DATE_FORMAT(DATE_SUB(CONCAT(m1.YrM, "-01"), INTERVAL 1 MONTH), "%Y-%m") AS PreMonth,
    m2.Revenue AS PMRev,
    ROUND((m1.Revenue - m2.Revenue / m2.Revenue) * 100, 2) AS MoMChange
FROM MRevenue m1
LEFT JOIN MRevenue m2
ON m1.category = m2.category AND
m2.YrM = DATE_FORMAT(DATE_SUB(CONCAT(m1.YrM, "-01"), INTERVAL 1 MONTH), "%Y-%m")
),
MoMVariance AS
(
SELECT
	Category,
    ROUND(VAR_SAMP(MoMChange), 2) AS MoMVar
FROM MoM
WHERE PMRev IS NOT NULL
GROUP BY Category
)
SELECT * FROM MoMVariance
ORDER BY MoMVar DESC
LIMIT 1;

-------- using LAG() --------------

WITH MRevenue AS
(
SELECT 
	Category,
    DATE_FORMAT(OrderDate, '%Y-%m') AS YrM,
    SUM(Amount) AS Revenue
FROM sales
GROUP BY Category, DATE_FORMAT(OrderDate, '%Y-%m')
),
MoM AS
(
SELECT 
	Category,
    YrM,
    Revenue,
    LAG(Revenue) OVER(PARTITION BY Category ORDER BY YrM) AS PrRevenue,
    (Revenue - LAG(Revenue) OVER(PARTITION BY Category ORDER BY YrM) / 
	LAG(Revenue) OVER(PARTITION BY Category ORDER BY YrM)) * 100 AS MoMChange
FROM MRevenue
),
MoMVariance AS
(
SELECT
	Category,
    ROUND(VAR_SAMP(MoMChange), 2) AS MoMVar
FROM MoM
WHERE PrRevenue IS NOT NULL
GROUP BY Category
)
SELECT * FROM MoMVariance
ORDER BY MoMVar DESC
LIMIT 1;


-- Show top 5 cities contributing the most to total revenue, and their percentage of total.
WITH City_Rev AS(
	SELECT
		ShipCity,
		SUM(Amount) AS Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(Amount) DESC) AS RNUM
	FROM sales
	GROUP BY ShipCity),
TotalRev AS
	(SELECT SUM(Amount) AS Trevenue FROM sales)
SELECT 
	ShipCity,
    Revenue,
    ROUND((Revenue / Trevenue * 100), 2) AS PrcntContr
FROM City_Rev
CROSS JOIN TotalRev
WHERE RNUM <= 5;


-- Create views like v_monthly_sales, v_top_products, etc.
-- Monthly Sales View
CREATE VIEW V_Monthly_Sales AS
SELECT 
	DATE_FORMAT(OrderDate, '%Y-%m') AS YrMoth,
    SUM(Amount) AS Sale
FROM sales
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m');

SELECT * FROM V_Monthly_Sales;

-- Top Products View
CREATE VIEW V_Top_Products AS
SELECT
	p.Category,
    SUM(s.Amount) AS Sale
FROM products p
JOIN sales s ON p.SKUCode = s.sku
GROUP BY Category
ORDER BY Sale DESC;

SELECT * FROM V_Top_Products
LIMIT 5;


-- Write stored procedures for dynamic reports (e.g., "Sales by Channel for Given Month").
DELIMITER //

CREATE PROCEDURE ChannelMonthlySales
(
	IN MonthNum VARCHAR(10)
)
BEGIN
	SELECT 
		DATE_FORMAT(OrderDate, '%Y-%m') AS MonthN,
		SUM(Amount) AS SalesAmount		
	FROM sales
	WHERE DATE_FORMAT(OrderDate, '%Y-%m') = MonthNum
    GROUP BY MonthN;

END //

DELIMITER ;
CALL ChannelMonthlySales('2022-06');


-- Create a procedure that takes month as input and returns orders qunatity.
-- input should be in 'YYYY-MM' format

DELIMITER //

CREATE PROCEDURE MonthlyOrdersCount(
			IN MonthNum VARCHAR(12),
			OUT OrdQuantity INT
            )
BEGIN
	SELECT 
		DATE_FORMAT(OrderDate, '%Y-%m') AS YrMnth,
        COUNT(Qty) AS Quantity
	INTO MonthNum, OrdQuantity
	FROM sales
    WHERE DATE_FORMAT(OrderDate, '%Y-%m') = MonthNum
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m');
END //

DELIMITER ;
CALL MonthlyOrdersCount('2022-06', @OrdQuantity);
SELECT @OrdQuantity AS Quantity;
