CREATE TABLE TransactionType(
    transactionTypeID INT NOT NULL PRIMARY KEY,
    transactionDescription VARCHAR(50)
);

create TABLE "Transaction"(
	transactionID INT NOT NULL PRIMARY KEY,
	orderID INT NOT NULL FOREIGN KEY REFERENCES Order(orderID),
	transactionTypeID INT FOREIGN KEY REFERENCES TransactionType(transactionTypeID),
	charges FLOAT,
	code INT,
	mode VARCHAR(20),
	status VARCHAR(30),
	content VARCHAR(MAX)
);