USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_retorna_colunas_tabela]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  select dbo.fn_retorna_colunas_tabela('academico_aula')

create   function [dbo].[fn_retorna_colunas_tabela] (@tabela varchar(100)) 
returns varchar(1000)
as 
begin 
    declare @cols nvarchar(max);
	with cte_temp as (
	SELECT distinct TABLE_NAME, COLUMN_NAME		 
		  FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = @tabela 
	)
	select  @cols = stuff((
		select distinct ',' 
		+ quotename(COLUMN_NAME) 
			from cte_temp for xml path('')
                  ), 1,1, '' )

	 return  replace(replace(@cols,'[',''),']','')
end 
GO
