/****** Object:  UserDefinedFunction [dbo].[getlocaldate3]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getlocaldate3]()
returns table
as return (
  select top 1 convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) as dt from core_parametros where nome = 'TIMEZONE_NAME')) as dt
);
GO
