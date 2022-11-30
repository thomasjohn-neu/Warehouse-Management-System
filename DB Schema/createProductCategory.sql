USE WareHouseManagementSystem;

CREATE TABLE ProductCategory(
    categoryId INT NOT NULL,
    productId INT NOT NULL,
    FOREIGN KEY(categoryId) REFERENCES Category (categoryId),
    FOREIGN KEY(productId) REFERENCES Product (productId),
);
