

WITH USCustomers AS
(
select * from customers
where country = 'USA'
)
select customername, city, state from 
USCustomers
where state = 'CA';


create index idx_customer_email on customer(email);

show index from customer;
drop index idx_customer_email on customer;


with EachCustomerSale AS
(
select 
	customernumber, 
    round(sum(quantityordered * priceeach)) as totalsale
from orders 
join orderdetails using(ordernumber)
group by customernumber
order by totalsale desc
)
select * from EachCustomerSale;



with topproducts as 
(
select 
	productcode, 
    round(sum(quantityordered * priceeach)) as totalsale
from orderdetails 
group by productcode
)
select * from topproducts
order by totalsale desc
limit 5;



-- actor wise movie count
select 
	actor_id, 
    concat(first_name,' ',last_name) as ActorName, 
    count(film_id) as movieCount 
from actor
join film_actor using(actor_id)
group by actor_id;

-- inventory count
select 
	actor_id,
    count(film_id) as InventoryCount
from actor
join film_actor using(actor_id)
join inventory using(film_id)
group by actor_id;

-- rental count
select 
	actor_id,
    count(rental_id) as RentalCount
from actor
join film_actor using(actor_id)
join inventory using(film_id)
join rental using(inventory_id)
group by actor_id;

-- actor wise revenue generated
select 
	actor_id,
    sum(amount) as revenue
from film_actor
join inventory using(film_id)
join rental using(inventory_id)
join payment using(rental_id)
group by actor_id;


-- total CTE using above 

