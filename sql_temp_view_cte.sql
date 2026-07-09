-- 1. First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
 USE sakila;
 
 CREATE VIEW view_customer_rental_info AS
	SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS total_num_rentals 
    FROM customer AS c
	JOIN rental AS r
	ON c.customer_id = r.customer_id
	GROUP BY c.customer_id;

-- 2. Create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
-- calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE temp_tot_amount_paid AS(
	SELECT p.customer_id, SUM(p.amount) AS total_paid 
    FROM payment AS p
	JOIN view_customer_rental_info AS v
	ON p.customer_id = v.customer_id
	GROUP BY p.customer_id);

-- 3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
SELECT * FROM temp_tot_amount_paid;
SElECT * FROM view_customer_rental_info;

WITH cte_rental_payment_summary AS (
	SELECT v.first_name, v.last_name, v.email, v.total_num_rentals, t.total_paid
	FROM temp_tot_amount_paid AS t
	JOIN view_customer_rental_info AS v
	ON t.customer_id = v.customer_id)
SELECT * FROM cte_rental_payment_summary;

-- 4. Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column 
-- from total_paid and rental_count.

WITH cte_rental_payment_summary AS (
	SELECT v.first_name, v.last_name, v.email, v.total_num_rentals, t.total_paid
	FROM temp_tot_amount_paid AS t
	JOIN view_customer_rental_info AS v
	ON t.customer_id = v.customer_id)
SELECT first_name, last_name, email, total_num_rentals, total_paid, total_paid / total_num_rentals AS average_payment_per_rental 
FROM cte_rental_payment_summary;









