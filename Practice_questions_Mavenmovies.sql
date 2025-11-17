-- Operators (Comparison, Logical, Arithmetic)
-- 1.Find all films with a rental_rate greater than 2.99.
select title, rental_rate from film where rental_rate > 2.99;

-- 2.List all customers who are not active (active = 0).
select customer_id, first_name, last_name, active from customer where active = 0;

-- 3.Display films that cost between 1.99 and 3.99 to rent.
select title,rental_rate from film where rental_rate between 1.99 and 3.99;

-- 4.Show films released after 2005 and with a rating of 'PG'.
select title, release_year from film where release_year > 2005 and rating = 'PG';

-- 5.Calculate the total cost of a rental if the rental_rate * rental_duration exceeds 10.
select 
		film_id, 
        (rental_rate * rental_duration) AS total_cost 
from film
where (rental_rate * rental_duration) > 10;


-- Alias, DISTINCT, LIMIT
-- 6.Show the distinct ratings available in the film table.
select distinct rating AS distinct_ratings from film;

-- 7.Display the first 10 films’ titles and rental rates with column aliases like Movie_Title and Rental_Price.
select title AS Movie_Title, rental_rate as Rental_Price from film limit 10;

-- 8.Retrieve the top 5 most expensive films by rental_rate.
select title, rental_rate from film
order by rental_rate desc
limit 5;

-- 9.Find how many unique customers rented movies from store 1.
select count(distinct customer_id) AS distinct_cust_count 
from rental r
join inventory i using(inventory_id) 
where store_id = 1;


-- String Functions
-- 10.Show all customer names in uppercase.
select upper(concat(first_name,' ', last_name)) as customer_name from customer;

-- 11.Display film titles in lowercase that are more than 15 characters long.
select lower(title) as film_title from film  where len(title) > 15;

-- 12.Find the length of each movie title and show only those longer than 20 characters.
select title, len(title) as title_length from film where len(title) > 20;

-- 13.Concatenate the customer’s first and last names as Full_Name.
select concat(first_name,' ', last_name) as Full_name from customer;

-- 14.Find all films whose titles contain the substring 'LOVE'.
select title from film where title like '%LOVE%';


-- Numeric Functions
-- 15.Display each film’s rental rate rounded to the nearest whole number.
select title, round(rental_rate) as rounded_rate from film;

-- 16.Show the minimum, maximum, and average rental_duration of all films.
select 
	min(rental_duration) AS Min_duration, 
	max(rental_duration) AS Max_duration, 
	avg(rental_duration) AS Avg_duration 
from film;

-- 17.Calculate the square root of the average replacement_cost.
select sqrt(avg(replacement_cost)) AS sqrt_avg_repl_cost from film;

-- 18.For each film, compute the rental_rate * rental_duration as Estimated_Revenue.
select title, (rental_rate * rental_duration) as Estimated_Revenue from film;

-- Temporal (Date & Time) Functions
-- 19.Show the current date using CURDATE() or NOW().
select curdate();

-- 20.Display all rentals made in the last 30 days.
select rental_id, inventry_id, customer_id, rental_date from rental
where rental_date >= date_sub(curdate(), interval 30 day);

-- 21.Calculate the number of days between each rental’s rental_date and return_date.
select rental_id, datediff(return_date, rental_date) AS num_days from rental;

-- 22.Find rentals where the due date (rental_date + rental_duration) has already passed but no return_date.
select r.rental_id, r.rental_date, f.rental_duration,
       date_add(r.rental_date, interval f.rental_duration day) as due_date
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
where r.return_date is null 
  and curdate() > date_add(r.rental_date, interval f.rental_duration day);

-- 23.Extract the month and year from each rental date.
select rental_date, month(rental_date) as Month, year(rental_date) as Year from rental;


-- LIKE / NOT LIKE / Wildcards
-- 24.Find all customers whose last name starts with ‘S’.
select last_name from customer where last_name like 'S%';

-- 25.Find all films whose title ends with 'MAN'.
select title from film where title like '%MAN';

-- 26.Show customers whose email contains 'gmail'.
select first_name, email from customer where email like '%gmail%';

-- 27.Find films whose title has 'THE' anywhere inside.
select title from film where upper(title) like '%THE%';

-- 28.List films whose title does not contain 'A'.
select title from film where upper(title) not like '%A%';


-- Primary & Foreign Key Understanding
-- 29.Identify the primary key and foreign keys in the rental table.
show index from rental;

-- 30.Write a query showing how rental connects customer, inventory, and film via foreign keys.
-- 31.Retrieve all foreign key relationships from rental to its related tables. (Conceptual question – can be answered by describing the schema.)


