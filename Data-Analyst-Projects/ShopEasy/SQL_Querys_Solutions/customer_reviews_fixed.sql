SELECT * FROM customer_reviews;

-- Duplicate Columns (No duplicate columns)
WITH dcr AS (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY ReviewID, CustomerID, ProductID ORDER BY ReviewID) AS 'DC'
		FROM customer_reviews
		)
		SELECT * FROM dcr
		WHERE DC = 2;

-- Space between letters
SELECT ReviewID, 
	CustomerID, 
	ProductID,
	ReviewDate,
	Rating,
	REPLACE(ReviewText, '  ', ' ') AS 'ReviewText'
	FROM customer_reviews;