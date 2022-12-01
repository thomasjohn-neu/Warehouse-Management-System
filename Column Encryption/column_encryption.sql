--- ENCRYPTION

--Encryption on User Details

/*
COMMANDS TO DROP KEYS
DROP SYMMETRIC KEY user_Key_1;
DROP CERTIFICATE usercert;
DROP MASTER KEY;
*/

--CREATE MASTER KEY

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password2022$';

 -- CREATE CERTIFICATE
CREATE CERTIFICATE usercert WITH SUBJECT = 'User Indentity Details';


-- CREATE SYMMETRIC KEY
CREATE SYMMETRIC KEY user_Key_1
WITH ALGORITHM = AES_256  -- it can be AES_128,AES_192,DES etc
ENCRYPTION BY CERTIFICATE usercert;

--Encryption
ALTER TABLE [User] ADD FirstName_encrypt varbinary(MAX),MiddleName_encrypt varbinary(MAX),LastName_encrypt varbinary(MAX),
username_encrypt varbinary(MAX),Email_encrypt varbinary(MAX), PhoneNumber_encrypt varbinary(MAX)

OPEN SYMMETRIC KEY user_Key_1 DECRYPTION BY CERTIFICATE usercert;

UPDATE [User]
        SET FirstName_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), firstName)),
			MiddleName_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), middleName)),
		    LastName_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), lastName)),
			username_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(20), username)),
			Email_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(varchar(50), email)),
			PhoneNumber_encrypt = EncryptByKey (Key_GUID('user_Key_1'),CONVERT(char(10), phoneNumber))
        FROM [User];
GO

-- Close SYMMETRIC KEY
CLOSE SYMMETRIC KEY user_Key_1;
GO

--View encrypted data
SELECT FirstName_encrypt, LastName_encrypt,Email_encrypt , username_encrypt,
PhoneNumber_encrypt FROM [User];

--Dropping Old Columns 
ALTER TABLE [User] DROP COLUMN [firstName],[middleName], [lastName], [username], [email],[phoneNumber];


 --- Decryption
OPEN SYMMETRIC KEY user_Key_1 DECRYPTION BY CERTIFICATE usercert;

SELECT FirstName_encrypt, LastName_encrypt Email_encrypt ,username_encrypt,
PhoneNumber_encrypt,
CONVERT(varchar, DecryptByKey(FirstName_encrypt)) AS 'Decrypted Firstname',
CONVERT(varchar, DecryptByKey(LastName_encrypt)) AS 'Decrypted Lastname',
CONVERT(varchar, DecryptByKey(Email_encrypt)) AS 'Decrypted Email',
CONVERT(varchar, DecryptByKey(username_encrypt)) AS 'Decrypted Username',
CONVERT(varchar, DecryptByKey(PhoneNumber_encrypt)) AS 'Decrypted PhoneNumber'
FROM [User];

CLOSE SYMMETRIC KEY user_Key_1;
