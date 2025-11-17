-- VIEWS
-- * Views are stored in the storage, not the data but only the query structure is stored and do not occupy storage.*

-- * Views are two types: 1.UPDATABLE, 2.NON-UPDATABLE

-- * Any modification / change made in a view will also make the same change in the main table.*

-- * We can perform all operations on views which we perform on main tables.*

-- * A view that has any of the following is NON-UPDATABLE view.*
-- 1.Aggregate functions, 
-- 2.Distinct, 
-- 3.Group by, 
-- 4.Having, 
-- 5.Union & Union all, 
-- 6.Left join / Right join, 
-- 7.Subquery,
-- 8.References non-updatable view in from clause

-- How to check whether a view is updatable or non-updatable.
-- We can use
select table_name, -- this should be same word "table_name", should not replace with any table's actual name
	is_updatable
from information_schema.views
where table_schema = 'mavenmovies';


-- Datasets used: MavenMovies & ClassicModels
-- Basic Level
-- Q1. Create a view named customer_orders_view that shows each customer’s name, city, and total number of orders they’ve placed.
CREATE VIEW VW_Customer_Orders AS
select 
	customername, 
    city, 
    count(*) as totalorders 
from customers
join orders using(customernumber)
group by customerNumber, customername, city;

-- Q2. Create a view named high_value_products that lists all products with an MSRP greater than 100.
-- Columns to include: productCode, productName, productLine, MSRP.
CREATE VIEW VW_High_Value_Products AS
	select 
		productCode, 
		productName, 
		productLine, 
		MSRP
	from products
	where MSRP > 100;

-- Q3. Create a view named employee_info that shows employee full name, job title, and office city.
-- (Join employees and offices.)
CREATE VIEW VW_employee_info AS
	select
		CONCAT(firstName,' ',lastName) as fullname,
		jobtitle,
		city as officelocation
	from employees
	join offices using(officecode);


-- Intermediate Level
-- Q4. Create a view named order_summary_view that includes:
-- orderNumber
-- orderDate
-- status
-- customerName
-- totalAmount (sum of quantityOrdered * priceEach)
-- Use orders, orderdetails, and customers.

-- Q5. Create a view named top_customers that lists customers whose total order value exceeds $50,000.
-- Include columns: customerName, country, and totalOrderValue.


-- Advanced Level
-- Q6. Create a view monthly_sales_by_productline showing, for each product line and month, the total sales amount.
-- Columns: productLine, year, month, totalSales.

-- Q7. Create a view late_shipments that lists all orders that were shipped after their required date, including customer name and order status.


--------------------------------------------------------------------------------------------------------------------
-- STORED PROCEDURES
-- They are a set of declarative statements, permanently stored in MySQL.alter
-- They have parameters i,e. (IN / OUTPUT)

-- SYNTAX
/*

DELIMITER //

CREATE PROCEDURE procedure_name(parameters)
BEGIN
    -- SQL statements go here
    -- You can have multiple statements, each ending with a semicolon ;
END //

DELIMITER ;

*/

-- EXAMPLE

DELIMITER //

CREATE PROCEDURE GetTopRentalsByCategory(IN category_name VARCHAR(50))
BEGIN
    SELECT f.title, c.name, COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE c.name = category_name
    GROUP BY f.title, c.name
    ORDER BY rental_count DESC
    LIMIT 3;
END //

DELIMITER ;

CALL GetTopRentalsByCategory('Drama'); -- this is to call the procedure when only input parameter exists 

-- when both input & output parameters exist, we have to use the below syntax to call the procedure
CALL procedure_name (input, @ouput_parameter_name); -- we provide input but since we do not know output, whatever name is used for output parameter while createing procedure the same name is used here again while calling procedure
SELECT @ouput_parameter_name;

-- to alter an existing stored procedure, we cannot do using any query. We have to go to that procedure 
-- under schemas sections, right-click, use the alter option


-- Stored Procedures Practice
-- Basic Level
-- Q8. Write a stored procedure GetCustomerOrders that takes a customerNumber as input and returns all orders for that customer.
DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN custNo INT)
BEGIN
select
	c.customerNumber,
    c.customerName,
    o.orderNumber,
    o.orderDate,
    o.requiredDate,
    o.shippedDate,
    o.Status,
    o.comments
from customers c
join orders o using(customerNumber)
where c.customerNumber = custNo;

END //

DELIMITER ;
    
CALL GetCustomerOrders(119);


-- Q9. Write a stored procedure GetProductStock that takes a productCode and returns the current quantity in stock and product details.
DELIMITER //

CREATE PROCEDURE GetProductStock(IN pCode varchar(50))
BEGIN
select * from products
where productcode = pCode;

END //

DELIMITER ;
CALL GetProductStock('S10_4757');


-- Intermediate Level
-- Q10. Write a stored procedure GetEmployeeSales that takes an employeeNumber and returns:
-- Employee name
-- Total number of customers managed
-- Total sales value of their customers’ orders
DELIMITER //

