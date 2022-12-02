CREATE DATABASE WareHouseManagementSystem;

USE NewWarehouseSystem;

--Create commands for brand table 
CREATE TABLE Brand
      (
      brandId INT NOT NULL PRIMARY KEY,
      title VARCHAR(20),
      summary TEXT,
      createdAt DATETIME,
      updatedAt DATETIME,
      about TEXT
      );

--Create commands for supplier table
CREATE TABLE Supplier
     (
     supplierId INT NOT NULL PRIMARY KEY,
     name VARCHAR(20),
     line1 VARCHAR(20),
     line2 VARCHAR(20),
     city VARCHAR(20),
     state VARCHAR(20),
     zipcode VARCHAR(20),
     phone VARCHAR(20),
     email VARCHAR(50)
     );

--Create commands for category table
CREATE TABLE Category(
    categoryId INT NOT NULL,
    title VARCHAR(20) NOT NULL,
    metaTitle VARCHAR(30) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    content TEXT NULL DEFAULT NULL,
    PRIMARY KEY (categoryId)
);

--Create commands for User table
CREATE TABLE [User](
    userId INT NOT NULL,
    firstName VARCHAR(20) NOT NULL,
	middleName VARCHAR(20),
    lastName VARCHAR(20),
	username VARCHAR(20),
    email VARCHAR(50),
	phoneNumber VARCHAR(20) NOT NULL,
	registeredAt DATETIME NOT NULL,
	lastLogin DATETIME NOT NULL,
    PRIMARY KEY(userID)
);

--Create commands for Product table
CREATE TABLE Product(
    productId INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    summary TEXT NULL DEFAULT NULL,
    content TEXT NULL DEFAULT NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(productId)
    );

--Create commands for ProductCategory
CREATE TABLE ProductCategory(
    categoryId INT NOT NULL,
    productId INT NOT NULL,
    FOREIGN KEY(categoryId) REFERENCES Category (categoryId),
    FOREIGN KEY(productId) REFERENCES Product (productId),
);

--Create commands for ProductMeta
CREATE TABLE ProductMeta(
    metaId INT NOT NULL,
    productId INT NOT NULL,
    [key] VARCHAR(50) NOT NULL, 
    content TEXT NULL DEFAULT NULL,
    FOREIGN KEY(productId) REFERENCES Product (productId),
    PRIMARY KEY (metaId)
);

--Create commands for Order table
CREATE TABLE [Order]
    (
      orderId INT NOT NULL PRIMARY KEY,
      userId INT FOREIGN KEY REFERENCES [User](userId),
      supplierId INT FOREIGN KEY REFERENCES Supplier(supplierId),
      orderType VARCHAR(25) CHECK([orderType] IN ('purchase order','customer order')) DEFAULT 'customer order',
      [status] VARCHAR(40),
      discount DECIMAL DEFAULT 5,
      tax DECIMAL DEFAULT 3,
      shippingCost DECIMAL DEFAULT 0.5,
      total DECIMAL,
      promo DECIMAL,
      grandTotal DECIMAL,
      createdAt DATETIME,
      updatedAt DATETIME
      );

--Create commands for Transaction table
CREATE TABLE [Transaction](
	transactionId INT NOT NULL,
	userId INT NOT NULL FOREIGN KEY REFERENCES [User](userId),
    orderId INT NOT NULL FOREIGN KEY REFERENCES [Order](orderId),
	paymentType VARCHAR(25) CHECK([paymentType] IN ('Credit_Card','Debit_Card','Net_Banking')) DEFAULT 'Credit Card',
	charges FLOAT,
	code INT,
	mode VARCHAR(20),
	[status] INT NOT NULL DEFAULT 0,
	createdAt DATETIME NOT NULL,
    updatedAt DATETIME NULL DEFAULT NULL,
	content VARCHAR(MAX),
	PRIMARY KEY(transactionId)
);

