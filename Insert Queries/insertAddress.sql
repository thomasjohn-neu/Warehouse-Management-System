USE WareHouseManagementSystem;

INSERT INTO [Address] (addressId, userId, [address], city, [state], zipCode, country, createdAt)
VALUES
(1, 1, '151 East Cottage', 'Boston', 'MA', '02125', 'US', CURRENT_TIMESTAMP ),
(2, 2, '12 Burr Street', 'Boston', 'MA', '02130', 'US', CURRENT_TIMESTAMP),
(3, 3, '34 Ruggles St', 'Boston', 'MA', '02230', 'US', CURRENT_TIMESTAMP),
(4, 4, '15 Chinatown', 'Boston', 'MA', '02222', 'US', CURRENT_TIMESTAMP),
(5, 5, '12 Wasinghton St', 'New York City', 'NY', '01130', 'US', CURRENT_TIMESTAMP),
(6, 6, '587 W Cottage St', 'Boston', 'MA', '02126', 'US', CURRENT_TIMESTAMP),
(7, 7, '77 Columbia Rd', 'Boston', 'MA', '02221', 'US', CURRENT_TIMESTAMP),
(8, 8, '87 MLKJ Blvd', 'Boston', 'MA', '02765', 'US', CURRENT_TIMESTAMP),
(9, 9, '12 Stony Brk', 'Boston', 'MA', '02776', 'US', CURRENT_TIMESTAMP),
(10, 10, '45 Virginia St', 'Boston', 'MA', '02187', 'US', CURRENT_TIMESTAMP)