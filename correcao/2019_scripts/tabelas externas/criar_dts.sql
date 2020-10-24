
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'STRONGP@SSWORD124321';
GO
CREATE DATABASE SCOPED CREDENTIAL CRED_Azure_Login
WITH IDENTITY = 'admin-correcao', SECRET = 'STRONGP@SSWORD124321' -- this user needs to  have sufficient rights on the test2 db.
GO




CREATE LOGIN ExternalTableAdministrator WITH PASSWORD = 'Nr26MY4@Q407inLE83[I7L$~5j5UL';

CREATE DATABASE SCOPED CREDENTIAL [ExternalTableCred]
    WITH IDENTITY = 'ExternalTableAdministrator',
    SECRET = 'Nr26MY4@Q407inLE83[I7L$~5j5UL';


/****** Object:  ExternalDataSource [InepDS]    Script Date: 14/10/2019 09:27:05 ******/
CREATE EXTERNAL DATA SOURCE [dts_correcao_regular] WITH (TYPE = RDBMS, LOCATION = N'correcao-redacoes2019-sqlpool-01.database.windows.net', CREDENTIAL = CRED_Azure_Login, DATABASE_NAME = N'enemregular-correcao_regular')
GO


CREATE DATABASE SCOPED CREDENTIAL CRDMEntrega
WITH IDENTITY = 'admin-correcao',
SECRET = '3dc4R4t$#2s%thR2019';
GO

CREATE EXTERNAL DATA SOURCE DTS_Correcao
 WITH (
 TYPE=RDBMS,
 LOCATION='correcao-redacoes2019-sqlpool-01.database.windows.net',
 DATABASE_NAME='enemregular-correcao_regular',
 CREDENTIAL = CRDMEntrega
);

select * from [correcoes_redacao]


 