create procedure GetEmployeeSales(IN EMPNum INT)
BEGIN
select
	e.employeeNumber,
    concat(e.firstname,' ',e.lastname) as employeeName,
    count(c.customerNumber) as customersCount,
	sum(od.quantityOrdered * od.priceEach) as totalSales
from employees e
join customers c on e.employeeNumber = c.salesRepEmployeeNumber
join orders o using(customerNumber)
join orderdetails od on o.orderNumber = od.orderNumber
where e.employeeNumber = EMPNum
group by e.employeeNumber, e.firstName, e.lastName
order by totalSales desc;

END //

DELIMITER ;

CALL GetEmployeeSales(1611);


-- Q11. Write a stored procedure GetOrdersByStatus that takes an order status (e.g., “Shipped”) and 
-- returns all matching orders, sorted by order date.

DELIMITER //

CREATE PROCEDURE GetOrdersByStatus(IN oStatus VARCHAR(50))
BEGIN
select * from orders
where status = oStatus
order by orderDate;

END //

DELIMITER ;
CALL GetOrdersByStatus('Shipped');


-- Advanced Level
-- Q12. Create a stored procedure AddNewPayment that inserts a new payment record given:
-- customerNumber
-- checkNumber
-- paymentDate
-- amount
-- It should:
-- Check if the customer exists
-- If not, raise an error message (using SIGNAL SQLSTATE '45000')

DELIMITER //

CREATE PROCEDURE AddNewPayment(
	IN CustNo INT, 
    IN chkNo VARCHAR(50), 
    IN payDate DATE, 
    IN money decimal(10,2)
    )
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM payments WHERE customerNumber = CustNo
        ) 
        THEN 
		SIGNAL SQLSTATE '45000'
        SET message_text = 'This customerNumber does not exist';
	ELSE
		INSERT INTO Payments(customerNumber, checkNumber, paymentDate, amount)
		VALUES(CustNo, chkNo, payDate, money);
	END IF;
END //

DELIMITER ;

CALL AddNewPayment(103, 'TAN2052', '2004-12-24', 51568);

select * from payments;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM payments
where checkNumber = 'TAN2052';


-- example tried
/*
CREATE TABLE Tanam(Name VARCHAR(100), Age INT);

DELIMITER //

CREATE PROCEDURE AddNames(IN fname VARCHAR(100), IN fAge INT)
BEGIN
INSERT INTO Tanam(Name, Age)
VALUES(fname, fAge);

END //

DELIMITER ;

CALL AddNames('Samaira', 5);
CALL AddNames('Aarush', 9);

select * from tanam;
drop table tanam;
*/

-- Q13. Create a stored procedure GetTopProductsBySales that takes a number N and returns the top N best-selling products by total revenue.
-- Example:
-- CALL GetTopProductsBySales(5);

DELIMITER // 

CREATE PROCEDURE GetTopProductsBySales(IN nProducts INT)
BEGIN
	SELECT 
		p.productName,
		SUM(od.quantityOrdered * od.priceEach) AS totalRevenue,
		ROW_NUMBER() OVER(ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC) AS salePosition
	FROM Products p
	JOIN orderdetails od on p.productCode = od.productCode
	GROUP BY p.productName
    LIMIT nProducts;

END//

DELIMITER ;

CALL GetTopProductsBySales(4);


-- Q14. Create a stored procedure GetMonthlyRevenue that takes a year (e.g., 2004) and returns the total sales per month for that year.
DELIMITER //

CREATE PROCEDURE GetMonthlyRevenue(IN inYear INT)
BEGIN
select 
	month(o.orderDate) AS Month_No,
    monthname(o.orderDate) AS Month_Name,
	SUM(od.quantityOrdered * od.priceEach) AS Monthly_Sale,
    year(o.orderDate) AS Year
from orders o
join orderdetails od using(orderNumber)
where year(o.orderDate) = inYear
group by Month_No, Month_Name, Year
order by year
;

END //

DELIMITER ;

CALL GetMonthlyRevenue(2003);


-- Bonus Challenge
-- Q15. Combine both concepts:
-- Create a view named sales_summary_view that shows productLine, year, totalSales,
-- and then write a stored procedure GetSalesByProductLine(productLineName) that queries that view and returns sales info 
-- for the given product line.
CREATE VIEW sales_summary_view AS
SELECT 
	p.productLine,
    year(o.orderDate) AS OrdYear,
    SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM products p
JOIN orderdetails od using(productCode)
JOIN orders o using(orderNumber)
GROUP BY p.productLine, OrdYear;


DELIMITER //

CREATE PROCEDURE GetSalesByProductLine(IN pLineName VARCHAR(100))
BEGIN 
	SELECT * FROM sales_summary_view ssv
	WHERE ssv.productLine = pLineName;

END //

DELIMITER ;

CALL GetSalesByProductLine('Vintage Cars');


-- Both: input & output
-- 1. Get Customer Details by Customer Number
-- Create a stored procedure that takes a customer number as input and returns the customer name, city, and country as output parameters.

