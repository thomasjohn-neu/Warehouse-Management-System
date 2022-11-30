CREATE TABLE Address(
    addressID INT NOT NULL PRIMARY KEY,
	orderID INT NOT NULL,
    [address] VARCHAR(MAX) NOT NULL,
    city VARCHAR(20) NOT NULL,
	[state] VARCHAR(15) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	[country] VARCHAR(15) NOT NULL,
	FOREIGN KEY(orderID) REFERENCES [WareHouseManagementSystem].[dbo].[Order](orderId)
);