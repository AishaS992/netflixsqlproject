-- Netflix Project
-- use the excel sheet to determine the types and character length
-- for finding the max length and then what the character length, used MAX(LEN(XX)) command
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
	show_id VARCHAR(25), 
	type VARCHAR(10), 
	title VARCHAR(150), 
	director VARCHAR(208),
	casts VARCHAR(1000), 
	country VARCHAR(150),
	date_added VARCHAR(50), 
	release_year INT, 
	rating VARCHAR(10), 
	duration VARCHAR(15), 
	listed_in VARCHAR(150),
	description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT (*) as total_content
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;

-- 15 Business Problems

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT (*) as total_content
FROM netflix
GROUP BY type;


-- 2. Find the most common rating for movies and TV shows

SELECT
	type,
	rating
FROM
(
	SELECT
		type,
		rating,
		COUNT (*),
		RANK () OVER(PARTITION BY type ORDER BY COUNT (*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
) as t1
WHERE 
	ranking = 1;

--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
WHERE type = 'Movie'AND release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content 
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



-- STRING TO ARRAY separates the countries that are all in one line , if it lists multiple for one
-- it takes the country column and where theres a comma, its separated as a new country but still in one line
-- unnest separates them



-- 5. Identify the longest movie


SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;


-- 6. Find content added in the last 5 years

SELECT  
	*
FROM netflix
WHERE
	TO_DATE(date_added, 'Month, DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';




-- using like instead of = bc this = would not include movies that he was a part of, not just solely him so instead like is looking for wherever this name shows up
-- ilike allows for any lowercase letter to be recognised too bc like is case sensitive.


-- 8. List all TV shows with more than 5 seasons

SELECT 
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5; 
	
-- split part gives us the first part, hence 1, of what is said in duration so in this case it would be the number of seasons


-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1;

-- 10.Find each year and the average numbers of content release in the United Kingdom on netflix.

total_content 43/419

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month, DD, YYYY')) as year,
	COUNT(*),
	ROUND(
		COUNT(*)::numeric/
		(SELECT COUNT (*) FROM netflix WHERE country = 'United Kingdom')::numeric * 100
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'United Kingdom'
GROUP BY 1
ORDER BY year DESC;


-- 11. List all movies that are documentaries

SELECT * FROM netflix
WHERE 
	listed_in iLIKE '%Documentaries%';

-- 12. Find all content without a director

SELECT * FROM netflix
WHERE 
	director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in the United States.

SELECT  
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE 
	type = 'Movie'
	AND
	country ILIKE '%united states'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. 
--Count how many items fall into each category.

WITH new_table
AS
(
SELECT 
*, 
	CASE
	WHEN 
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad Content'
		ELSE 'Good Content'
	END category
FROM netflix
)

SELECT
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1;