WITH MoviesCount AS
(
SELECT
	Actor_id, 
    CONCAT(first_name,' ',last_name) AS ActorName, 
    COUNT(film_id) AS MovieCount 
FROM actor
JOIN film_actor USING(actor_id)
GROUP BY actor_id
),
InventoriesCount AS
(
SELECT 
	actor_id,
    COUNT(film_id) AS InventoryCount
FROM actor
JOIN film_actor USING(actor_id)
JOIN inventory USING(film_id)
GROUP BY actor_id
),
RentalsCount AS
(
SELECT 
	actor_id,
    COUNT(rental_id) AS RentalCount
FROM actor
JOIN film_actor USING(actor_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY actor_id
),
RevenueGen AS
(
SELECT 
	actor_id,
    SUM(amount) AS RevenueGenerated
FROM film_actor
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
JOIN payment USING(rental_id)
GROUP BY actor_id
)
SELECT 
	Actor_id, 
	ActorName,
    MovieCount,
    InventoryCount,
    RentalCount,
    RevenueGenerated,
    RANK() OVER(ORDER BY RevenueGenerated DESC) AS ActorRank
FROM MoviesCount
JOIN InventoriesCount USING(actor_id)
JOIN RentalsCount USING(actor_id)
JOIN RevenueGen USING(actor_id);



------------------------------------------------------------------------------------------------------
-- Basic Index Concepts

-- What is the purpose of an index in a relational database?
-- A: index improves data retrieval speed and it is recommended to use it on frequently used columns as it consumes extra storage 
-- which can cuase performance issue.

-- What’s the difference between a clustered and non-clustered index?
-- A: clustered index is created by default when a datble is created based on primary key. Non-clustered index has to 
-- be created manually as per the need. 

-- When can an index actually hurt performance instead of helping it?
-- A: when we create index on multiple columns, as it consumes additional space which can lead to performance issues.

-- How do you view all indexes on a table in your database system (e.g., MySQL or PostgreSQL)?
-- A: SHOW INDEX FROM TBALE_NAME;
-- for example: show index from customer;



-- Practical Index Tasks
-- Create an index on the rental_date column in the rental table to speed up lookups by date.
create index idx_rental_renatl_date on rental(rental_date);

-- Create a composite index on (last_name, first_name) in the customer table.
create index idx_cust_fname_lname on customer(first_name, last_name);

-- Drop an index you created earlier.
drop index idx_rental_renatl_date on rental;
show index from rental;

-- Check how many indexes exist on the payment table.
show index from payment;

-- Create an index on the film.title column. Then, test query performance with and without the index:

explain analyze select * from film
where title = 'ACADEMY DINOSAUR';

create index idx_film_title on film(title);

explain analyze select * from film
where title = 'Academy DINOSAUR';

show index from film;


-- Which queries on the rental or payment tables would benefit most from indexing? Explain why.
-- rental_id from rental and payment_id from payment tables benefit the most with indexes becauses they are high selective 

-- Add an index to improve performance of this query:
-- SELECT * 
-- FROM payment
-- WHERE customer_id = 42 AND payment_date BETWEEN '2005-07-01' AND '2005-07-31';
 
create index idx_cust_pay on payment(customer_id, payment_date);

--------------------------------------------------------------------------------------------------------
-- Basic CTE Usage
-- Write a CTE to list all films and their rental rates, then in the main query, filter for those with rental rates above average.
with filmrentals as
(
select title, rental_rate from film
)
select * from filmrentals
having rental_rate > (select avg(rental_rate) from film);

-- Use a CTE to find customers who have made more than 10 rentals.
WITH RentalCount AS
(
select customer_id, count(*) as rentalCount from customer
join rental using(customer_id)
group by customer_id
having count(*) > 10
)
select * from RentalCount;


-- Write a CTE that calculates total revenue per customer, then select only the top 5 spenders.
with revenuepercustomer as
(
select customer_id, sum(amount) as revenue
from customer
join payment using(customer_id)
group by customer_id
)
select * from revenuepercustomer
order by revenue desc
limit 5;

-- Create a CTE that lists each film and how many times it has been rented.
with filmrentalcount as 
(
select title, count(rental_id) as rentalcount 
from film
join inventory using(film_id)
join rental using(inventory_id)
group by title
)
select * from filmrentalcount;

-- Using a CTE, find all customers who have never made a rental.
with norentalcustomer as
(
select customer_id, rental_id from customer
left join rental using(customer_id)
where rental_date is null
)
select * from norentalcustomer;


-- Nested and Recursive CTEs
-- Create a CTE that finds the number of rentals per month, then use it in the main query to calculate month-over-month growth.
WITH MonthlyRentals AS
(
SELECT
	MONTH(rental_date) as Month_No, 
    MONTHNAME(rental_date) as MonthNames,
    COUNT(*) AS RentalCount
FROM rental
GROUP BY MONTH(rental_date), MONTHNAME(rental_date)
)
SELECT
	Month_No,
    MonthNames,
    RentalCount,
    LAG(RentalCount) OVER(ORDER BY Month_No) AS PreviousMonthRentals,
    ROUND(
		(RentalCount - LAG(RentalCount) OVER(ORDER BY Month_No)) / 
		LAG(RentalCount) OVER(ORDER BY Month_No) * 100
        ) AS MoMGrowthPer
 FROM MonthlyRentals
 ORDER BY Month_No;



-- Write a recursive CTE that generates a sequence of dates (e.g., the first 10 days of July 2005).


-- Use a CTE to identify the most frequently rented film for each category.
WITH film_rental_ranks as 
(
select 
		category_id,
        name,
        film_id,
        title,
        count(rental_id) as RentalCount,
        rank() over(partition by category_id order by count(rental_id) desc) as RentalRank
from category 
join film_category using(category_id)
join film using(film_id)
join inventory using(film_id)
join rental using(inventory_id)
group by category_id, name, film_id, title
)
select 
	name as CategoryName, 
    title as MostFrenquentlyRentedFilm, 
    RentalCount
from film_rental_ranks
where RentalRank = 1;
    

-- Combine multiple CTEs:
-- One to compute total payments per staff member.
-- Another to compute average payment per rental.
-- Then, join them to compare each staff’s performance against the average.

WITH StaffPaymentsCount AS
(
select 
	s.staff_id, 
    concat(first_name,' ',last_name) as fullname,
    sum(p.amount) as TotalPayment
from staff s
join payment p using(staff_id)
group by s.staff_id, first_name, last_name
),
AvgPayment AS
(
select
	s.staff_id,
    round(AVG(p.amount), 2) as AvgPaymentPerRental
from staff s
join rental r using(staff_id)
join payment p using(rental_id)
group by staff_id
)
select 
	spc.staff_id,
    spc.fullname,
    spc.TotalPayment,
    AvgPaymentPerRental
from StaffPaymentsCount spc
join AvgPayment using(staff_id);


-- Build a CTE chain (two or more CTEs) to:
-- First, calculate total rentals per film.
-- Then, find the average rental count.
-- Finally, return only films with above-average rental counts.

WITH FilmRentalCounts as 
(
select
	Film_id, 
    Title,
    count(rental_id) as RentalCount
from film
join inventory using(film_id)
join rental using(inventory_id)
group by film_id, title
),
AboveAvgFilms as
(
select * from FilmRentalCounts
where rentalcount > (select avg(rentalcount) from FilmRentalCounts)
)
select * from AboveAvgFilms
order by RentalCount desc;


-- Bonus Challenge (CTE + Index)
-- You’ve noticed this query runs slowly:
-- Your task:
-- Optimize it using proper indexing.
-- Verify performance improvements with EXPLAIN or EXPLAIN ANALYZE.

explain analyze
WITH revenue_per_customer AS (
    SELECT customer_id, SUM(amount) AS total_revenue
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, r.total_revenue
FROM revenue_per_customer r
JOIN customer c ON c.customer_id = r.customer_id
WHERE r.total_revenue > 100;

create index idx_cust_id on payment(customer_id);

explain analyze
WITH revenue_per_customer AS (
    SELECT customer_id, SUM(amount) AS total_revenue
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, r.total_revenue
FROM revenue_per_customer r
JOIN customer c ON c.customer_id = r.customer_id
WHERE r.total_revenue > 100;

show index from payment;