DELIMITER //

CREATE PROCEDURE CustDetails(
	IN custNum INT, 
    OUT custName VARCHAR(100), 
    OUT cty VARCHAR(100), 
    OUT contry VARCHAR(100)
    )
BEGIN
	SELECT customerName, city, country
	INTO custName, cty, contry
	FROM customers
    WHERE customerNumber = custNum;
    
END //

DELIMITER ;

CALL custDetails(112, @custName, @cty, @contry);

SELECT @custName AS Name, @cty AS Location, @contry AS Country;


-- 2. Total Orders Amount for a Customer
-- Create a stored procedure that accepts a customer number and returns the total order revenue for that customer.

DELIMITER //

CREATE PROCEDURE CustomerTotalRevenue(
	IN custNum INT, 
    OUT custName VARCHAR(100), 
    OUT TotalCustRevenue DECIMAL(10,2)
    )
BEGIN
    SELECT 
		c.customerName, 
        SUM(quantityOrdered * priceEach) AS TotalRevenue
    INTO custName, TotalCustRevenue
    FROM customers c
    JOIN orders o USING(customerNumber)
	JOIN orderdetails od USING(orderNumber)
    WHERE customerNumber = custNum
    GROUP BY c.customerName;
    
END //

DELIMITER ; 

CALL CustomerTotalRevenue(129, @custName, @TotalCustRevenue);

SELECT @custName AS Cust_Name, @TotalCustRevenue AS T_Revenue;


-- 3. Count Products in a Product Line
-- Create a procedure that takes a product line name as input and outputs the number of products in that line.

DELIMITER //

CREATE PROCEDURE ProductsCountLineWise(
	IN proLineName VARCHAR(100), 
    OUT proLine VARCHAR(100), 
    OUT proCount VARCHAR(100)
)
BEGIN
	SELECT ProductLine, count(productCode) AS ProductsCount 
    INTO proLine, proCount
	FROM products
    WHERE ProductLine = proLineName
	GROUP BY ProductLine;
END//

DELIMITER ;

CALL ProductsCountLineWise('Vintage Cars' ,@proLine, @proCount);

SELECT @proLine AS LineName, @proCount AS Count;


-- 4. Customer Payment Summary
-- Create a procedure that accepts a customer number as input and outputs:
-- Total number of payments
-- Total payment amount
DELIMITER //
CREATE PROCEDURE CustomerPaymentSummary
			(IN custNum INT, 
            OUT paymentsCount INT, 
            OUT Total DECIMAL(10, 2))
BEGIN
	SELECT count(checkNumber) AS NumPayments, SUM(amount) AS TotalPayment 
    INTO paymentsCount, Total
	FROM payments
    WHERE customerNumber = custNum
	GROUP by customerNumber;
END//

DELIMITER ;

CALL CustomerPaymentSummary(103, @paymentsCount, @Total);
SELECT @paymentsCount, @Total;


-- 5. Check Customer Credit Limit
-- Create a procedure that takes customer number and an order amount as inputs and returns an output parameter indicating:
-- 1 if the order is within credit limit
-- 0 if the order exceeds credit limit
-- Input: IN CustNo INT, IN OrderAmt DECIMAL(10,2)
-- Output: OUT CanPlaceOrder TINYINT

DELIMITER //

CREATE PROCEDURE CustCreditLimit(IN CustNo INT, IN OrdAmt DECIMAL(10, 2), OUT CanPlaceOrder TINYINT)
BEGIN
    IF NOT EXISTS(SELECT 1 FROM customers WHERE customerNumber = CustNo) THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = "Customer Does not Exist";
		
    ELSE
		SELECT 
			CASE
				WHEN OrdAmt > creditLimit THEN 0
				ELSE 1
			END AS Status INTO CanPlaceOrder
		FROM Customers 
		WHERE customerNumber = CustNo;
	END IF;
END //

DELIMITER ;

CALL CustCreditLimit(103, 23000, @CanPlaceOrder);
    
SELECT @CanPlaceOrder;


----------------------- OPTION 2
DELIMITER //

CREATE PROCEDURE CustCreditLimit2(IN CustNo INT, IN OrdAmt DECIMAL(10, 2), OUT CanPlaceOrder VARCHAR(25))
BEGIN
    IF NOT EXISTS(SELECT 1 FROM customers WHERE customerNumber = CustNo) THEN
    SIGNAL SQLSTATE '45000'
    SET message_text = "Customer Does not Exist";
    
    ELSE
		SELECT 
			CASE
				WHEN OrdAmt > creditLimit THEN "No"
				ELSE "Yes"
			END AS Eligibility INTO CanPlaceOrder
		FROM Customers 
		WHERE customerNumber = CustNo;
	END IF;
END //

DELIMITER ;

CALL CustCreditLimit2(112, 10000, @CanPlaceOrder);
    
SELECT @CanPlaceOrder AS IsCreditEligible;





