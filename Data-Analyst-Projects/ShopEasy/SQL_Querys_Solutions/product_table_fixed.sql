SELECT * FROM products;

-- ADD PriceCategory Column
SELECT 
     *,
    CASE -- Categorizes the products into price categories: Low, Medium, or High
        WHEN Price < 50 THEN 'Low'  
        WHEN Price BETWEEN 50 AND 200 THEN 'Medium'  
        ELSE 'High'  
    END AS PriceCategory 

FROM 
    products;  