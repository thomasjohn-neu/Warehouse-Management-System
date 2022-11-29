USE WareHouseManagementSystem;

CREATE TABLE ProductCategory(
    categoryId INT NOT NULL,
    title VARCHAR(20) NOT NULL,
    FOREIGN KEY(categoryId, title) REFERENCES Category (categoryId, title),
);
