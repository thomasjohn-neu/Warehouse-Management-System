USE WareHouseManagementSystem;

CREATE TABLE ProductMeta(
    metaId INT NOT NULL,
    productId INT NOT NULL,
    [key] VARCHAR(50) NOT NULL, 
    content TEXT NULL DEFAULT NULL,
    FOREIGN KEY(productId) REFERENCES Product (productId),
    PRIMARY KEY (metaId)
);