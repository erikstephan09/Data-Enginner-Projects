
SELECT * FROM customer_journey
ORDER BY JourneyID;

--- Saw Duplicate columns
WITH duplicate_columns AS (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY CustomerID, 
							ProductID, VisitDate, Stage, Action
							ORDER BY JourneyID) AS dc
		FROM customer_journey)
		SELECT * FROM duplicate_columns
		WHERE dc > 1;

--- AVG duration 
SELECT JourneyID, VisitDate, Duration,
	AVG(Duration) OVER (PARTITION BY VisitDate) AS 'AVG_Duration'
	FROM customer_journey;

/*Final SQL Table*/
WITH cjm AS (SELECT *,
	AVG(Duration) OVER (PARTITION BY VisitDate) AS 'AVG_Duration',
	ROW_NUMBER() OVER (PARTITION BY CustomerID, 
							ProductID, VisitDate, Stage, Action
							ORDER BY JourneyID) AS dc
	FROM customer_journey
	)
	SELECT JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		LOWER(Stage) AS 'Stage',
		LOWER(Action) AS 'Action',
		COALESCE(Duration, AVG_Duration) AS 'Duration'
		FROM cjm
		WHERE dc = 1
		ORDER BY JourneyID;

 /*Conversion Rate KPI*/
-- Percentage of website visitors who make a purchase
WITH cjm AS (SELECT *,
	AVG(Duration) OVER (PARTITION BY VisitDate) AS 'AVG_Duration',
	ROW_NUMBER() OVER (PARTITION BY CustomerID
							ORDER BY JourneyID) AS dc
	FROM customer_journey
	) 
	SELECT
	(
	((SELECT COUNT(JourneyID) FROM cjm WHERE Action = 'Purchase' AND dc = 1) * 100)/ COUNT(DISTINCT JourneyID)) AS '%Purchase'
	From cjm
		WHERE dc = 1;
