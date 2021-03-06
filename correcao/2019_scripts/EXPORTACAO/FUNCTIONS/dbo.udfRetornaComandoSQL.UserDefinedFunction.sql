/****** Object:  UserDefinedFunction [dbo].[udfRetornaComandoSQL]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[udfRetornaComandoSQL](@spid AS INT)

RETURNS VARCHAR(8000)

AS

BEGIN

DECLARE @comandoSQL VARCHAR(8000)

SET @comandoSQL = (SELECT CAST([TEXT] AS VARCHAR(8000))

FROM ::fn_get_sql((SELECT [sql_handle] FROM sysprocesses where spid = @spid)))

RETURN @comandoSQL

END
GO
