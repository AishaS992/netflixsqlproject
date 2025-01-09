# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/AishaS992/netflixsqlproject/blob/main/BrandAssets_Logos_01-Wordmark.jpg)


## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyse the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyse content based on release years, countries, and durations.
- Explore and categorise content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type,
	COUNT (*) as total_content
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
SELECT * FROM netflix
WHERE type = 'Movie'AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content 
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in the United Kingdom on Netflix. 


```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * FROM netflix
WHERE 
	listed_in iLIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE
	casts LIKE '%Salman Khan%'
  	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in the United States.

```sql
SELECT  
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE 
	type = 'Movie'
	AND
	country iLIKE '%united states'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in American-produced movies.

### 15. Categorise Content Based on the Presence of 'Kill' and 'Violence' Keywords in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.


```sql
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
```

**Objective:** Categorise content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The analysis revealed a diverse range of movies and TV shows on Netflix, offering insights into the variety of genres and ratings available. This was a valuable exercise in exploring how content is distributed across different formats. 
- **Common Ratings:** By identifying the most common ratings, I gained a deeper understanding of how Netflix tailors its content to appeal to specific audiences, reflecting patterns in viewer preferences.
- **Geographical Insights:** Analysing content releases by country, specifically the United Kingdom and the United States, allowed me to understand how regional content is prioritised and distributed, highlighting the platform's global and local strategies.
- **Content Categorisation:** Creating categories based on keywords in content descriptions enhanced my ability to classify and analyse data effectively, helping me understand how content themes are represented on the platform.

This analysis offers a thorough overview of Netflix's content, providing valuable insights to guide content strategy and inform decision-making processes