--Create commands for StockItem table
CREATE TABLE StockItem
    (
      itemId INT NOT NULL PRIMARY KEY,
      productId INT NOT NULL FOREIGN KEY REFERENCES Product(productId),
      brandId INT NOT NULL FOREIGN KEY REFERENCES brand(brandID),
      supplierId INT NOT NULL FOREIGN KEY REFERENCES Supplier(supplierID),
      orderId INT NOT NULL FOREIGN KEY REFERENCES [Order](orderId),
      sku VARCHAR(40),
      discount DECIMAL DEFAULT 0,
      price DECIMAL,
	  quantity INT,
	  [availability] CHAR,
	  defective CHAR,
	  createdBy INT,
	  updatedBy INT,
	  createdAt DATETIME,
	  updatedAt DATETIME
	  );

--Create commands for OrderItem table
CREATE TABLE OrderItem
    (
    orderItemId INT NOT NULL PRIMARY KEY,
    productId INT NOT NULL FOREIGN KEY REFERENCES Product(productId),
    orderId INT NOT NULL FOREIGN KEY REFERENCES [Order](orderId),
    price DECIMAL,
    discount DECIMAL,
    quantity INT,
    createdAt DATETIME,
    updateAt DATETIME,
    content TEXT,
	FOREIGN KEY (orderItemId) REFERENCES StockItem(itemId)
	);

--Create commands for Address
CREATE TABLE[Address](
    addressId INT NOT NULL,
	userId INT NOT NULL,
   [address] VARCHAR(MAX) NOT NULL,
    city VARCHAR(20) NOT NULL,
   [state] VARCHAR(15) NOT NULL,
	zipCode VARCHAR(20) NOT NULL,
   [country] VARCHAR(15) NOT NULL,
    createdAt DATETIME NOT NULL,
	FOREIGN KEY(userId) REFERENCES [user](userId),
	PRIMARY KEY(addressId)
);

--Create commands for Delivery
create TABLE Delivery(
	deliveryId INT NOT NULL,
	orderId INT NOT NULL UNIQUE,
	addressId INT NOT NULL,
	[status] INT NOT NULL DEFAULT 0,
	FOREIGN KEY(orderId) REFERENCES [Order](orderId),
	FOREIGN KEY(addressId) REFERENCES [Address](addressId),
	PRIMARY KEY(deliveryId)
);

-- Constraint to make sure item in stock
ALTER TABLE dbo.OrderItem ADD CONSTRAINT checkStockConstraint
CHECK (quantity <= dbo.checkStock(orderItemId));

-- Constraint to validate email id for User
ALTER TABLE [User]
ADD CONSTRAINT EmailCheck  CHECK(email LIKE '%___@___%.__%');

-- Constraint to prevent duplicate username
ALTER TABLE [User] 
ADD CONSTRAINT [IX_UniqueUserName] UNIQUE NONCLUSTERED ([username] ASC);

-- Contraint to validate email id for supplier
ALTER TABLE [Supplier]
ADD CONSTRAINT SupplierEmailCheck  CHECK(email LIKE '%___@___%.__%');

--Function to get Order type
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

--Function to calculate final order price
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

--Function to calculate total price in Orderitem table
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

--Function to check stock availability
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

--Function to calculate shipping cost
CREATE FUNCTION calculateShippingCost(@orderId INT)
RETURNS DECIMAL
AS
   BEGIN

   DECLARE @Price as DECIMAL
   DECLARE @shippingCost as DECIMAL

   SELECT @Price = total FROM [order] 
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

--Function to assign Promo to order 
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

--Trigger to update values in orderItem table
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
                    SELECT @stockQty = dbo.checkStock(@stockItemId)-@orderOty;
                ELSE
                    SELECT @stockQty = dbo.checkStock(@stockItemId)+@orderOty;
                UPDATE StockItem SET quantity=@stockQty,
                availability = CASE WHEN @stockQty <= 0 THEN 'n' ELSE 'y' END
                WHERE itemId=@stockItemId;
    END
END

