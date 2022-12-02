CREATE TRIGGER CostOrder
ON dbo.[Order]
AFTER INSERT, UPDATE
AS
BEGIN

    DECLARE @Price DECIMAL;
    DECLARE @discount DECIMAL;
    DECLARE @tax DECIMAL;
    DECLARE @shippingCost DECIMAL;
	DECLARE @total DECIMAL;
    DECLARE @promo DECIMAL;
	DECLARE @grandTotal DECIMAL
	
	DECLARE @orderID INT;

    Select 
	@orderID = orderId,
	@Price = price,
	@tax = tax,
	@total = total,
    @discount = discount
	FROM inserted;
            SELECT @shippingCost = dbo.calculateShippingCost(@orderID);
            SELECT @promo = dbo.calculatePromo(@orderID);
            UPDATE [Order] SET shippingCost = @shippingCost,  promo = @promo,  
            grandTotal = @total - ((@total*@promo)/100) - ((@total*@discount)/100) + ((@tax*@total)/100) + @shippingCost   WHERE orderId = @orderID;
END