CREATE TABLE TransactionType(
    transactionTypeID INT NOT NULL,
    transactionDescription VARCHAR(50)
	PRIMARY KEY (transactionTypeID)
);

create TABLE [Transaction](
	transactionID INT NOT NULL,
	orderID INT NOT NULL,
	transactionTypeID INT,
	charges FLOAT,
	code INT,
	mode VARCHAR(20),
	status VARCHAR(30),
	createdAt DATETIME NOT NULL,
    updatedAt DATETIME NULL DEFAULT NULL,
	content VARCHAR(MAX),
	FOREIGN KEY(orderID) REFERENCES [WareHouseManagementSystem].[dbo].[Order](orderID),
	FOREIGN KEY(transactionTypeID) REFERENCES TransactionType(transactionTypeID),
	PRIMARY KEY(transactionID)
);