--Trigger to update values in orderItem table
CREATE TRIGGER computePerOrderItemTotal
ON dbo.[OrderItem]
AFTER INSERT, UPDATE
AS
BEGIN

    DECLARE @Price DECIMAL;
    DECLARE @discount DECIMAL;
	
    DECLARE @orderItemId INT;
    DECLARE @productId INT;
    DECLARE @orderId INT;
    DECLARE @quantity INT;

    DECLARE cur CURSOR FOR
        Select orderItemId, productId, orderId, quantity FROM inserted;
    OPEN cur
    FETCH NEXT FROM cur INTO @orderItemId, @productId, @orderId, @quantity
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @Price=dbo.computeOrderItemPrice(@productId, @quantity);
        UPDATE [OrderItem] SET price = @Price 
        WHERE orderId = @orderID AND orderItemId=@orderItemId AND productId=@productId;
    FETCH NEXT FROM cur INTO @orderItemId, @productId, @orderId, @quantity
END
CLOSE cur
DEALLOCATE cur
END

--Trigger to update values in Order table
CREATE TRIGGER CostOrder
ON dbo.[Order]
AFTER INSERT, UPDATE
AS
BEGIN

    
    DECLARE @discount DECIMAL;
    DECLARE @tax DECIMAL;
    DECLARE @shippingCost DECIMAL;
	DECLARE @total DECIMAL;
    DECLARE @promo DECIMAL;
	DECLARE @grandTotal DECIMAL
	
	DECLARE @orderID INT;

    Select 
	@orderID = orderId,
	@tax = tax,
	@total = total,
    @discount = discount
	FROM inserted;
            SELECT @shippingCost = dbo.calculateShippingCost(@orderID);
            SELECT @promo = dbo.calculatePromo(@orderID);
            UPDATE [Order] SET shippingCost = @shippingCost,  promo = @promo,  
            grandTotal = @total - ((@total*@promo)/100) - ((@total*@discount)/100) + ((@tax*@total)/100) + @shippingCost   WHERE orderId = @orderID;
END



/*Insertion commands*/


