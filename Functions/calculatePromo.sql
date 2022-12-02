CREATE FUNCTION calculatePromo(@orderId INT)
RETURNS DECIMAL
AS
   BEGIN

   DECLARE @Total as DECIMAL
   DECLARE @Promo as DECIMAL

   SELECT @Total = total FROM [order] 
   WHERE orderId = @orderId

   IF @Total BETWEEN 1 AND 50
		SET @Promo = 0
   ELSE IF @Total BETWEEN 50 AND 99
		SET @Promo = 5.0
   ELSE IF @Total BETWEEN 100 AND 250 
		SET @PROMO = 8.0
   ELSE IF @Total BETWEEN 250 AND 500 
		SET @PROMO = 10.0
   ELSE
        SET @Promo=15.0
   RETURN @Promo
   END
GO  
