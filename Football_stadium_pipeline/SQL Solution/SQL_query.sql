
CREATE TABLE IF NOT EXISTS wiki_football_db (
			rank INTEGER,
			stadium VARCHAR(100),
			capacity INTEGER,
			region VARCHAR(50),
			country VARCHAR(50),
			city VARCHAR(100),
			home_teams VARCHAR(1000)
)

SELECT * FROM wiki_football_db;

--What is the top 5 stadiums
SELECT 
	rank, stadium, region, country, city 
	FROM wiki_football_db
	ORDER BY rank
	LIMIT 5;
--What is the average capacity of the stadium by region?
 SELECT 
 		AVG(capacity) AS avg_capacity,
		region
		FROM wiki_football_db
		GROUP BY region
		ORDER BY avg_capacity DESC
--Count the number of stadiums in each country
SELECT country, COUNT(country) as num_stadiums
		FROM wiki_football_db
		GROUP BY country
		ORDER BY num_stadiums DESC;
--What is the stadium ranking in each region by them capacity

SELECT rank, stadium, region,
		RANK() OVER(PARTITION BY region ORDER BY capacity DESC) as region_rank
		FROM wiki_football_db;

--Top 3 stadiums ranking in each region
with stadiums_ranking AS (
	SELECT rank,
			stadium,
			region,
			RANK() OVER(PARTITION BY region ORDER BY capacity DESC) as ranking
	FROM wiki_football_db
)
	SELECT * from stadiums_ranking
	WHERE ranking <= 3;

--Stadium with capacity above the average
WITH avg_capacity AS (
	SELECT stadium, region,
	capacity, 
	AVG(capacity) OVER (PARTITION BY region) AS avg_capacity
	FROM wiki_football_db
)
	SELECT * FROM avg_capacity
	WHERE capacity >= avg_capacity
	ORDER BY region;

--Stadium with close capacity to regional median
