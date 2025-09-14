Use AdventureWorks2016
SELECT TOP 10 * FROM AW_Customers
SELECT TOP 10 * FROM AW_Products
SELECT TOP 10 * FROM AW_Product_Subcategories
SELECT TOP 10 * FROM AW_Product_Categories
SELECT * FROM AW_Sales2016

----------------------------------------------------------------------
----- Total purchase value by product -----
SELECT cate.CategoryName,
		subcate.SubcategoryName,
		pro.ProductName,
		SUM(sale.OrderQuantity) AS OrderQuantity,
		pro.ProductPrice,
		SUM(sale.OrderQuantity)*pro.ProductPrice AS PurchaseValue
FROM AW_Products pro
JOIN AW_Product_Subcategories subcate ON pro.ProductSubcategoryKey = subcate.ProductSubcategoryKey
JOIN AW_Product_Categories cate ON subcate.ProductCategoryKey = cate.ProductCategoryKey
JOIN AW_Sales2016 sale ON sale.ProductKey = pro.ProductKey
GROUP BY cate.CategoryName,
		subcate.SubcategoryName,
		pro.ProductName, 
		pro.ProductPrice
ORDER BY PurchaseValue DESC

----- Other products purchased by customers who purchased product “Mountain Bikes” ----- 
WITH cross_selling AS
(SELECT sale.OrderNumber,
		cate.CategoryName,
		subcate.SubcategoryName,
		pro.ProductName
FROM AW_Sales2016 sale
JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
JOIN AW_Product_Subcategories subcate ON pro.ProductSubcategoryKey = subcate.ProductSubcategoryKey
JOIN AW_Product_Categories cate ON subcate.ProductCategoryKey = cate.ProductCategoryKey
WHERE sale.OrderNumber IN (
		SELECT sale.OrderNumber
		FROM AW_Sales2016 sale
		JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
		JOIN AW_Product_Subcategories subcate ON pro.ProductSubcategoryKey = subcate.ProductSubcategoryKey
		JOIN AW_Product_Categories cate ON subcate.ProductCategoryKey = cate.ProductCategoryKey
		WHERE subcate.SubcategoryName = 'Mountain Bikes')
		)
SELECT SubcategoryName, 
		COUNT(*) AS Quanity
FROM cross_selling
GROUP BY SubcategoryName
ORDER BY Quanity DESC

----- (Price Effect) Does the cheapest one sell more? -----
SELECT pro.ProductPrice,
	SUM(sale.OrderQuantity) AS TotalQuantity
FROM AW_Products pro 
JOIN AW_Sales2016 sale ON pro.ProductKey = sale.ProductKey
GROUP BY pro.ProductPrice
ORDER BY pro.ProductPrice

----- Customer Lifetime Value (CLV) -----
SELECT cus.CustomerKey AS CustomerKey,
		cus.FirstName + ' ' + cus.LastName AS FullName,
		SUM(pro.ProductPrice * sale.OrderQuantity) AS PurchaseValue
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
GROUP BY cus.CustomerKey, 
		cus.FirstName + ' ' + cus.LastName
ORDER BY PurchaseValue DESC

----- Segment customers by spending size (VIP, Medium, Low Value) -----
WITH segment AS (
SELECT  cus.CustomerKey AS CustomerKey,
		cus.FirstName + ' ' + cus.LastName AS FullName,
		SUM(pro.ProductPrice * sale.OrderQuantity) AS PurchaseValue
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
GROUP BY cus.CustomerKey, 
		cus.FirstName + ' ' + cus.LastName
)
SELECT DISTINCT CustomerKey,
				FullName,
				CASE WHEN PurchaseValue < 500 THEN 'Low Value'
					WHEN PurchaseValue > = 500 AND PurchaseValue < 1000 THEN 'Medium'
				ELSE 'VIP'
				END AS Segment
FROM segment

----- Total purchase value by month -----
SELECT MONTH(OrderDate) AS Month,
		SUM(OrderQuantity) AS Total_purchase
FROM AW_Sales2016
GROUP BY MONTH(OrderDate)
ORDER BY MONTH(OrderDate)

----- (Repeat Customers) Percentage of Customers who purchased more than once -----
WITH purchase_count AS (
	SELECT CustomerKey,
		COUNT(DISTINCT OrderNumber) AS PurchaseCount
FROM AW_Sales2016
GROUP BY CustomerKey
)
SELECT (COUNT(CASE WHEN PurchaseCount > 1 THEN CustomerKey END) * 100) / COUNT(CustomerKey) AS Repeat_Customer_Rate
FROM purchase_count

----- Average number of orders per customer by month (Frequence of repeat customers) -----
SELECT MONTH(OrderDate) AS Month,
		SUM(sale.OrderQuantity)/COUNT(DISTINCT sale.CustomerKey) AS Avg_Purchases
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
GROUP BY MONTH(OrderDate)
ORDER BY Month

----- Average amount of money per order by month -----
SELECT MONTH(OrderDate) AS Month,
		SUM(sale.OrderQuantity*pro.ProductPrice)/COUNT(DISTINCT sale.OrderNumber) AS Avg_Amount
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
JOIN AW_Products pro ON pro.ProductKey = sale.ProductKey
GROUP BY MONTH(OrderDate)
ORDER BY Month
