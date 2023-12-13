USE sakila;

-- ACTIVITY 1
-- 1. Find out how many movies of each category we have in our inventory.

-- STEPS:
-- 1. Find the movies we have in inventory
-- 2. Add the movie categories to our table
-- 3. Aggregate the movies to find out the movies per category

SELECT category.name, COUNT(*) AS no_movies
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
JOIN inventory USING (film_id)
GROUP BY category.name
ORDER BY no_movies DESC;

-- Q: How do we filter for categories with > 300 movies?
SELECT category.name, COUNT(*) AS no_movies
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
JOIN inventory USING (film_id)
GROUP BY category.name
HAVING no_movies > 300
ORDER BY no_movies DESC;

-- 2. Now do the same, but show the results per store and filter by categories with more than 150 movies per store.
SELECT category.name, store_id, COUNT(*) AS no_movies
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
JOIN inventory USING (film_id)
GROUP BY category.name, store_id
HAVING no_movies > 150
ORDER BY store_id, no_movies DESC;

-- 3. Find out average rental price by movie category.
SELECT category.name, AVG(rental_rate) AS avg_rental_rate
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
GROUP BY category.name
ORDER BY avg_rental_rate DESC;
-- Q: How do we filter for categories with an average rental rate higher than $3?

-- ACTIVITY 2 - WINDOW functions
-- 1. Get the average rental rate per movie category using WINDOW functions.
 SELECT 
	category.name, 
    AVG(rental_rate) OVER (PARTITION BY category.name) AS avg_category_rate,
    film.rental_rate,
    film.*
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
ORDER BY avg_category_rate DESC;
-- Q: Why would it be useful to calculate this per row?

-- 2.1. Now get the ranking of each movie per category based on replacement_cost
 SELECT 
	category.name, 
    RANK() OVER (PARTITION BY category.name ORDER BY replacement_cost DESC) AS replacement_cost_rank,
    film.replacement_cost,
    film.*
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
ORDER BY replacement_cost_rank;

-- 2.2. Also show the average replacement cost and rental rate
 SELECT 
	category.name, 
    RANK() OVER (PARTITION BY category.name ORDER BY replacement_cost DESC) AS replacement_cost_rank,
    AVG(replacement_cost) OVER (PARTITION BY category.name) AS avg_replacement_cost,
    film.replacement_cost,
    AVG(rental_rate) OVER (PARTITION BY category.name) AS avg_rental_rate,
    film.rental_rate,
    film.*
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
ORDER BY replacement_cost_rank;

-- ACTIVITY 3 - ROW_NUMBER(), RANK(), DENSE_RANK()
-- 1. What happens to the ranking we calculated previously if we switch the RANK() function to ROW_NUMBER() or DENSE_RANK()?
 SELECT 
	category.name, 
    RANK() OVER (PARTITION BY category.name ORDER BY replacement_cost DESC) AS replacement_cost_rank,
    DENSE_RANK() OVER (PARTITION BY category.name ORDER BY replacement_cost DESC) AS replacement_cost_dense_rank,
    ROW_NUMBER() OVER (PARTITION BY category.name ORDER BY replacement_cost DESC) AS replacement_cost_row_no,
    AVG(replacement_cost) OVER (PARTITION BY category.name) AS avg_replacement_cost,
    film.replacement_cost,
    AVG(rental_rate) OVER (PARTITION BY category.name) AS avg_rental_rate,
    film.rental_rate,
    film.*
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
ORDER BY category.name;

