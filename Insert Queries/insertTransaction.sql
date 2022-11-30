USE WareHouseManagementSystem;

INSERT INTO [Transaction](transactionId, paymentType, code, mode, [status], createdAt, updatedAt, content, charges) VALUES
(1, 'Credit_Card', 1122, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 1234.00),
(2, 'Debit_Card', 1123, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 234.00),
(3, 'Credit_Card', 1124, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 346.00),
(4, 'Net_Banking', 1125, 'COD', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Not Received', 364.00),
(5, 'Credit_Card', 1126, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 5234.00),
(6, 'Debit_Card', 1127, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 7234.00),
(7, 'Credit_Card', 1182, 'COD', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Not Received', 8234.00),
(8, 'Net_Banking', 1192, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 134.00),
(9, 'Debit_Card', 1120, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 34.00),
(10, 'Credit_Card', 1121, 'online', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Payment Received', 934.00);
