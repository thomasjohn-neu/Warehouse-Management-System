create TABLE Delivery(
	deliveryID INT NOT NULL PRIMARY KEY,
	orderID INT NOT NULL FOREIGN KEY REFERENCES [WareHouseManagementSystem].[dbo].[Order](orderID),
	addressID INT NOT NULL FOREIGN KEY REFERENCES Address(addressID),
	status VARCHAR(30) NOT NULL
);