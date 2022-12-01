USE WareHouseManagementSystem;

-- Constraint to validate email id for User
ALTER TABLE [User]
ADD CONSTRAINT EmailCheck  CHECK(email LIKE '%___@___%.__%')

-- Constraint to prevent duplicate username
ALTER TABLE [User] 
ADD CONSTRAINT [IX_UniqueUserName] UNIQUE NONCLUSTERED ([username] ASC)

-- Contraint to validate email id for supplier
ALTER TABLE [Supplier]
ADD CONSTRAINT SupplierEmailCheck  CHECK(email LIKE '%___@___%.__%')