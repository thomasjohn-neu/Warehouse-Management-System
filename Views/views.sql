-- View to display top 5 products sold in the last ten days

/*DROP VIEW TopFive*/

create view TopFive AS
SELECT TOP(5) oi.orderItemId, SUM(oi.quantity) 
AS TotalQuantity
FROM orderItem oi 
Inner JOIN [order] o 
ON oi.orderId = o.orderId
WHERE oi.createdAt>=DATEADD(DAY,-10,GETDATE())
GROUP BY oi.orderItemId
ORDER BY SUM(Quantity) DESC

/*SELECT * from TopFive*/

-- View to display the brand report 

/*DROP VIEW BrandReport*/

CREATE view BrandReport AS
SELECT b.brandId, b.title, SUM(oi.quantity) 
AS qtySold 
FROM brand b 
INNER JOIN StockItem si
ON b.brandId = si.brandID
INNER JOIN orderItem oi 
ON oi.orderItemId = si.itemId
GROUP BY b.brandId,b.title

/*SELECT * from BrandReport*/

-- View to see what products need to be restocked

/*DROP VIEW Restock*/

CREATE VIEW Restock AS
SELECT p.productId, p.title, sum(si.quantity) 
AS qty 
FROM StockItem si 
INNER JOIN Product p 
ON si.productId = p.productId
GROUP BY p.productId,p.title
HAVING sum(si.quantity)<12000;

/*SELECT * from Restock*/


