/****** Object:  UserDefinedFunction [dbo].[getlocaldate2]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[getlocaldate2]()
returns datetime2
as
begin
--   return convert(datetime2, CONVERT(datetimeoffset, CURRENT_TIMESTAMP) AT TIME ZONE (select isnull(valor, valor_padrao) from core_parametros where nome = 'TIMEZONE_NAME'));
   return convert(datetime2, CONVERT(datetimeoffset, CURRENT_TIMESTAMP) AT TIME ZONE 'E. South America Standard Time');
end
GO