--Insert commands for Brand table
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (1, 'Apple', 'Phones,Personal gadgets', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'Apple is an american multinational company specialising in personal electronics products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (2, 'Bose', 'Speakers,Earphones,Headsets', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'Bose is an american multinational company specialising in speakers, headphones,etc.');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (3, 'HP', 'Computers,Personal gadgets', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'HP is an american multinational company specialising in personal computers and related products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (4, 'Samsung', 'Phones,Personal gadgets', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'Samsung is a South Korean electronics giant specialising in personal electronics products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (5, 'Unilever', 'FMCG Products', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,' Unilever is a British consumer products giant specialising in FMCG products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (6, 'L`Oreal', 'Personal care products', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'L`Oreal is an French personal care company specialising in personal care products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (7, 'Google', 'Software products and services', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'Google is an American technology giant providing browsing,cloud and other software services and personal electronics products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (8, 'General Mills', 'FMCG Products', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'General Mills is an is a American manufacturer of food products');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (9, 'GlaxoSmithKline', 'Pharmaceuticals', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,' GlaxoSmithKline is a British pharma giant');
INSERT INTO Brand(brandId, title, summary, createdAt, updatedAt, about) VALUES (10, 'Michelin', 'Tyres', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'Michelin is a french company manufacturing tyres');

--Insert commands for Supplier table
INSERT INTO [Supplier] (supplierId, [name], line1, line2, city, [state], zipcode, phone, email)
VALUES 
(1, 'Boston Supply Inc', '157 E Cottage', 'Dorchester', 'Boston', 'MA', '02125', '8572301918', 'bostonsupp@bostoninc.com'),
(2, 'Smith and Co', '23 Burr Street', 'Jamiaca Plain', 'Boston', 'MA', '02134', '8573451934', 'smithandco@sac.com'),
(3, 'Best Supplies', '34 Columbia Road', 'Dorchester', 'Boston', 'MA', '02125', '8257234934', 'bestsupplies@bestsupp.com'),
(4, 'Walmart Co', '134 Dudley Street', 'Roxbury', 'Boston', 'MA', '02118', '8572343345', 'walmart@wlamartco.com'),
(5, 'Stop and Shop Co', 'South Bay', 'Dorchester', 'Boston', 'MA', '02125', '4042343345', 'stopnshop@sns.com'),
(6, 'All in one supplies', 'South Bay', 'Dorchester', 'Boston', 'MA', '02125', '4046675482', 'allinone@allonesupp.com'), 
(7, 'Farm First Co', '22 New York City', 'Times Square', 'New York City', 'NY', '02332', '4042222482', 'farmfirst@firstsupp.com'), 
(8, 'The Regional Supply', '12 Wall Street', 'Broadway', 'New York City', 'NY', '02331', '4047777482', 'regionalretail@regionalsupp.com'), 
(9, 'The Supply Corner', '12 Washington Street', 'Broadway', 'New York City', 'NY', '02321', '4046939172', 'supplycorner@cornersupp.com'), 
(10, 'Smart Office Supply', '12 Burr Street', 'Jamaica Plain', 'Dorchester', 'MA', '02321', '4046939172', 'supplycorner@cornersupp.com');

--Insert commands for Category table
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (1, 'Mobile Phones', 'Mobile Phones', 'mobile-phones', 'This category deals with mobile phones, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (2, 'Computers', 'Computers', 'computers', 'This category deals with Computers, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (3, 'Tablets', 'Tablets', 'tablets', 'This category deals with Tablets, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (4, 'Laptops', 'Laptops', 'laptops', 'This category deals with Laptops, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (5, 'Televisions', 'Televisions', 'televisions', 'This category deals with Televisions, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (6, 'Printers', 'Printers', 'printers', 'This category deals with Printers, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (7, 'Internet Devices', 'Internet Devices', 'internet-devices', 'This category deals with internet-devices, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (8, 'Electronics', 'Electronics', 'electronics', 'This category deals with Electronics, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (9, 'Watches', 'Watches', 'Watches', 'This category deals with Watches, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (10, 'Headphones', 'Headphones', 'headphoness', 'This category deals with Headphones, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (11, 'Speakers', 'speakers', 'speakers', 'This category deals with speakers, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (12, 'Gaming', 'Gaming', 'gaming', 'This category deals with Gaming, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (13, 'Mics & Audio', 'Mics & Audio', 'mics-audio', 'This category deals with Mics & Audio, accessories and related products');
INSERT INTO Category(categoryId, title, metaTitle, slug, content) VALUES (14, 'Peripherals', 'peripherals', 'peripherals', 'This category deals with Peripherals, accessories and related products');

--Insert commands for User table
INSERT INTO [User] (userId, firstName, middleName, lastName, username, email, phoneNumber, registeredAt, lastLogin)
VALUES (1, 'Vicken', '', 'Joseph', 'vicken.joseph', 'vickenjoseph@gmail.com', '8574322233', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'James', '', 'Smith', 'james.smith', 'james.smith@gmail.com', '8573341233', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'Maria', 'Greg', 'Garcia', 'maria.garcia', 'maria.garcia@gmail.com', '8576931233', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Davis', '', 'Henry', 'davis.henry', 'davis.henry@gmail.com', '8578383134', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(5, 'Miller', '', 'Williams', 'miller.williams', 'miller.williams@gmail.com', '4048281134', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(6, 'Smauel', '', 'Jones', 'smauel.jones', 'smauel.jones@gmail.com', '4049967543', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP ), 
(7, 'Nancy', 'Martha', 'Ann', 'nancy.martha', 'nancy.martha@gmail.com', '4049645878', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(8, 'Susan', '', 'Thomas', 'susan.thomas', 'susan.thomas@gmail.com', '4049629278', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(9, 'Margaret', '', 'Brown', 'margaret.brown', 'margaret.brown@gmail.com', '4041969998', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(10, 'Eliza', '', 'Johnson', 'elisa.johnson', 'elisa.johnson@gmail.com', '8572348851', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP );

--Insert commands for Product table
INSERT INTO Product(productId, title, summary, content) VALUES (1, 'Iphone 14 Pro', '64 GB, Black, iOS 16', 'This is 64 GB, Black, iOS 16');
INSERT INTO Product(productId, title, summary, content) VALUES (2, 'Iphone 14 Pro Max', '64 GB, Black, iOS 16', 'This is 64 GB, Black, iOS 16');
INSERT INTO Product(productId, title, summary, content) VALUES (3, 'Iphone 13 Pro', '64 GB, Black, iOS 16', 'This is 64 GB, Black, iOS 16');
INSERT INTO Product(productId, title, summary, content) VALUES (4, 'Iphone 14', '64 GB, Black, iOS 16', 'This is 64 GB, Black, iOS 16');
INSERT INTO Product(productId, title, summary, content) VALUES (5, 'Iphone 14+', '64 GB, Black, iOS 16', 'This is 64 GB, Black, iOS 16');
INSERT INTO Product(productId, title, summary, content) VALUES (6, 'Airpods', 'White, 3rd Generation', 'Airpods White, 3rd Generation');
INSERT INTO Product(productId, title, summary, content) VALUES (7, 'Airpods Pro', 'White, 3rd Generation', 'Airpods White, 3rd Generation');
INSERT INTO Product(productId, title, summary, content) VALUES (8, 'Airpods Pro Max', 'White, 3rd Generation', 'Airpods White, 3rd Generation');
INSERT INTO Product(productId, title, summary, content) VALUES (9, 'Bose Master jack', 'White, 3rd Generation', 'Bose Master jack White, 3rd Generation');
INSERT INTO Product(productId, title, summary, content) VALUES (10, 'Bose Speakers', 'Black, 2.1 channel', 'Black, 2.1 channel, Bluetooth 5.0');
INSERT INTO Product(productId, title, summary, content) VALUES (11, 'Bose Speakers Pro', 'Black, 2.1 channel', 'Black, 2.1 channel, Bluetooth 5.0');
INSERT INTO Product(productId, title, summary, content) VALUES (12, 'Chromebook', 'Black 128GB', 'Black, 2.1 channel, Bluetooth 5.0');
INSERT INTO Product(productId, title, summary, content) VALUES (13, 'HP Keyboard', 'Black, all keys', 'Black, sleek black, Bluetooth 5.0');

--Insert commands for ProductCategory table
INSERT INTO ProductCategory(categoryId, productId) VALUES (1,1);
INSERT INTO ProductCategory(categoryId, productId) VALUES (1,2);
INSERT INTO ProductCategory(categoryId, productId) VALUES (1,3);
INSERT INTO ProductCategory(categoryId, productId) VALUES (1,4);
INSERT INTO ProductCategory(categoryId, productId) VALUES (1,5);
INSERT INTO ProductCategory(categoryId, productId) VALUES (10,6);
INSERT INTO ProductCategory(categoryId, productId) VALUES (10,7);
INSERT INTO ProductCategory(categoryId, productId) VALUES (10,8);
INSERT INTO ProductCategory(categoryId, productId) VALUES (10,9);
INSERT INTO ProductCategory(categoryId, productId) VALUES (10,10);
INSERT INTO ProductCategory(categoryId, productId) VALUES (11,11);
INSERT INTO ProductCategory(categoryId, productId) VALUES (4,12);
INSERT INTO ProductCategory(categoryId, productId) VALUES (14,13);

--Insert commands for ProductMeta table
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (1, 1, 'banner', 'The best iphone ever');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (2, 2, 'banner', 'The best iphone ever');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (3, 3, 'banner', 'The best iphone ever');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (4, 4, 'banner', 'The best iphone ever');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (5, 5, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (6, 6, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (7, 7, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (8, 8, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (9, 9, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (10, 10, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (11, 11, 'banner', 'Experience the sound around you');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (12, 12, 'banner', 'Slim like a sword');
INSERT INTO ProductMeta(metaId, productId, [key], content) VALUES (13, 13, 'banner', 'Feel the feather at your fingertips');

--Insert commands for Order table
INSERT INTO [Order](orderId,userId,supplierId,orderType,[status],tax,shippingCost,promo,createdAt,updatedAt)
VALUES
(1,1,1,'purchase order','processed',21.00,1.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(2,2,2,'purchase order','processed',21.00,1.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(3,3,3,'purchase order','processed',11.00,4.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(4,4,4,'purchase order','processed',71.00,3.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(5,5,5,'customer order','processed',41.00,2.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(6,6,6,'purchase order','failed',21.00,5.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(7,7,7,'customer order','processed',24.00,5.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(8,8,8,'purchase order','processed',22.00,2.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(9,9,9,'customer order','failer',26.00,7.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP),
(10,10,10,'purchase order','processed',25.00,2.50,5.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

--Insert commands for StockItem table
INSERT INTO StockItem(itemId, productId, brandId, supplierId, orderId, sku, discount, price, quantity, [availability], defective, createdBy, updatedBy, createdAt, updatedAt) VALUES
(1, 1, 1, 1, 1, 'APPIPH14PRO64B', 0, 999.99, 102400, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 1, 1, 2, 'APPIPH14PMX64B', 0, 1199.99, 102400, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, 1, 1, 3, 'APPIPH13PRO64B', 0, 1099.99, 100100, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 4, 1, 1, 4, 'APPIPH14BSC64B', 0, 1199.99, 102400, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 5, 1, 1, 5, 'APPIPH14+BS64B', 0, 899.99, 123000, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 6, 1, 1, 6, 'APPAIRPODWHT3', 0, 199.99, 100000, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, 7, 1, 1, 7, 'APPAIRPODPRO3', 0, 299.99, 350000, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 8, 1, 1, 8, 'APPAIRPODMAX3', 0, 499.99, 240000, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(9, 9, 1, 1, 9, 'BOSMASTRJACK1', 0, 299.99, 123000, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(10, 10, 1, 1, 10, 'BOSMASTRSPKR', 0, 359.99, 780000, 'y', 'n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

--Insert commands for Transaction table
INSERT INTO [Transaction](transactionId,userId, orderId, paymentType, code, mode, [status], createdAt, updatedAt, content, charges) VALUES
(1,1,1,'Credit_Card', 1122, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 1234.00),
(2,2,2, 'Debit_Card', 1123, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 234.00),
(3,3,3, 'Credit_Card', 1124, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 346.00),
(4,4,4, 'Net_Banking', 1125, 'COD', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Not Received', 364.00),
(5,5,5, 'Credit_Card', 1126, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 5234.00),
(6,6,6, 'Debit_Card', 1127, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 7234.00),
(7,7,7, 'Credit_Card', 1182, 'COD', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Not Received', 8234.00),
(8,8,8, 'Net_Banking', 1192, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 134.00),
(9,9,9, 'Debit_Card', 1120, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 34.00),
(10,10,10, 'Credit_Card', 1121, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 934.00);

--Insert commands for OrderItem table
INSERT INTO orderItem(orderItemId,productid,orderId,quantity,createdAt,updateAt,content)
VALUES
(1,1,1,40,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'ABC'),
(2,2,2,41,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'BCD'),
(3,3,3,42,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'CDE'),
(4,4,4,43,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'DEF'),
(5,5,5,44,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'EFG'),
(6,6,6,45,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'FGH'),
(7,7,7,46,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'GHI'),
(8,8,8,47,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'HIJ'),
(9,9,9,48,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'IJK'),
(10,10,10,49,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'JKL');

--Insert commands for Address table
INSERT INTO [Address] (addressId, userId, [address], city, [state], zipCode, country, createdAt)
VALUES
(1, 1, '151 East Cottage', 'Boston', 'MA', '02125', 'US', CURRENT_TIMESTAMP ),
(2, 2, '12 Burr Street', 'Boston', 'MA', '02130', 'US', CURRENT_TIMESTAMP),
(3, 3, '34 Ruggles St', 'Boston', 'MA', '02230', 'US', CURRENT_TIMESTAMP),
(4, 4, '15 Chinatown', 'Boston', 'MA', '02222', 'US', CURRENT_TIMESTAMP),
(5, 5, '12 Wasinghton St', 'New York City', 'NY', '01130', 'US', CURRENT_TIMESTAMP),
(6, 6, '587 W Cottage St', 'Boston', 'MA', '02126', 'US', CURRENT_TIMESTAMP),
(7, 7, '77 Columbia Rd', 'Boston', 'MA', '02221', 'US', CURRENT_TIMESTAMP),
(8, 8, '87 MLKJ Blvd', 'Boston', 'MA', '02765', 'US', CURRENT_TIMESTAMP),
(9, 9, '12 Stony Brk', 'Boston', 'MA', '02776', 'US', CURRENT_TIMESTAMP),
(10, 10, '45 Virginia St', 'Boston', 'MA', '02187', 'US', CURRENT_TIMESTAMP);

--Insert commands for Delivery table
INSERT INTO [Delivery] (deliveryId, orderId, addressId, [status])
VALUES 
(1, 1, 1, 1),
(2, 2, 2, 0),
(3, 3, 3, 1),
(4, 4, 4, 1),
(5, 5, 5, 0),
(6, 6, 6, 1),
(7, 7, 7, 0),
(8, 8, 8, 0),
(9, 9, 9, 1),
(10, 10, 10, 1);

--Encryption on User Details

/*
COMMANDS TO DROP KEYS
DROP SYMMETRIC KEY user_Key_1;
DROP CERTIFICATE usercert;
DROP MASTER KEY;
*/

--CREATE MASTER KEY

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password2022$';

 -- CREATE CERTIFICATE
CREATE CERTIFICATE usercert WITH SUBJECT = 'User Indentity Details';


-- CREATE SYMMETRIC KEY
CREATE SYMMETRIC KEY user_Key_1
WITH ALGORITHM = AES_256  -- it can be AES_128,AES_192,DES etc
ENCRYPTION BY CERTIFICATE usercert;

--Encryption
ALTER TABLE [User] ADD FirstName_encrypt varbinary(MAX),MiddleName_encrypt varbinary(MAX),LastName_encrypt varbinary(MAX),
username_encrypt varbinary(MAX),Email_encrypt varbinary(MAX), PhoneNumber_encrypt varbinary(MAX)

OPEN SYMMETRIC KEY user_Key_1 DECRYPTION BY CERTIFICATE usercert;

UPDATE [User]
        SET FirstName_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), firstName)),
			MiddleName_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), middleName)),
		    LastName_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), lastName)),
			username_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), username)),
			Email_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(50), email)),
			PhoneNumber_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(char(10), phoneNumber))
        FROM [User];
GO

-- Close SYMMETRIC KEY
CLOSE SYMMETRIC KEY user_Key_1;
GO

--View encrypted data
SELECT FirstName_encrypt, LastName_encrypt,Email_encrypt , username_encrypt,
PhoneNumber_encrypt FROM [User];

--Dropping Old Columns 
--ALTER TABLE [User] DROP COLUMN [firstName],[middleName], [lastName], [username], [email],[phoneNumber];


 --- Decryption
OPEN SYMMETRIC KEY user_Key_1 DECRYPTION BY CERTIFICATE usercert;

SELECT FirstName_encrypt, LastName_encrypt Email_encrypt ,username_encrypt,
PhoneNumber_encrypt,
CONVERT(varchar, DecryptByKey(FirstName_encrypt)) AS 'Decrypted Firstname',
CONVERT(varchar, DecryptByKey(LastName_encrypt)) AS 'Decrypted Lastname',
CONVERT(varchar, DecryptByKey(Email_encrypt)) AS 'Decrypted Email',
CONVERT(varchar, DecryptByKey(username_encrypt)) AS 'Decrypted Username',
CONVERT(varchar, DecryptByKey(PhoneNumber_encrypt)) AS 'Decrypted PhoneNumber'
FROM [User];

CLOSE SYMMETRIC KEY user_Key_1;


-- View to display top 5 products sold in the last ten days
CREATE VIEW TopFive AS
    SELECT 
        TOP(5) oi.orderItemId as 'Order Item ID', 
        p.title as 'Product Title',
        SUM(oi.quantity) AS 'Total Quantity Ordered'
    FROM orderItem oi 
    JOIN [order] o 
        ON oi.orderId = o.orderId
    JOIN Product p
        ON oi.productId = p.productId
    WHERE oi.createdAt>=DATEADD(DAY,-10,GETDATE())
    GROUP BY oi.orderItemId, p.title
    ORDER BY SUM(Quantity) DESC

--select * from TopFive
--DROP view TopFive
-- View to display the brand report 
CREATE VIEW BrandReport AS
    SELECT 
        b.brandId as 'Brand ID',
        b.title as 'Brand Name', 
        SUM(oi.quantity) AS 'Sold Quantity'
    FROM Brand b 
    INNER JOIN 
        StockItem si ON b.brandId = si.brandID
    INNER JOIN 
        orderItem oi ON oi.orderItemId = si.itemId
    GROUP BY b.brandId,b.title;

--select * from BrandReport
--DROP view BrandReport

-- View to see what products need to be restocked based on the given threshold
CREATE VIEW ReStock AS
    SELECT 
        p.productId as 'Product ID', 
        p.title as 'Product Name', 
        SUM(si.quantity) as 'Available Quantity' 
    FROM StockItem si 
    INNER JOIN 
        Product p ON si.productId = p.productId
    GROUP BY p.productId,p.title
    HAVING SUM(si.quantity)<200000;

/*select * from Restock*/
--DROP view Restock

/*Procedure*/

--Procedure to place a customer order
GO
CREATE PROCEDURE 
MakeCustomerOrder(@customerId INT, @productId INT, @quantity INT)
AS
BEGIN

    DECLARE @productExists INT;
    SELECT @productExists = COUNT(productId) FROM Product WHERE productId = @productId;
    IF @productExists > 0
        BEGIN
            DECLARE @stockExists INT;
            DECLARE @tax DECIMAL;
            DECLARE @discount DECIMAL;
            SET @tax = 5;
            SET @discount = 25; 
            DECLARE @stockItemId INT
            SELECT @stockItemId = itemId from StockItem;
            SELECT @stockExists = dbo.checkStock(@stockItemId);
            IF @stockExists > @quantity
                BEGIN
                    DECLARE @orderId INT
                    SELECT @orderId = MAX(orderId) FROM [Order]; --- last order id
                    SET @orderId = @orderId + 1
                    

                    INSERT INTO [Order](orderId, userId, orderType, discount, tax) VALUES (@orderId, @customerId, 'customer order', @discount, @tax);
                    INSERT INTO OrderItem(orderItemId, productId, orderId, quantity) VALUES (@stockItemId, @productId, @orderId, @quantity);
                    PRINT 'Successfully placed your order!'        
                END
            ELSE
                BEGIN
                    PRINT 'We are out of stock! Try again later!'
                END
        END
    ELSE
        BEGIN
            PRINT 'No such product exists'
        END
END

--Procedure for placing purchase order
GO
CREATE PROCEDURE 
MakePurchaseOrder(@supplierID INT, @productId INT, @quantity INT)
AS
BEGIN

    DECLARE @productExists INT;
    SELECT @productExists = COUNT(productId) FROM Product WHERE productId = @productId;
    IF @productExists > 0
        BEGIN
            DECLARE @stockExists INT;
            DECLARE @tax DECIMAL;
            DECLARE @discount DECIMAL;
            SET @tax = 5;
            SET @discount = 25; 
            DECLARE @stockItemId INT
            SELECT @stockItemId = itemId from StockItem;
            SELECT @stockExists = dbo.checkStock(@stockItemId);
            
            DECLARE @orderId INT
            SELECT @orderId = MAX(orderId) FROM [Order]; --- last order id
            SET @orderId = @orderId + 1
            
            INSERT INTO [Order](orderId, supplierId, orderType, discount, tax) VALUES (@orderId, @supplierID, 'purchase order', @discount, @tax);
            INSERT INTO OrderItem(orderItemId, productId, orderId, quantity) VALUES (@stockItemId, @productId, @orderId, @quantity);
            PRINT 'Successfully placed your order!'        
        END
    ELSE
        BEGIN
            PRINT 'No such product exists'
        END
END

