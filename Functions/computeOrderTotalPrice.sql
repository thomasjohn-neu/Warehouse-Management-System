USE WareHouseManagementSystem;

CREATE FUNCTION computeOrderTotalPrice
(@orderId int) 
RETURNS DECIMAL 
AS
   BEGIN 
      DECLARE @price DECIMAL; 
      DECLARE @total DECIMAL;
      DECLARE @discount DECIMAL;
      SELECT @total = sum(price)
         FROM OrderItem 
         WHERE orderId = @orderId;
    RETURN @total; 
   END; 