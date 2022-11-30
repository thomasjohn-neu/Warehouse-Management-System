CREATE TABLE TransactionType(
    transactionTypeID INT NOT NULL PRIMARY KEY,
    transactionDescription VARCHAR(50)
);

create TABLE [Transaction](
	transactionID INT NOT NULL PRIMARY KEY,
	orderID INT NOT NULL,
	transactionTypeID INT FOREIGN KEY REFERENCES TransactionType(transactionTypeID),
	charges FLOAT,
	code INT,
	mode VARCHAR(20),
	status VARCHAR(30),
	createdAt DATETIME NOT NULL,
    updatedAt DATETIME NULL DEFAULT NULL,
	content VARCHAR(MAX),
	FOREIGN KEY(orderID) REFERENCES [WareHouseManagementSystem].[dbo].[Order](orderID),
	FOREIGN KEY(transactionTypeID) REFERENCES [WareHouseManagementSystem].[dbo].[TransactionType](transactionTypeID),
	PRIMARY KEY(transactionID)
);