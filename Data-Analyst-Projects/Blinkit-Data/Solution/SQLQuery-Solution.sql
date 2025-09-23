/*Cleaning Data*/
UPDATE [BlinkIT-Table]
	SET Item_Fat_Content =
	CASE
		WHEN Item_Fat_Content = 'LF' THEN 'Low Fat'
		WHEN Item_Fat_Content = 'reg' THEN 'Regular'
		ELSE Item_Fat_Content
	END;

SELECT DISTINCT Item_Fat_Content FROM [BlinkIT-Table];
/*KPI's Requirements*/

SELECT * FROM [BlinkIT-Table];

--Total Sales
SELECT SUM(Total_Sales) AS 'Total Sales'
	FROM [BlinkIT-Table];

--Average Sales
SELECT AVG(Total_Sales) AS 'AVG Sales'
	FROM [BlinkIT-Table];

--Number of Items: Total count of different items sold
SELECT Item_Type, COUNT(Item_Type) AS 'Items Count'
	FROM [BlinkIT-Table]
	GROUP BY Item_Type
	ORDER BY 'Items Count' DESC;

SELECT COUNT(Item_Type) AS 'Num of Items'
	FROM [BlinkIT-Table];

--Average Rating
SELECT AVG(Rating) AS 'AVG rating'
	FROM [BlinkIT-Table];

/*Granular Requirements*/
--Total Sales by Fat Content
SELECT Item_Fat_Content, SUM(Total_Sales) AS 'Total Sales'
	FROM [BlinkIT-Table]
	GROUP BY Item_Fat_Content;

--Total Sales by Item Type
SELECT Item_Type, SUM(Total_Sales) 'Total Sales' 
	FROM [BlinkIT-Table]
	GROUP BY Item_Type
	ORDER BY 'Total Sales' DESC;

--Fat Content by Outlet for Total Sales ------------------------------------------- Learn 
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM [BlinkIT-Table]
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, SUM(Total_Sales) AS 'Total Sales'
	FROM [BlinkIT-Table]
	GROUP BY Outlet_Establishment_Year
	ORDER BY Outlet_Establishment_Year;

/*Chart's Requirements*/
--Percentage of Sales by Outlet Size
SELECT Outlet_Size, ((SUM(Total_Sales) * 100.0) / 
					(SELECT SUM(Total_Sales) FROM [BlinkIT-Table])
					) AS 'percentage'  
	FROM [BlinkIT-Table]
	GROUP BY Outlet_Size;

--Sales by Outlet Location
SELECT Outlet_Location_Type, SUM(Total_Sales) AS 'Total Sales'
	FROM [BlinkIT-Table]
	GROUP BY Outlet_Location_Type;

--All Metrics by Outlet Type
SELECT Outlet_Type, SUM(Total_Sales) AS 'Total Sales',
					AVG(Total_Sales) AS 'AVG Sales',
					COUNT(Item_Type) AS 'Num of Items',
					AVG(Rating) AS 'AVG Rating'
	FROM [BlinkIT-Table]
	GROUP BY Outlet_Type;