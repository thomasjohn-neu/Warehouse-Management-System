   CREATE TABLE Users(
    userID INT NOT NULL PRIMARY KEY,
    firstName VARCHAR(20) NOT NULL,
	middleName VARCHAR(20),
    lastName VARCHAR(20),
	username VARCHAR(20),
    email VARCHAR(50),
	phoneNumber CHAR(10) NOT NULL,
	registeredAt DATETIME,
	lastLogin DATETIME
);