create TABLE Delivery(
	deliveryID INT NOT NULL,
	orderID INT NOT NULL,
	addressID INT NOT NULL FOREIGN KEY REFERENCES Address(addressID),
	status VARCHAR(30) NOT NULL,
	FOREIGN KEY REFERENCES [WareHouseManagementSystem].[dbo].[Order](orderID),
	PRIMARY KEY(deliveryID)
);