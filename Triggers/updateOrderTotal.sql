USE WareHouseManagementSystem;

CREATE TRIGGER updateOrderTotal
ON dbo.[OrderItem]
AFTER INSERT, UPDATE
AS
BEGIN

    DECLARE @Price DECIMAL;
    DECLARE @discount DECIMAL;
    DECLARE @tax DECIMAL;
    DECLARE @shippingCost DECIMAL;
	DECLARE @orderID INT;

    DECLARE @orderTotal DECIMAL;

    Select 
	@orderID = orderId
    FROM inserted;
            SELECT @orderID ;
            SELECT @orderTotal = dbo.computeOrderTotalPrice(@orderID);
            SELECT @orderTotal;
            UPDATE [Order] SET total = @orderTotal WHERE orderId = @orderID;
END
