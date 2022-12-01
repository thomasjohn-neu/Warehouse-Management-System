CREATE TRIGGER computePerOrderItemTotal
ON dbo.[OrderItem]
AFTER INSERT, UPDATE
AS
BEGIN

    DECLARE @Price DECIMAL;
    DECLARE @discount DECIMAL;
	
    DECLARE @orderItemId INT;
    DECLARE @productId INT;
    DECLARE @orderId INT;
    DECLARE @quantity INT;

    DECLARE cur CURSOR FOR
        Select orderItemId, productId, orderId, quantity FROM inserted;
    OPEN cur
    FETCH NEXT FROM cur INTO @orderItemId, @productId, @orderId, @quantity
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @Price=dbo.computeOrderItemPrice(@productId, @quantity);
        UPDATE [OrderItem] SET price = @Price 
        WHERE orderId = @orderID AND orderItemId=@orderItemId AND productId=@productId;
    FETCH NEXT FROM cur INTO @orderItemId, @productId, @orderId, @quantity
END
CLOSE cur
DEALLOCATE cur
END
