/**********************************************************************************************************************************
*                                                     SP_BUSCAR_CAMPO_VALOR                                                       *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE NOME DO CAMPO, VALOR E TIPO E FAZ UMA BUSCA EM TODAS AS TABELAS DO BANCO QUE POSSUEM ESTE CAMPO E INFORMA *
* QUANTOS REGISTROS CORRESPONDEM AO VALOR INFORMADO. NO CASO DO CAMPO SER VARCHAR SERA FEITA UMA BUSCA COM LIKE.                  *
*  ##### TIPOS - IN, VARCHAR, DATE                                                                                                *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:21/02/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:21/02/2020 *
**********************************************************************************************************************************/

-- EXEC SP_BUSCAR_CAMPO_VALOR 'turma_disciplina_id', '18009', 'int'
CREATE OR ALTER PROCEDURE SP_BUSCAR_CAMPO_VALOR @campo varchar(100), @valor varchar(100), @tipovar varchar(20)
AS

declare @tabela varchar(100), @sql varchar(max), @count int 

-- TESTE DO TIPO DO  CAMPO A SER PROCURADO
if (@tipovar = 'date')
   begin 
		set @valor = ' = ' + char(39) + @valor + char(39)
   end
else if (@tipovar ='varchar')
	 begin 
		set @valor = ' like ' + char(39) + '%' + @valor + '%' + char(39)
   end
else if (@tipovar ='int')
	 begin 
		set @valor = ' = '  + @valor 
   end

-- CRIACAO DA TABELA TEMPORARIA
IF object_id('tempdb..#temp') IS NOT NULL  DROP TABLE #temp
CREATE TABLE #temp (tabela varchar(200), campo varchar(200), qtd_registro int)

declare CUR_ cursor for 
	select tabela 
  from vw_tabela_coluna 
  where coluna = @campo
	open CUR_ 
		fetch next from CUR_ into @tabela
		while @@FETCH_STATUS = 0
			BEGIN				
			    -- INSERE NA TAMBELA TEMPORARIA
				set @sql = 'insert into #temp select distinct ' + char(39) + @tabela  + char(39) +  ',' + char(39) + @campo  + char(39) +  ', count(1) from ' + @tabela + ' where ' + @campo +  @valor
				exec (@sql) 				

			fetch next from CUR_ into @tabela
			END
	close CUR_ 
deallocate CUR_ 

-- RETORNA TODAS AS TABELAS E A QUANTIDADE DE REGISTROS PARA O VALOR INFORMADO
select * from  #temp
 
 --#############################################################################################################
 -- ESTA PROCEDURE PRECISA DESTA VIEW PARA FUNCIONAR 
 /*

create view [dbo].[vw_tabela_coluna] as   
SELECT table_name as tabela, column_name as coluna FROM INFORMATION_SCHEMA.COLUMNS  
WHERE (TABLE_NAME NOT LIKE 'LOG_%' AND    
    TABLE_NAME NOT LIKE 'TMP%' AND   
    TABLE_NAME NOT LIKE 'BKP%' AND   
    TABLE_NAME NOT LIKE 'VW_%' ) 
GO

 */