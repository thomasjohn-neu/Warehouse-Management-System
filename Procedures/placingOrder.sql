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
            SELECT @stockExists = dbo.checkStock(1);
            IF @stockExists > @quantity
                BEGIN
                    DECLARE @orderId INT
                    SELECT @orderId = MAX(orderId) FROM [Order]; --- last order id
                    SET @orderId = @orderId + 1
                    INSERT INTO [Order](orderId, userId, orderType, discount, tax) VALUES (@orderId, @customerId, 'customer order', @discount, @tax);
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


-- EXEC MakeCustomerOrder 1, 1, 1
-- DROP PROCEDURE MakeCustomerOrder;