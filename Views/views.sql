-- View to display top 5 products sold in the last ten days
create view TopFive AS
SELECT TOP(5) oi.orderItemId, SUM(oi.quantity) AS TotalQuantity
FROM orderItem oi Inner JOIN [order] o ON oi.orderId = o.orderId
WHERE oi.createdAt>=DATEADD(DAY,-10,GETDATE())
GROUP BY oi.orderItemId
ORDER BY SUM(Quantity) DESC
/*select * from TopFive*/

-- View to display the brand report 
create view BrandReport as
select b.brandId, b.title, SUM(oi.quantity) AS qtySold 
FROM brand b INNER JOIN StockItem si ON b.brandId = si.brandID
INNER JOIN orderItem oi ON oi.orderItemId = si.itemId
GROUP BY b.brandId,b.title
/*select * from BrandReport*/

-- View to see what products need to be restocked
CREATE VIEW Restock as
select p.productId, p.title, sum(si.quantity) as qty 
from StockItem si INNER JOIN Product p ON si.productId = p.productId
GROUP BY p.productId,p.title
having sum(si.quantity)<12000;

/*select * from Restock*/