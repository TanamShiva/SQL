-- SECTION 1: Temporary Tables
-- In these questions, use temporary tables (CREATE TEMPORARY TABLE or WITH Common Table Expressions) to structure your logic.

-- Top Customers by Revenue
-- Create a temporary table of total revenue per customer.
-- Then select the top 10 customers by revenue.

create temporary table top_10_customers as
select 
	c.customer_id, 
    c.first_name, 
    c.last_name,
    sum(p.amount) as revenue
from customer c
join payment p using(customer_id)
group by c.customer_id, c.first_name, c.last_name
order by revenue desc;

select * from top_10_customers limit 10;

-- Most Rented Films by Category
-- Use a temporary table to calculate how many times each film was rented.
-- Join with the film_category and category tables to get the top 3 rented films in each category.

create temporary table film_count as
select 
	name as category_name,
    film_id, 
    title, 
    count(inventory_id) as rentalcount, 
    rank() over(partition by name order by count(inventory_id)) as cat_rank
from rental
join inventory using(inventory_id)
join film using(film_id)
join film_category using(film_id)
join category using(category_id)
group by name, film_id, title;

drop temporary table film_count;

select * from film_count
where cat_rank <=3
order by category_name, rentalcount desc;

-- Average Rental Duration by Film Rating
-- Create a temporary table that calculates the average rental duration (based on rental_date and return_date) for each film.
-- Then group this data by the film's rating (e.g., G, PG, R, etc.).

create temporary table avg_rental_duration as
select 
	film_id, 
	title, 
	avg(datediff(return_date, rental_date)) as rental_duration
from rental
join inventory using(inventory_id)
join film using(film_id)
group by film_id, title;

select 
	f.rating,
	avg(ard.rental_duration) as avg_duration_per_rating
from avg_rental_duration ard
join film f using(film_id)
group by f.rating
order by avg_duration_per_rating;

-- Customer Rental Activity by Month
-- Use a temporary table to get the count of rentals for each customer per month.
-- Then summarize how many months each customer was active.

create temporary table customer_monthly_rentals as
select 
	customer_id, 
    first_name, 
    last_name, 
    date_format(rental_date, '%Y-%m') as Month_year, 
    count(inventory_id) as rentalCount 
from customer 
join rental using(customer_id)
group by customer_id, first_name, last_name, date_format(rental_date, '%Y-%m');

select 
    customer_id,
    first_name,
    last_name,
    count(*) as active_months,
	sum(rentalcount) as total_rentals
from customer_monthly_rentals
group by customer_id, first_name, last_name
order by active_months desc, customer_id;


-- Revenue per Film (Latest 3 Months Only)
-- Use a temporary table to filter rentals/payments from the last 3 months in the dataset.
-- Then calculate total revenue per film.

create temporary table payments_table as
select 
	rental_id, 
	rental_date, 
    payment_id, 
    payment_date, 
    amount, 
    inventory_id
from payment 
join rental using(rental_id)
where payment_date >= (
				select date_sub(max(payment_date), interval 3 month) from payment);

select 
	title, 
    sum(amount) as revenue 
from film
join inventory using(film_id)
join payments_table using(inventory_id)
group by title
order by sum(amount) desc;



-- 🟦 SECTION 2: Window Functions
-- These questions require use of window functions such as RANK(), ROW_NUMBER(), SUM() OVER(), etc.

-- Top Rented Film per Category
-- Use RANK() or ROW_NUMBER() partitioned by category to find the most rented film in each category.

select title, category_name, rental_count
from 
	(select title, name as category_name, count(inventory_id) as rental_count, 
	rank() over(partition by category_id order by count(inventory_id) desc) as film_rank
	from film
	join film_category using(film_id)
	join category using(category_id)
	join inventory using(film_id)
	join rental using(inventory_id)
	group by title, name, category_id
	)
as rank_table
where film_rank = 1
ORDER BY category_name;


-- Customer Rental Rank
-- For each customer, rank their rentals by rental date using ROW_NUMBER() or RANK().
select customer_id, first_name, last_name, rental_date,
rank() over(partition by customer_id order by rental_date) as rental_rank
from customer 
join rental using(customer_id)
order by customer_id, rental_rank;


