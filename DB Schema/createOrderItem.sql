USE WareHouseManagementSystem;

CREATE TABLE OrderItem(
    OrderItemId INT NOT NULL,
    productId INT NOT NULL,
    orderId INT NOT NULL,
    title VARCHAR(20) NOT NULL,
    sku VARCHAR(100) NOT NULL,
    price FLOAT NOT NULL DEFAULT 0,
    discount FLOAT NOT NULL DEFAULT 0,
    quantity INT NOT NULL,
    createdAt DATETIME NOT NULL,
    updatedAt DATETIME NULL DEFAULT NULL,
    content TEXT NULL DEFAULT NULL,
    FOREIGN KEY(productId) REFERENCES Product(productId),
    FOREIGN KEY(orderId) REFERENCES Order(orderId),
    FOREIGN KEY(OrderItemId) REFERENCES StockItem(itemId),
    PRIMARY KEY (OrderItemId)
);