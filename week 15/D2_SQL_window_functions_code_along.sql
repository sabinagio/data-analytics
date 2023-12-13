USE sakila;

SELECT * FROM film;

-- Reminder about WHERE clause

-- Find the average movie duration only for movies that have Trailers within the special features

-- HAVING clause example


-- ACTIVITY 1 - HAVING clause
-- 1.1. Find out how many movies of each category we have in our inventory.
-- 1.2. How do we filter for categories with > 300 movies?
-- 2. Now do the same, but show the results per store and filter by categories with more than 150 movies per store.
-- 3.1. Find out average rental price by movie category.

-- 3.2. How do we filter for categories with an average rental rate higher than $3?

-- WINDOW functions example


-- ACTIVITY 2 - WINDOW functions
-- 1. Get the average rental rate per movie category using WINDOW functions. 
-- Q: Why would it be useful to calculate this per row?
-- 2.Now get the ranking of each movie per category based on replacement_cost

-- ACTIVITY 3 - ROW_NUMBER(), RANK(), DENSE_RANK()
-- 1. What happens to the ranking we calculated previously if we switch the RANK() function to ROW_NUMBER() or DENSE_RANK()?