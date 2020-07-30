/* For security reasons the login is created disabled and with a random password. */
CREATE LOGIN [luis.tibana] WITH PASSWORD=N'd7f5c20377ce73bdbf8e@5537c9790485&81e9a'
GO

ALTER ROLE db_owner ADD MEMBER [luis.tibana]; 
go


-- **** criar usuario em cada base 
CREATE USER [luis.tibana]
	FOR LOGIN [luis.tibana]
GO
-- Add user to the database owner role
EXEC sp_addrolemember N'db_owner', N'luis.tibana'
GO




EXEC sp_addrolemember N'db_securityadmin', N'luis.tibana'  
EXEC sp_addrolemember N'db_accessadmin', N'luis.tibana'    
EXEC sp_addrolemember N'db_backupoperator', N'luis.tibana' 
EXEC sp_addrolemember N'db_ddladmin', N'luis.tibana' 
