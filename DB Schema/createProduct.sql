USE WareHouseManagementSystem;

CREATE TABLE Product(
    productId INT NOT NULL,
    categoryId INT NOT NULL,
    categoryTitle VARCHAR(20) NOT NULL,
    FOREIGN KEY (categoryId, categoryTitle) REFERENCES ProductCategory(categoryId, title),
    title VARCHAR(20) NOT NULL,
    summary TEXT NULL DEFAULT NULL,
    productType INT NOT NULL DEFAULT 0,
    content TEXT NULL DEFAULT NULL,
    createdAt DATETIME NOT NULL,
    updatedAt DATETIME NULL DEFAULT NULL,
    PRIMARY KEY(productId)
    );
