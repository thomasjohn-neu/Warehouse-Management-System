GO
CREATE PROCEDURE 
MakeCustomerOrder(@customerId INT, @productId INT, @quantity INT)
AS
BEGIN

    DECLARE @productExists INT;
    SELECT @productExists = COUNT(productId) FROM Product WHERE productId = @productId;
    IF @productExists > 0
        BEGIN
            DECLARE @stockExists INT;
            DECLARE @tax DECIMAL;
            DECLARE @discount DECIMAL;
            SET @tax = 5;
            SET @discount = 25; 
            DECLARE @stockItemId INT
            SELECT @stockItemId = itemId from StockItem;
            SELECT @stockExists = dbo.checkStock(@stockItemId);
            IF @stockExists > @quantity
                BEGIN
                    DECLARE @orderId INT
                    SELECT @orderId = MAX(orderId) FROM [Order]; --- last order id
                    SET @orderId = @orderId + 1
                    

                    INSERT INTO [Order](orderId, userId, orderType, discount, tax) VALUES (@orderId, @customerId, 'customer order', @discount, @tax);
                    INSERT INTO OrderItem(orderItemId, productId, orderId, quantity) VALUES (@stockItemId, @productId, @orderId, @quantity);
                    PRINT 'Successfully placed your order!'        
                END
            ELSE
                BEGIN
                    PRINT 'We are out of stock! Try again later!'
                END
        END
    ELSE
        BEGIN
            PRINT 'No such product exists'
        END
END


GO
CREATE PROCEDURE 
MakePurchaseOrder(@supplierID INT, @productId INT, @quantity INT)
AS
BEGIN

    DECLARE @productExists INT;
    SELECT @productExists = COUNT(productId) FROM Product WHERE productId = @productId;
    IF @productExists > 0
        BEGIN
            DECLARE @stockExists INT;
            DECLARE @tax DECIMAL;
            DECLARE @discount DECIMAL;
            SET @tax = 5;
            SET @discount = 25; 
            DECLARE @stockItemId INT
            SELECT @stockItemId = itemId from StockItem;
            SELECT @stockExists = dbo.checkStock(@stockItemId);
            
            DECLARE @orderId INT
            SELECT @orderId = MAX(orderId) FROM [Order]; --- last order id
            SET @orderId = @orderId + 1
            
            INSERT INTO [Order](orderId, supplierId, orderType, discount, tax) VALUES (@orderId, @supplierID, 'purchase order', @discount, @tax);
            INSERT INTO OrderItem(orderItemId, productId, orderId, quantity) VALUES (@stockItemId, @productId, @orderId, @quantity);
            PRINT 'Successfully placed your order!'        
        END
    ELSE
        BEGIN
            PRINT 'No such product exists'
        END
END