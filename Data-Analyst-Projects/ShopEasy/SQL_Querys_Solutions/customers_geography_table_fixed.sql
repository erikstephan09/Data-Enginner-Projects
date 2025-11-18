SELECT * FROM customers;

-- Duplicate columns (No duplicate columns)

WITH dcc AS (
	SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY CustomerID, CustomerName, Email, GeographyID ORDER BY CustomerID) AS 'DC'
	FROM customers
	)
	SELECT * FROM dcc
	WHERE DC = 2;

--- Combine Customers table with Geography table 
SELECT c.CustomerID,
	c.CustomerName,
	c.Email,
	c.Gender,
	c.Age,
	c.GeographyID,
	g.Country,
	g.City
	FROM customers AS c
	LEFT JOIN geography AS g
	ON c.GeographyID= g.GeographyID;