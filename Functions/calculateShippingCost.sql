CREATE FUNCTION calculateShippingCost(@orderId INT)
RETURNS DECIMAL
AS
   BEGIN

   DECLARE @Price as DECIMAL
   DECLARE @shippingCost as DECIMAL

   SELECT @Price = Price FROM [order] 
   WHERE orderId = @orderId

   IF @Price BETWEEN 1 AND 50
		SET @shippingCost = 2.0
   ELSE IF @shippingCost BETWEEN 50 AND 99
		SET @shippingCost = 1.5
   ELSE 
		SET @shippingCost = 0
   RETURN @shippingCost
   END
GO   