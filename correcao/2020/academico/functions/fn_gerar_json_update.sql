
/**********************************************************************************************************************************
*                                                    FN_GERAR_JSON_UPDATE                                                         *
*                                                                                                                                 *
*  FUNCAO QUE RECEBE UMA STRING DE CAMPOS COM SEUS VALORES ANTIGO E ATUAL E GERA UMA STRING NO FORMATO JSON USAR | (PIPE) PARA    *
*  SEPARAR OS CAMPOS E ; (PONTO E VIRGULA) PARA OS VALORES DO CAMPO ANTIGO E NOVO                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:07/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:07/01/2020 *
**********************************************************************************************************************************/

-- SELECT DBO.FN_GERAR_JSON_UPDATE('instituicao_ensino_medio_id;22671;22209')
CREATE OR ALTER  function [dbo].[fn_gerar_json_update] (@parametro varchar(max))  
   RETURNS VARCHAR(MAX) AS 
BEGIN 
declare @linha     varchar(max)
declare @RETORNO   varchar(max)
declare @campo     varchar(500)
declare @primeiro  int 
declare @contador  int 

set @primeiro = 1 
set @retorno = '{'
declare abc cursor for 
	select * from string_split (@parametro, '|') 
	open abc 
		fetch next from abc into @linha
		while @@FETCH_STATUS = 0
			BEGIN
			--#################################################
			    set @contador = 0
				declare abcx cursor for 
					select rtrim(ltrim(value)) from string_split (@linha, ';') 
					open abcx 
						fetch next from abcx into @campo
						while @@FETCH_STATUS = 0
							BEGIN
								if(@contador = 0)
									begin
										if(@primeiro = 1)
											begin
												set @retorno = @retorno + '"' + @campo + '": {"antigo": '
												set @primeiro = 0
											end
										else
											begin
												set @retorno = @retorno + ', ' +  @campo + ': {"antigo": ' 
											end
									end 
								if(@contador = 1)
									begin
										set @retorno = @retorno + @campo + ', "novo": ' 
									end 
								if(@contador = 2)
									begin
										set @retorno = @retorno + @campo + '}' 
									end 

								set @contador = @contador + 1
							fetch next from abcx into @campo
							END
					close abcx 
				deallocate abcx 

            --#################################################
			fetch next from abc into @linha
			END
	close abc 
deallocate abc 
set @retorno = @retorno + '}'
   RETURN @RETORNO 
END 
GO

