CREATE FUNCTION checkStock
(@stockItemId int) 
RETURNS INT 
AS
   BEGIN 
      DECLARE @stockQty INT; 
      SELECT @stockQty = quantity
         FROM StockItem 
         WHERE itemId = @stockItemId;
    RETURN @stockQty; 
    END; 