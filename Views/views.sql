-- View to display top 5 products sold in the last ten days
CREATE VIEW TopFive AS
    SELECT 
        TOP(5) oi.orderItemId as 'Order Item ID', 
        p.title as 'Product Title',
        SUM(oi.quantity) AS 'Total Quantity Ordered'
    FROM orderItem oi 
    JOIN [order] o 
        ON oi.orderId = o.orderId
    JOIN Product p
        ON oi.productId = p.productId
    WHERE oi.createdAt>=DATEADD(DAY,-10,GETDATE())
    GROUP BY oi.orderItemId, p.title
    ORDER BY SUM(Quantity) DESC


/*select * from TopFive*/

-- View to display the brand report 

CREATE VIEW BrandReport AS
    SELECT 
        b.brandId as 'Brand ID',
        b.title as 'Brand Name', 
        SUM(oi.quantity) AS 'Sold Quantity'
    FROM Brand b 
    INNER JOIN 
        StockItem si ON b.brandId = si.brandID
    INNER JOIN 
        orderItem oi ON oi.orderItemId = si.itemId
    GROUP BY b.brandId,b.title;

/*select * from BrandReport*/

-- View to see what products need to be restocked based on the threshold quantity
CCREATE VIEW ReStock AS
    SELECT 
        p.productId as 'Product ID', 
        p.title as 'Product Name', 
        SUM(si.quantity) as 'Available Quantity' 
    FROM StockItem si 
    INNER JOIN 
        Product p ON si.productId = p.productId
    GROUP BY p.productId,p.title
    HAVING SUM(si.quantity)<200000;

/*select * from Restock*/