USE WareHouseManagementSystem;

CREATE TABLE Category(
    categoryId INT NOT NULL PRIMARY KEY,
    title VARCHAR(20) NOT NULL,
    metaTitle VARCHAR(30) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    content VARCHAR(500) NOT NULL,
);
