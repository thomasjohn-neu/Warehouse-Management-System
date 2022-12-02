CREATE FUNCTION getOrderType(@orderId INT)
-- return 1 for customer order and 0 for purchase order
RETURNS INT
AS
   BEGIN
   DECLARE @orderType as VARCHAR(20)
   DECLARE @result as INT
   SELECT @orderType = orderType FROM [order] 
   WHERE orderId = @orderId
    IF (@orderType = 'customer order')
        SET @result = 1
    ELSE
        SET @result = 0
    RETURN @result
   END
GO  
