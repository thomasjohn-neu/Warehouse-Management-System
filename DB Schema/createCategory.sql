USE WareHouseManagementSystem;

CREATE TABLE Category(
    categoryId INT NOT NULL,
    title VARCHAR(20) NOT NULL,
    metaTitle VARCHAR(30) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    content TEXT NULL DEFAULT NULL,
    PRIMARY KEY (categoryId)
);