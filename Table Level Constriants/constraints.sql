USE WareHouseManagementSystem;

-- Constraint to validate email id
ALTER TABLE [User]
ADD CONSTRAINT EmailCheck  CHECK(email LIKE '%___@___%.__%')