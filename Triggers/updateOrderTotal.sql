
CREATE TRIGGER updateOrderTotal
ON dbo.[OrderItem]
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE (quantity) 
    BEGIN
        DECLARE @orderID INT;
        DECLARE @stockItemId INT;
        DECLARE @stockQty INT;
        DECLARE @orderOty INT;
        DECLARE @orderTotal DECIMAL;
        DECLARE @orderType INT;

        SELECT 
        @orderID = orderId, @stockItemId = orderItemId, @orderOty=quantity
        FROM inserted;
                SELECT @orderTotal = dbo.computeOrderTotalPrice(@orderID);
                UPDATE [Order] SET total = @orderTotal WHERE orderId = @orderID;
                SELECT @orderType = dbo.getOrderType(@orderID);
                IF @orderType =1
                    SELECT @stockQty = dbo.checkStock(@stockItemId)@orderOty;
                ELSE
                    SELECT @stockQty = dbo.checkStock(@stockItemId)+@orderOty;
                UPDATE StockItem SET quantity=@stockQty,
                availability = CASE WHEN @stockQty <= 0 THEN 'n' ELSE 'y' END
                WHERE itemId=@stockItemId;
    END
END
