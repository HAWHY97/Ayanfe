--------------------------------------------------------------------------------------------------------
-- Project 1 -- Provide insights and data to help a marketing team implement a Customer Loyalty program.
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- Question 1 -- Provide the top 10 customers (full name) by revenue, the country they shipped to, the cities and 
-- their revenue (orderqty * unitprice).
-- This insight will help you understand where your top spending customers are coming from. You can 
-- market better, get more capable customer service rep, have more stock and build partnerships in these
-- countries and cities.

SELECT TOP 10
    CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS FullName,
    a.CountryRegion AS Country, 
	a.City AS City,
    SUM(sod.OrderQty * sod.UnitPrice) AS Revenue
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN SalesLT.CustomerAddress ca ON c.CustomerID = ca.CustomerID
JOIN SalesLT.[Address] a ON ca.AddressID = a.AddressID
JOIN SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY c.CustomerID, c.FirstName, c.MiddleName, c.LastName, a.CountryRegion, a.City
ORDER BY Revenue DESC


--------------------------------------------------------------------------------------------------------
-- Question 2 -- Create 4 distinct Customer segments using the total Revenue (orderqty * unitprice) by customer. 
-- List the customer details (ID, Company Name), Revenue and the segment the customer belongs to. 
-- This analysis can use to create a loyalty program, mmarket customers with discount or leave customers as-is.

SELECT c.CustomerID, c.CompanyName, SUM(sod.OrderQty * sod.UnitPrice) AS 'Total Revenue',
    CASE 
        WHEN SUM(sod.OrderQty * sod.UnitPrice) >= 50000 THEN 'High Patronage'
        WHEN SUM(sod.OrderQty * sod.UnitPrice) >= 25000 THEN 'Medium Patronage'
        WHEN SUM(sod.OrderQty * sod.UnitPrice) >= 10000 THEN 'Low Patronage'
        WHEN SUM(sod.OrderQty * sod.UnitPrice) < 5000 THEN 'Very Low Patronage'
		ELSE 'Very Low Revenue'
    END AS CustomerSegment
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY 'Total Revenue' DESC;


--------------------------------------------------------------------------------------------------------
-- Question 3 -- What products with their respective categories did our customers buy on our last day of business?
-- List the CustomerID, Product ID, Product Name, Category Name and Order Date.
-- This insight will help understand the latest products and categories that your customers bought from. This will help
-- you do near-real-time marketing and stockpiling for these products.

SELECT soh.CustomerID, sod.ProductID, p.Name AS ProductName, pc.Name AS CategoryName, soh.OrderDate
FROM SalesLT.SalesOrderHeader soh
JOIN SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN SalesLT.Product p ON sod.ProductID = p.ProductID
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
WHERE soh.OrderDate = (SELECT MAX (OrderDate) FROM SalesLT.SalesOrderHeader)

----------------------------------------------------------------------------------------------------------------
-- Question 4 -- Create a View called customersegment that stores the details (id, name, revenue) for customers
-- and their segment? i.e. build a view for Question 2.
-- You can connect this view to Tableau and get insights without needing to write the same query every time.

Create VIEW customersegment AS
SELECT c.CustomerID, c.CompanyName, SUM(sod.OrderQty * sod.UnitPrice) AS 'Total Revenue',
    CASE 
        WHEN SUM(sod.OrderQty * sod.UnitPrice) >= 50000 THEN 'High Patronage'
        WHEN SUM(sod.OrderQty * sod.UnitPrice) >= 25000 THEN 'Medium Patronage'
        WHEN SUM(sod.OrderQty * sod.UnitPrice) >= 10000 THEN 'Low Patronage'
        WHEN SUM(sod.OrderQty * sod.UnitPrice) < 5000 THEN 'Very Low Patronage'
		ELSE 'Very Low Revenue' END AS CustomerSegment
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY c.CustomerID, c.CompanyName
SELECT * from customersegment

-----------------------------------------------------------------------------------------------------------------
-- Question 5 -- What are the top 3 selling product (include productname) in each category (include categoryname)
-- by revenue? Tip: Use ranknum
-- This analysis will ensure you can keep track of your top selling products in each category. The output is very
-- powerful because you don't have to write multiple queries to be able to see your top selling products in each category.
-- This analysis will inform your marketing, your supply chain, your partnerships, position of products on your website, etc.
-- NB: This question is asked a lot in interviews!


select P.ProductID, P.Name as ProductName, PC.Name AS ProductCategory,  SUM(sod.orderqty * sod.unitprice) As revenue ,
  RANK() OVER (PARTITION BY PC.Name ORDER BY SUM(sod.orderqty * sod.unitprice) DESC) AS RankNum
from SalesLT.Product P 
join  SalesLT.SalesOrderDetail sod on sod.ProductID = P.ProductID
join SalesLT.ProductCategory PC on PC.ProductCategoryID = P.ProductCategoryID 
Group by  P.ProductID, P.Name ,PC.Name 
Order by revenue ,RankNum


WITH cte AS (
    SELECT c.category_name, p.product_name, SUM(p.revenue) AS total_revenue,
           ROW_NUMBER() OVER (PARTITION BY c.category_name ORDER BY SUM(p.revenue) DESC) AS rn
    FROM Categories c
    INNER JOIN Products p ON c.category_id = p.category_id
    GROUP BY c.category_name, p.product_name
)
SELECT category_name, product_name, total_revenue
FROM cte
WHERE rn <= 3
ORDER BY category_name, total_revenue DESC

-----------------------------------------------------------------------------------------------------------------