-- Running Total of Payments by Customer
-- Show a running total of payments for each customer over time using SUM(...) OVER (PARTITION BY customer_id ORDER BY payment_date).
select customer_id, first_name, last_name, payment_date, amount,
sum(amount) over(partition by customer_id order by payment_date
				rows between unbounded preceding and current row) as running_total
from customer 
join payment using(customer_id);

-- to rank payments, should add rank() as a separate column like below
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  p.payment_date,
  p.amount,
  SUM(p.amount) OVER (
    PARTITION BY c.customer_id 
    ORDER BY p.payment_date, p.payment_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total,
  RANK() OVER (
    PARTITION BY c.customer_id 
    ORDER BY p.payment_date, p.payment_id
  ) AS rankk
FROM customer c
JOIN payment p USING(customer_id)
ORDER BY c.customer_id, p.payment_date, p.payment_id;

-- Days Between Rentals
-- For each customer, calculate the number of days between consecutive rentals using LAG() or LEAD() on the rental_date.

select customer_id, first_name, last_name, rental_date, last_rental,
datediff(rental_date, last_rental) as diff_days
from (
	select customer_id, first_name, last_name, rental_date,
	lag(rental_date) over(partition by customer_id order by rental_date) as last_rental
	from customer
	join rental using(customer_id)
) as leaddays
where last_rental is not null;


-- Rental Count vs. Category Average
-- For each film, calculate its total number of rentals.
-- Use a window function to calculate the average number of rentals per film within the same category.
-- Then show whether each film is above or below average.

select title, 
		case
			when rentalcount> avgrentalcount then "Above_avg"
            else "Below_avg"
		end as Level
from
	(
	select 
		title, 
		name as category, 
		count(inventory_id) as rentalcount,
		avg(count(inventory_id)) over (partition by category_id) as avgrentalcount
	from film 
	join inventory using(film_id)
	join rental using(inventory_id)
    join film_category using(film_id)
	join category using(category_id)
	group by title, category_id, name
    ) as rentalcounttable
order by category, rentalcount desc;


-- 🟨 BONUS: Combine Both
-- Monthly Revenue Rankings
-- Use a temporary table to calculate total revenue per customer per month.
-- Then use a window function to rank customers by revenue within each month.
create temporary table revenuetable as
select customer_id, year(payment_date) as yearNo, month(payment_date) as monthNo, sum(amount) as revenue from payment
group by customer_id, year(payment_date), month(payment_date)
order by yearNo, monthNo, revenue desc;

select customer_id, yearNo, monthNo, revenue,
rank() over(partition by yearNo, monthNo order by revenue desc) as revenueRank
from revenuetable
order by yearNo, monthNo, revenueRank;


-- Longest Consecutive Rentals
-- Use window functions (LAG(), LEAD()) to identify customers who rented films in consecutive days.
-- Use temporary tables to group consecutive rentals into streaks.
/* temporary table is not used here */
SELECT customer_id,
       rental_date,
       SUM(new_streak_flag) OVER(PARTITION BY customer_id ORDER BY rental_date ROWS UNBOUNDED PRECEDING) + 1 AS streak_id
FROM (
    SELECT customer_id,
           rental_date,
           CASE
               WHEN DATEDIFF(rental_date, LAG(rental_date) OVER(PARTITION BY customer_id ORDER BY rental_date)) = 1
               THEN 0
               ELSE 1
           END AS new_streak_flag
    FROM rental
) AS flagged_rentals
ORDER BY customer_id, rental_date;


-- Repeat Rentals
-- Identify customers who rented the same film multiple times.
-- Use ROW_NUMBER() or COUNT(*) OVER() to help identify repeats.

select distinct customer_id, first_name, last_name, title, filmcount
from 
(
	select customer_id, first_name, last_name, title, 
			count(*) over(partition by customer_id, film_id) as filmcount
	from customer
	join rental using(customer_id)
	join inventory using(inventory_id)
	join film using(film_id)
) as filmcounttable
where filmcount > 1
order by customer_id, title;

-- other way to solve the same above question
select customer_id, first_name, last_name, title, count(*) as filmcount
	from customer
	join rental using(customer_id)
	join inventory using(inventory_id)
	join film using(film_id)
group by customer_id, film_id
having filmcount > 1
order by customer_id, title;
