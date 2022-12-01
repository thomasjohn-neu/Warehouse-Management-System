USE WareHouseManagementSystem;

-- Constraint to validate email id
ALTER TABLE [User]
ADD CONSTRAINT EmailCheck  CHECK(email LIKE '%___@___%.__%')

-- Constraint to prevent duplicate username
ALTER TABLE [User] 
ADD CONSTRAINT [IX_UniqueUserName] UNIQUE NONCLUSTERED ([username] ASC)