/****** Object:  ExternalDataSource [InepDS]    Script Date: 14/10/2019 09:27:05 ******/
CREATE EXTERNAL DATA SOURCE [InepDS] WITH (TYPE = RDBMS, LOCATION = N'enccejaregular.database.windows.net', CREDENTIAL = [enem], DATABASE_NAME = N'inep_regular')
GO


