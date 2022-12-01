USE WareHouseManagementSystem;

CREATE FUNCTION computeOrderItemPrice 
(@productId int, @qty int) 
RETURNS DECIMAL 
AS 
   BEGIN 
      DECLARE @price DECIMAL; 
      DECLARE @discount DECIMAL;
      SELECT @price = price , @discount = discount
         FROM StockItem 
         WHERE productId = @productId; 
      RETURN @price * @qty - ((@price * @qty * @discount)/100); 
   END; 
