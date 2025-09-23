SELECT * FROM pizza_sales;
/*KPI's Requirements*/

-- Total Revenue
SELECT SUM(pizza_sales.total_price) AS 'Total-Revenue' FROM pizza_sales;
-- Avg Order Value
SELECT SUM(pizza_sales.total_price) / ((COUNT(DISTINCT pizza_sales.order_id)) * 1.0) AS 'AVG-Orders'
	FROM pizza_sales;
-- Total Pizzas Sold
SELECT SUM(pizza_sales.quantity) AS 'Total-Pizzas-Sold' FROM pizza_sales;
-- Total Orders
SELECT COUNT(DISTINCT pizza_sales.order_id) AS 'Total-Orders' FROM pizza_sales;
-- Avg Pizzas Per Order
SELECT CAST((SUM(pizza_sales.quantity) * 1.0)  / (COUNT(DISTINCT pizza_sales.order_id) * 1.0)
	AS DECIMAL(10, 2)) AS 'AVG-Pizza-Per-Order' 
	FROM pizza_sales;


/*Daily Trend for Total Orders*/
SELECT DATENAME(DW, pizza_sales.order_date) AS 'Order_Day',
	COUNT(DISTINCT (pizza_sales.order_id)) AS 'Total-Orders' 
	FROM pizza_sales
	--WHERE DAY(pizza_sales.order_date) = 9
	GROUP BY DATENAME(DW, pizza_sales.order_date);


/*Monthly Trend ford Orders*/
SELECT DISTINCT DATENAME(MONTH, pizza_sales.order_date) AS 'Order_Month',
	COUNT(pizza_sales.order_id) AS 'Total-Orders'
	FROM pizza_sales
	--WHERE DATEPART(DAY, pizza_sales.order_date) = 8
	GROUP BY DATENAME(MONTH, pizza_sales.order_date);

/*% of Sales by Pizza Category*/

SELECT DISTINCT (pizza_sales.pizza_category) AS 'Pizza_Category',
	COUNT(pizza_sales.total_price) AS 'Sales-Per-Category',
	(SUM(pizza_sales.total_price) *100) / 
		(SELECT SUM(pizza_sales.total_price) FROM pizza_sales) AS '%Sales'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_category
	ORDER BY 'Sales-Per-Category';

/*% of Sales By pizza Size*/

SELECT DISTINCT (pizza_sales.pizza_size) AS 'Pizza-Size',
	COUNT(pizza_sales.total_price) AS 'Sales-Per-Size',
	((SUM(pizza_sales.total_price) * 100) /
		(SELECT SUM(pizza_sales.total_price) FROM pizza_sales))
		AS '%Sales'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_size
	ORDER BY 'Sales-Per-Size';


/*Total Pizzas Sold by Pizza Category*/

SELECT DISTINCT(pizza_sales.pizza_category) AS 'Pizza-Category',
	SUM(pizza_sales.quantity) AS 'Total-Pizza-Sold' 
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_category
	ORDER BY 'Total-Pizza-Sold' DESC;

/*Top 5 Sellers by Revenue, Total quantity and Total Orders*/

SELECT TOP 5 pizza_sales.pizza_name,
	SUM(pizza_sales.total_price) AS 'Total-Orders'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_name
	ORDER BY 'Total-Orders'DESC;

/*Bottom 5 Pizzas by Revenue*/
SELECT TOP 5 pizza_sales.pizza_name,
	SUM(pizza_sales.total_price) AS 'Total-Orders'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_name
	ORDER BY 'Total-Orders';

/*Top 5 Pizzas by Quantity*/
SELECT TOP 5 pizza_sales.pizza_name,
	SUM(pizza_sales.quantity) AS 'Total-Quantity'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_name
	ORDER BY 'Total-Quantity' DESC;

/*Bottom 5 Pizzas by Quantity*/
SELECT TOP 5 pizza_sales.pizza_name,
	SUM(pizza_sales.quantity) AS 'Total-Quantity'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_name
	ORDER BY 'Total-Quantity';
/*Top 5 Pizzas by Total Orders*/

SELECT TOP 5 pizza_sales.pizza_name,
	COUNT(pizza_sales.order_id) AS 'Total-Order'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_name
	ORDER BY 'Total-Order' DESC;

/*Bottom 5 Pizzas by Total Orders*/
SELECT TOP 5 pizza_sales.pizza_name,
	COUNT(pizza_sales.order_id) AS 'Total-Order'
	FROM pizza_sales
	GROUP BY pizza_sales.pizza_name
	ORDER BY 'Total-Order';
