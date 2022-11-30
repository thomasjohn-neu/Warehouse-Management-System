create TABLE Delivery(
	deliveryID INT NOT NULL,
	orderID INT NOT NULL,
	addressID INT NOT NULL,
	status VARCHAR(30) NOT NULL,
	FOREIGN KEY(orderID) REFERENCES [WareHouseManagementSystem].[dbo].[Order](orderID),
	FOREIGN KEY(addressID) REFERENCES [Address](addressID),
	PRIMARY KEY(deliveryID)
);