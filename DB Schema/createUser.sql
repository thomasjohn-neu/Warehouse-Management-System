   CREATE TABLE Users(
    userID INT NOT NULL,
    firstName VARCHAR(20) NOT NULL,
	middleName VARCHAR(20),
    lastName VARCHAR(20),
	username VARCHAR(20),
    email VARCHAR(50),
	phoneNumber CHAR(10) NOT NULL,
	registeredAt DATETIME NOT NULL,
	lastLogin DATETIME NOT NULL,
    PRIMARY KEY(userID)
);