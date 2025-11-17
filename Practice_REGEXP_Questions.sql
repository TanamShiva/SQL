-- to find emails with any combination like .next / ord / co.in / co.uk etc
/*
select email from users
where email regexp '^[A-Z a-z 0-9 ._+-%]+@[A-Z a-z 0-9 ._+-%]+\\.[A-Z a-z]{2, }$';
*/

-- Customer & Email Filtering

-- 1. Find all customers whose email addresses end with .org.
select email from customer
where email regexp '.org$';

-- 2. List customers whose first names start with a vowel.
select first_name from customer
where first_name regexp '^[aeiouAEIOU]';

-- 3. Find customers whose last names contain double letters (e.g., "Allison", "Miller").
select last_name from customer
where last_name regexp '([a-zA-Z])\\1';

-- 4. Retrieve customers whose email usernames (before the @) contain numbers.
select first_name, last_name from customer
where email regexp '^[^@]*[0-9][^@]*@';

-- 5. List all customers whose email domains (after @) start with the letter 'g'.
select first_name, last_name from customer
where email regexp '^@g';


-- Film Titles & Descriptions

-- 6. Find all films whose titles contain exactly two words.
select title from film
where title regexp '^[^ ]+ [^ ]+$';

-- 7. Retrieve films with titles that start and end with the same letter.
select title from film
where lower(left(title, 1)) = lower(right(title, 1));

-- 8. Find all films whose descriptions contain the word "epic" regardless of case.
select description from film
where lower(description) regexp 'epic';

-- 9. List films with titles containing special characters or punctuation.
select title from film
where title regexp '[^a-zA-Z0-9 ]';

-- 10. Find films where the title ends with a number (e.g., “Sequel 2”).
select title from film
where title regexp '[0-9]$';


-- Address & City

-- 11. Find addresses that contain digits followed by a space and a word (e.g., "123 Main").
select address from address
where address regexp '[0-9]+ [a-zA-Z]+';

-- 12. Retrieve cities that start with 'San' but not 'Santa'.
select city from city
where city regexp '^San'
AND city not regexp '^Santa';

-- 13. Find all cities with hyphenated names.
select city from city
where city regexp '-';

-- 14. Get all addresses where the street name starts with 'B' and ends with 'n'.
select address from address
where address regexp '^.*\\bB[a-zA-Z]*n\\b$';

-- 15. List all addresses that include an apartment or unit number (look for patterns like "Apt", "#", "Unit").
select address from address
where address regexp 'Apt|#|Unit';


-- case statement
-- Classify film lengths as 'Short', 'Medium', or 'Long'
-- Use the length column in the film table.
-- Example Prompt:
-- Show film title and a new column that classifies the film as:
-- 'Short' if length < 60
-- 'Medium' if length between 60 and 120
-- 'Long' if length > 120
select title,
			case
				when length < 60 then 'Short'
                when length between 60 and 120 then 'Medium'
                Else 'Long'
			END AS 'film_length_category'
from film
order by film_length_category;

-- Determine if a customer is active or inactive
-- Use the customer table (column: active is usually 1 or 0)
-- Prompt:
-- Show customer ID, first name, and a column that shows 'Active' or 'Inactive' based on the active field.
select customer_ID, first_name,
		case
			when active = 1 then 'Active'
            else 'Inactive'
		end as 'Status'
from customer;

-- Categorize films by rental rate
-- Use the rental_rate column in film
-- Prompt:
-- Display film title and:
-- 'Low Price' for rental rate < 1
-- 'Standard' for rental rate = 2
-- 'Premium' for rental rate > 2
select title, 
		case
			when rental_rate < 1 then 'Low Price'
            when rental_rate = 2 then 'Standard'
            else 'Premium'
		end as 'rental_category'
from film
order by rental_category;

-- Tag customers as 'New' or 'Old' based on create date
-- Use create_date from the customer table.
-- Prompt:
-- If the customer was created in or after 2006, label as 'New', otherwise 'Old'.
select first_name, last_name,
			case
				when year(create_date) >= 2006 then 'New'
                else 'Old'
			end as 'cust_type'
 from customer;

-- Assign a region to each store
-- Use the store table and assume:
-- store_id = 1 is 'East'
-- store_id = 2 is 'West'
-- Prompt:
-- Show store ID and a new column region with values 'East' or 'West'.
select store_id,
			case
				when store_id = 1 then 'East'
                else 'West'
			end as 'Region'	
from store;

-- Check if a film is in English or not
-- Use the film table and join with language table.
-- Prompt:
-- For each film, show title and a column 'Is English' that says 'Yes' if language is 'English', otherwise 'No'.
select f.title, 
			case
				when l.name = 'English' then 'Yes'
                else 'No'
			end as 'Is_English'
from film f
join language l using(language_ID);

-- Evaluate inventory stock status
-- Use the inventory table and assume:
-- If film_id < 200 → 'Low Stock'
-- Between 200 and 800 → 'Normal Stock'
-- Above 800 → 'High Stock'
-- Prompt:
-- For each inventory item, display film_id and stock status based on the above rules.
select film_id, count(*) as Stock_count,
			case
				when count(*) < 200 then 'Low stock'
                when count(*) between 200 and 800 then 'Normal stock'
                else 'High stock'
			end as 'Stock_level'
from inventory
group by film_id;

-- Check if a rental is overdue
-- Use the rental table:
-- If return_date is null → 'Not Returned'
-- If return_date > due_date → 'Overdue'
-- Else 'Returned on Time'
-- (You may need to compute due_date using rental_date + rental_duration if due_date isn’t directly available.)
select rental_id, 
		date_add(rental_date, interval rental_duration day) as due_date, 
        return_date,
		case
			when return_date is null then 'Not returned'
			when return_date > date_add(rental_date, interval rental_duration day) then 'Overdue'
			else 'Returned on time'
		end as 'due_status'
from rental 
join inventory using(inventory_id)
join film using(film_id)
order by due_status;

-- Tag actors by last name starting letter
-- Use the actor table.
-- Prompt:
-- For each actor, display:
-- 'A-E' if last name starts with A–E
-- 'F-K' if starts with F–K
-- 'L-Z' otherwise
-- Use LEFT(last_name, 1) and CASE.

select last_name,
			case
				when left(last_name, 1) regexp '[A-E]' then 'A-E'
                when left(last_name, 1) regexp '[F-K]' then 'F-K'
                else 'L-Z'
			end as 'Name_tag'
 from actor;

