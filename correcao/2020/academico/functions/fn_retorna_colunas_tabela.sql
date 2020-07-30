/**********************************************************************************************************************************
*                                                   FN_RETORNA_COLUNAS_TABELA                                                     *
*                                                                                                                                 *
*  FUNCAO QUE RECEBE COMO PARAMETRO O NOME DE UMA TABELA E RETORNA TODOS OS SEUS CAMPOS SEPARADOS POR VIRGULA                     *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
**********************************************************************************************************************************/

--  select dbo.fn_retorna_colunas_tabela('academico_aula')

create OR ALTER  function [dbo].[fn_retorna_colunas_tabela] (@tabela varchar(100)) 
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

