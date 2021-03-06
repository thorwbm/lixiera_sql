/****** Object:  UserDefinedFunction [dbo].[getlocaldate]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CRIAÇÃO DE FUNÇÃO PARA RETORNAR A DATA EM DETERMINADO TIMEZONE
create   function [dbo].[getlocaldate]()
returns datetime2
as
begin
   return convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) from core_parametros where nome = 'TIMEZONE_NAME'));
end

GO
