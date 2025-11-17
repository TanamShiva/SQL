-- corelated subquery: the inner query does not yield any result independently. 
-- non-corelated subquery: the inner query yields some result independently. 

-- the inner query must return a single column when it's written in where clause.


-- select customernumber, amount from payments 
-- where amount >= (select max(amount) from payments);

-- calculate number of rentals per film and display max, min & avg count
select 
	Max(rental_count) as maxRentalCount, 
    Min(rental_count) as minRentalCount,
    round(Avg(rental_count)) as avgRentalCount
from
	(select film_id, count(rental_id) as rental_count 
	from rental 	
    join inventory using(inventory_id)
	group by film_id) as rentalcounttable;


-- find products with prices greater than avg price of their productline
select productname, productline, buyprice
from products p1
where buyprice > (select avg(buyprice) from products p2
				  where p1.productline = p2.productline) -- this line works both like a join & group by
order by productline, buyprice;
select * from products;

-- using subquery in select clause
select 
		productname, 
        buyprice, 
        productline, 
        (select avg(buyprice) from products p1
        where p1.productline = p2.productline) as avgbuyprice
from products p2
order by productline, avgbuyprice;


-- find latest order date of each customer
select customernumber, 
		customername,
		(select max(orderdate) from orders o
        where o.customerNumber = c.customernumber) as recentorderdate
from customers c;

-- find first & latest order date of each customer
select customernumber, 
		customername,
        (select min(orderdate) from orders o
        where o.customerNumber = c.customernumber) as firstorderdate,
		(select max(orderdate) from orders o
        where o.customerNumber = c.customernumber) as recentorderdate
from customers c;
-- the same result can be achived used joins too.



-- MAVEN MOVIES based questions

-- Find the name of the customer who made the highest payment.
select 
		c.customer_id, 
        c.first_name, 
        c.last_name, 
        p.amount 
from customer c
join payment p using(customer_id)
where p.amount = (select max(amount) from payment);

-- Use a subquery to find the max amount in the payment table.
select amount from payment
where amount = (select max(amount) from payment);

-- List all films that have a rental rate higher than the average rental rate.
select title, rental_rate from film
where rental_rate > (select avg(rental_rate) from film);

-- Find all customers who have rented a film with the title 'Academy Dinosaur'.
-- Use a subquery to get the film_id of that title and trace it via inventory and rental.
select customer_id, first_name, last_name from customer
join rental using(customer_id)
join inventory using(inventory_id)
join film using(film_id)
where film_id in (select film_id from film 
					where title = 'Academy Dinosaur')
order by customer_id;

-- Get the list of films that were not rented even once.
-- Use a subquery with NOT IN or NOT EXISTS on the rental table.
select title from film
join inventory using(film_id)
where inventory_id not in (select inventory_id from rental);

-- or -- 
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE NOT EXISTS (
    SELECT rental_id FROM rental r WHERE r.inventory_id = i.inventory_id
);

-- List all actors who acted in more films than the average number of films per actor.
-- Use subqueries with groupings on film_actor.                 
select 
	first_name, 
    last_name from actor
	where actor_id in (
					select actor_id 
                    from film_actor
					group by actor_id
					having count(film_ID)>
								(select avg(filmCount) from 
												(select 
														actor_id, 
														count(film_id) as filmCount 
														from film_actor
														group by actor_id) as filmcountTable)
														); 



-- 🟡 Intermediate Level

-- Find the customers who made more payments than the average number of payments per customer.
-- Subquery to calculate average payments, then group and compare.
select 
	customer_id, 
    first_name, 
    last_name 
from customer 
where customer_id in (
	select customer_id 
	from payment
	group by customer_id
	having count(payment_id) > (
		select avg(paymentsCount) 
        from 
			(select customer_id, count(payment_id) as paymentsCount 
             from payment 
			 group by customer_id
             ) as paymentsCountTable
		)
	);

-- Find the titles of all films that were rented by 'Mary Smith'.
-- Use subqueries to find customer ID and trace the rentals.
select distinct title as Films_rented_by_MarySmith 
from film
join inventory using(film_id)
join rental using(inventory_id)
where customer_id in (
	select customer_id from customer
	where first_name = 'Mary' and last_name = 'Smith'
	);

-- List the top 5 films with the highest revenue (sum of payment amounts).
-- Requires subqueries with joins to payment, rental, inventory, and film.
select title,
			(
            select sum(p.amount) 
            from inventory i
            join rental r using(inventory_id)
			join payment p using(rental_id)
            where i.film_id = f.film_id
            ) as revenue
from film f
order by revenue desc
limit 5;

-- Find the title of the film that generated the highest total revenue from rentals.
select title,
		(select sum(amount) 
        from inventory 
        join rental on inventory.inventory_id = rental.inventory_id
		join payment on rental.rental_id = payment.rental_id
        where film.film_id = inventory.film_id
		) as revenue
from film
order by revenue desc
limit 1;

-- Find the customers who have never returned any movie late.
-- Use a subquery to check for return_date > due_date logic, then exclude.
select customer_id, first_name, last_name
from customer
where customer_id not in
	(select distinct customer_id 
	from rental
	join inventory using(inventory_id) 
	join film using(film_id)
	where return_date > date_add(rental_date, interval rental_duration day)
);

-- Find the film(s) that have the same rental rate as the most expensive film.
-- Scalar subquery to get the max rental rate.
select title, rental_rate from film 
where rental_rate = (select max(rental_rate) from film);




-- CLASSIC MODELS based questions 
-- Beginner-Level Subquery & Join Practice

-- Find the names of all customers who have made a payment.

-- Use a subquery to find customer numbers from payments.

-- List the products that have never been ordered.

-- Use NOT IN or NOT EXISTS with a subquery on orderdetails.

-- Get the names of employees who are also managers.

-- Use a self-join or subquery on the employees table.

-- Find the customer(s) who placed the highest total value order.

-- Aggregate order value per order using orderdetails, then use a subquery to get the max.

-- List customers who are from the same city as office locations.

-- Compare customers.city with offices.city using a subquery or join.

-- 🟡 Intermediate Subquery Practice

-- Find the products whose price is higher than the average product price.

-- Scalar subquery to find average price from products.

-- List the employees who work in the same office as employee 'Diane Murphy'.

-- Use a subquery to find her office code.

-- Find the customers who placed more orders than the average number of orders per customer.

-- Subquery with GROUP BY and count.

-- Get a list of customers who have not placed any orders.

-- Use NOT IN or NOT EXISTS with orders.

-- Find all orders that include the product ‘S18_1749’.

-- Use subquery to find productCode, then get orderNumber.

-- 🔴 Advanced Subquery / Correlated Subquery Practice

-- Find the customer(s) who made the highest total payments.

-- Sum payments per customer, then subquery for the max.

-- List customers who have only ever ordered products from a single product line.

-- Subquery to count distinct product lines per customer.

-- List products that were ordered more than the average order quantity across all products.

-- Use a subquery to get average quantityOrdered.

-- Find all orders where the total order value exceeds the average order value across all orders.

-- Subquery with SUM(priceEach * quantityOrdered) grouped by orderNumber.

-- Find employees who manage other employees and have made more sales than the people they manage.

-- Complex subquery or self-join on employees, with sales totals from customers → orders.
