
USE NewWarehouseSystem;

CREATE TABLE Brand
      (
      brandId INT NOT NULL PRIMARY KEY,
      title VARCHAR(20),
      summary TEXT,
      createdAt DATETIME,
      updatedAt DATETIME,
      about TEXT
      );

CREATE TABLE Supplier
     (
     supplierId INT NOT NULL PRIMARY KEY,
     name VARCHAR(20),
     line1 VARCHAR(20),
     line2 VARCHAR(20),
     city VARCHAR(20),
     state VARCHAR(20),
     zipcode INT,
     phone INT,
     email VARCHAR(50)
     );

CREATE TABLE Category(
    categoryId INT NOT NULL,
    title VARCHAR(20) NOT NULL,
    metaTitle VARCHAR(30) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    content TEXT NULL DEFAULT NULL,
    PRIMARY KEY (categoryId)
);

CREATE TABLE User(
    userId INT NOT NULL,
    firstName VARCHAR(20) NOT NULL,
	middleName VARCHAR(20),
    lastName VARCHAR(20),
	username VARCHAR(20),
    email VARCHAR(50),
	phoneNumber INT NOT NULL,
	registeredAt DATETIME NOT NULL,
	lastLogin DATETIME NOT NULL,
    PRIMARY KEY(userID)
);

CREATE TABLE Product(
    productId INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    summary TEXT NULL DEFAULT NULL,
    productType INT NOT NULL DEFAULT 0,
    content TEXT NULL DEFAULT NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(productId)
    );

CREATE TABLE ProductCategory(
    categoryId INT NOT NULL,
    productId INT NOT NULL,
    FOREIGN KEY(categoryId) REFERENCES Category (categoryId),
    FOREIGN KEY(productId) REFERENCES Product (productId),
);

CREATE TABLE ProductMeta(
    metaId INT NOT NULL,
    productId INT NOT NULL,
    [key] VARCHAR(50) NOT NULL, 
    content TEXT NULL DEFAULT NULL,
    FOREIGN KEY(productId) REFERENCES Product (productId),
    PRIMARY KEY (metaId)
);

CREATE TABLE StockItem
    (
      itemId INT NOT NULL PRIMARY KEY,
      productId INT NOT NULL FOREIGN KEY REFERENCES Product(productId),
      brandId INT NOT NULL FOREIGN KEY REFERENCES brand(brandID),
      supplierId INT NOT NULL FOREIGN KEY REFERENCES Supplier(supplierID),
      sku VARCHAR(40),
      discount DECIMAL,
      price DECIMAL,
	  quantity INT,
	  [availability] CHAR,
	  defective CHAR,
	  createdBy INT,
	  updatedBy INT,
	  createdAt DATETIME,
	  updatedAt DATETIME
	  );

CREATE TABLE [Order]
    (
      orderId INT NOT NULL PRIMARY KEY,
      userId INT NOT NULL FOREIGN KEY REFERENCES Users(userId),
      itemId INT NOT NULL FOREIGN KEY REFERENCES StockItem(itemId),
      supplierId INT NOT NULL FOREIGN KEY REFERENCES Supplier(supplierId),
      orderType VARCHAR(25) CHECK([orderType] IN ('purchase order','customer order')) DEFAULT 'customer order',
      [status] VARCHAR(40),
      price DECIMAL,
      transactionCharges DECIMAL,
      discount DECIMAL,
      tax DECIMAL,
      shippingCost DECIMAL,
      total DECIMAL,
      promo DECIMAL,
      grandTotal DECIMAL,
      createdAt DATETIME,
      updatedAt DATETIME
      );



CREATE TABLE OrderItem
    (
    orderItemId INT NOT NULL PRIMARY KEY,
    productId INT NOT NULL,
    orderId INT NOT NULL FOREIGN KEY REFERENCES [Order](orderId),
    title VARCHAR(40),
    sku VARCHAR(40),
    price DECIMAL,
    discount DECIMAL,
    quantity INT,
    createdAt DATETIME,
    updateAt DATETIME,
    content TEXT,
	FOREIGN KEY (orderItemId) REFERENCES StockItem(itemId)
	);



CREATE TABLE[Address](
    addressId INT NOT NULL,
	orderId INT NOT NULL,
   [address] VARCHAR(MAX) NOT NULL,
    city VARCHAR(20) NOT NULL,
   [state] VARCHAR(15) NOT NULL,
	zipCode INT NOT NULL,
   [country] VARCHAR(15) NOT NULL,
    createdAt DATETIME NOT NULL,
	FOREIGN KEY(orderId) REFERENCES [Order](orderId),
	PRIMARY KEY(addressId)
);



create TABLE [Transaction](
	transactionId INT NOT NULL,
	orderId INT NOT NULL,
	paymentType VARCHAR(25) CHECK([paymentType] IN ('Credit Card','Debit Card','Net Banking')) DEFAULT 'Credit Card',
	charges FLOAT,
	code INT,
	mode VARCHAR(20),
	[status] INT NOT NULL DEFAULT 0,
	createdAt DATETIME NOT NULL,
    updatedAt DATETIME NULL DEFAULT NULL,
	content VARCHAR(MAX),
	FOREIGN KEY(orderId) REFERENCES [Order](orderId),
	PRIMARY KEY(transactionId)
);


create TABLE Delivery(
	deliveryId INT NOT NULL,
	orderId INT NOT NULL,
	addressId INT NOT NULL,
	[status] INT NOT NULL DEFAULT 0,
	FOREIGN KEY(orderId) REFERENCES [Order](orderId),
	FOREIGN KEY(addressId) REFERENCES [Address](addressId),
	PRIMARY KEY(deliveryId)
);