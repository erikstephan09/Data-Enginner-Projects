
SELECT * FROM Amazon_Combined_Data;

/*KPI Requirements*/

--Year To Date Sales

SELECT
    YEAR(Order_Date) AS SaleYear,
    MONTH(Order_Date) AS SaleMonth,
    SUM(Price) AS MonthlySales,
    SUM(SUM(Price)) OVER (
        PARTITION BY YEAR(Order_Date)
        ORDER BY MONTH(Order_Date)
        ROWS UNBOUNDED PRECEDING
    ) AS YTD_Sales
FROM Amazon_Combined_Data
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    SaleYear,
    SaleMonth;

-- QTD Sales 

SELECT YEAR(Order_Date) AS 'Year', 
	DATEPART(QUARTER, Order_Date) as 'Quarter',
	SUM(Price) AS 'Quarterly_Sales'
	FROM Amazon_Combined_Data
	GROUP BY YEAR(Order_Date), DATEPART(QUARTER, Order_Date)
	ORDER BY YEAR(Order_Date), DATEPART(QUARTER, Order_Date);

-- YTD Products Sold
SELECT DATEPART(YEAR, Order_Date) AS 'Year',
	COUNT(*) AS 'Products_Sold'
	FROM Amazon_Combined_Data
	GROUP BY DATEPART(YEAR, Order_Date)
	ORDER BY 'Year';

-- YTD Reviews: 

SELECT Product_Category,
       SUM(Number_of_reviews) AS 'YTD_Reviews'
FROM Amazon_Combined_Data
WHERE YEAR(Order_Date) = 2021
GROUP BY Product_Category
ORDER BY 'YTD_Reviews' DESC;


/*Charts Requirement*/

-- YTD Sales by Month 

SELECT YEAR(Order_Date) AS 'Year',
	MONTH(Order_Date) AS 'Month',
	Product_Category,
	SUM(Price) AS 'Sales_Trends'
	FROM Amazon_Combined_Data
	GROUP BY YEAR(Order_Date), MONTH(Order_Date), Product_Category 
	ORDER BY YEAR(Order_Date), MONTH(Order_Date), SUM(Price);

-- YTD Sales by Week

SELECT YEAR(Order_Date) AS 'Year',
	DATEPART(WEEK, Order_Date) AS 'Week',
	Product_Category,
	SUM(Price) AS 'Sales_Trends'
	FROM Amazon_Combined_Data
	GROUP BY YEAR(Order_Date), DATEPART(WEEK, Order_Date), Product_Category 
	ORDER BY YEAR(Order_Date), DATEPART(WEEK, Order_Date), SUM(Price);


-- Sales by Product Category

SELECT Product_Category,
	SUM(Price) AS 'Sales'
	FROM Amazon_Combined_Data
	GROUP BY Product_Category
	ORDER BY 'Sales';

-- Top 5 products by YTD Sales

SELECT TOP 5
    Product_Description,
    SUM(Price) AS YTD_Sales
	FROM Amazon_Combined_Data
	WHERE YEAR(Order_Date) = 2019
	GROUP BY Product_Description
	ORDER BY SUM(Price) DESC;

-- Top 5 Porducts by YTD Reviews
SELECT TOP 5
    Product_Description,
    SUM(Number_of_reviews) AS YTD_Reviews
FROM Amazon_Combined_Data
WHERE YEAR(Order_Date) = 2019
GROUP BY Product_Description
ORDER BY SUM(Number_of_reviews) DESC;

