ALTER TABLE dbo.OrderItem ADD CONSTRAINT checkStockConstraint
CHECK (quantity <= dbo.checkStock(orderItemId));