-- Joins
-- 32.List all rentals with the customer’s first name, last name, and film title.
select c.first_name, c.last_name, r.rental_id, f.title 
from customer c
join rental r using(customer_id)
join inventory i using (inventory_id)
join film f using(film_id); 

-- 33.Show all films that have never been rented (use LEFT JOIN and WHERE rental_id IS NULL).
select title, rental_id from film
join inventory using(film_id)
left join rental using(inventory_id)
where rental_id IS NULL;

-- 34.Display each film’s title along with the store address where it’s available.
select f.title, s.store_id, a.address_id, a.address, a.district, a.postal_code, a.phone from film f
join inventory i using(film_id)
join store s using(store_id)
join address a using(address_id);

-- 35.Show how many rentals each customer has made (use JOIN + GROUP BY).
select 
    c.first_name, 
    c.last_name, 
    count(r.rental_id) as rental_count
from customer c
join rental r using (customer_id)
group by c.customer_id, c.first_name, c.last_name;

-- 36.Get all staff members and the stores they manage (using JOIN between staff and store).
select s.first_name, s.last_name, st.store_id from staff s
join store st using(store_id);


-- Aggregate Functions
-- 37.Count how many films have a rating of 'PG-13'.
select rating, count(film_id) AS film_count from film where rating = 'PG-13';

-- 38.Find the average rental rate of all films.
select avg(rental_rate) as Avg_Rental_Rate from film;

-- 39.Find the total number of rentals each day.
select date(rental_date) AS Day, count(rental_id) AS rental_count from rental group by date(rental_date);

-- 40.Calculate the total revenue (sum of payment amounts) by staff member.
select s.staff_id, s.first_name, s.last_name, round(sum(p.amount)) as revenue from staff s 
join payment p using(staff_id)
group by s.staff_id, s.first_name, s.last_name
order by revenue desc;

-- 41.Find the maximum, minimum, and average film length.
select 
	MAX(length) AS max_filmlength, 
    MIN(length) AS min_filmlength, 
    round(AVG(length)) AS Avg_filmlength 
from film;

-- ORDER BY, GROUP BY, HAVING
-- 42.List customers and the number of rentals they’ve made, ordered by most rentals first.
select 
		c.customer_id, 
        concat(c.first_name, ' ',c.last_name) as customer, 
        count(r.inventory_id) as rental_count 
from customer c
join rental r using(customer_id) 
group by c.customer_id, customer
order by rental_count desc;

-- 43.Group films by rating and show the average rental rate per rating.
select rating, round(avg(rental_rate), 2) AS Avg_rental_rate from film
group by rating
order by Avg_rental_rate desc;

-- 44.Find which rating category has more than 200 films (use HAVING).
select rating, count(film_id) as film_count from film
group by rating
having count(film_id) > 200; 

-- 45.Show the top 5 customers who have spent the most on rentals (using ORDER BY + LIMIT).
select 
		c.customer_id, 
        concat(c.first_name, ' ',c.last_name) as customer_name, 
        sum(p.amount) AS Amount_spent 
from customer c
join payment p using(customer_id)
group by c.customer_id, customer_name
order by Amount_spent desc 
limit 5;

-- 46.Group payments by customer and find those whose total payments exceed $100.
select customer_id, sum(amount) as total_payment from payment
group by customer_id
having total_payment > 100
order by total_payment desc;

-- Bonus (Mixed Concepts)
-- 47.Find films that were never rented in 2024.
select title from film 
join inventory using(film_id)
join rental using(inventory_id)
where rental_id NOT IN (select rental_id from rental where year(rental_date) = 2005);

-- 48.List customers who rented movies more than 5 times in the last 6 months.
select 
		c.customer_id, 
        concat(c.first_name, ' ',c.last_name) as customer_name, 
        count(r.rental_id) AS movies_count
from customer c
join rental r using(customer_id)
where rental_date <= date_sub(curdate(), interval 6 month)
group by c.customer_id, c.first_name, c.last_name 
having movies_count > 5
order by movies_count desc, customer_name;
        
-- 49.Display the top 3 most rented movie titles of all time.
select f.title, count(i.film_id) as rental_count from film f
join inventory i using(film_id)
join rental r using(inventory_id)
group by f.film_id, f.title
order by rental_count desc 
limit 3;

-- 50.Find all overdue rentals (where return date > due date) with customer and staff names.
select 
		c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name,
        s.staff_id, concat(s.first_name, ' ', s.last_name) as staff_name,
        r.rental_id,
        r.rental_date,
        r.return_date,
        date_add(r.rental_date, interval f.rental_duration day) as due_date
from customer c 
join rental r using(customer_id)
join inventory i using(inventory_id)
join film f using(film_id)
join staff s using(staff_id)
where r.return_date > date_add(r.rental_date, interval f.rental_duration day)
order by r.return_date desc;
