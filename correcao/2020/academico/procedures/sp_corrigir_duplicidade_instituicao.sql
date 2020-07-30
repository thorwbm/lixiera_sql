/**********************************************************************************************************************************
*                                              SP_CORRIGIR_DUPLICIDADE_INSTITUICAO                                                *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O NOME DE UMA INSTITUICAO E CASO ELA ESTEJA DUPLICADA NO BANCO ELAS SERAO UNIFICADAS COM O CODIGO DE MENO *
*  EXPRESSAO                                                                                                                      *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
**********************************************************************************************************************************/

CREATE OR ALTER  procedure sp_corrigir_duplicidade_instituicao @instituticao_nome varchar(max), @cidade_id int as 

DECLARE @ATUAL INT, @NOVO INT, @AUXILIAR INT , @AUX VARCHAR(1000), @INSTITUICAO_ID int

-- **** drop a tabela temporaria se existir ****
If Exists(Select * from Tempdb..SysObjects Where Name Like '#tmp_remover%')
drop table #tmp_remover

select  @instituicao_id = min(id) 
  from core_instituicao 
 where nome like @instituticao_nome and 
       cidade_id = @cidade_id

-- **** monto a lista das duplicidades com o codigo das duplicidades que serao substituidas e o codigo que ira permanecer ****
select  id as codigo_remover, @instituicao_id as novo_codigo 
  into #tmp_remover 
  from core_instituicao 
 where nome = @instituticao_nome and
       cidade_id = @cidade_id and 
       id <> @instituicao_id

begin tran 
	BEGIN TRY

		SET @AUXILIAR = 0

		-- **** corro a lista de duplicidades 
		declare abc_INST cursor for 
			SELECT codigo_remover, novo_codigo FROM #tmp_remover
			open abc_INST 
				fetch next from abc_INST into @ATUAL, @NOVO
				while @@FETCH_STATUS = 0
					BEGIN				
						update tab set tab.instituicao_ensino_medio_id = @NOVO 
						  from historicos_historico tab WHERE tab.instituicao_ensino_medio_id = @ATUAL
						--  **** GERAR LOG
						SET @AUX = ( 'instituicao_ensino_medio_id;' + CONVERT(VARCHAR(10),@ATUAL) + ';'+ CONVERT(VARCHAR(10),@NOVO))
						declare CUR_HIST cursor for 
							SELECT  ID FROM historicos_historico WHERE instituicao_ensino_medio_id  = @ATUAL 
							open CUR_HIST 
								fetch next from CUR_HIST into @AUXILIAR
								while @@FETCH_STATUS = 0
									BEGIN
										EXEC SP_GERAR_LOG 'historicos_historico', @AUXILIAR, '~', 2137,@AUX, NULL, NULL
									fetch next from CUR_HIST into @AUXILIAR
									END
							close CUR_HIST 
						deallocate CUR_HIST
						SET @AUXILIAR = 0
						--  **** GERAR LOG FIM
						
						update tab set tab.instituicao_id = @NOVO 
						  from academico_pessoa_titulacao tab  WHERE tab.instituicao_id = @ATUAL 
						--  **** GERAR LOG
						SET @AUX = ( 'instituicao_id;' + CONVERT(VARCHAR(10),@ATUAL) + ';'+ CONVERT(VARCHAR(10),@NOVO))
						declare CUR_TITULACAO cursor for 
							SELECT  ID FROM academico_pessoa_titulacao WHERE instituicao_id  = @ATUAL 
							open CUR_TITULACAO 
								fetch next from CUR_TITULACAO into @AUXILIAR
								while @@FETCH_STATUS = 0
									BEGIN
										EXEC SP_GERAR_LOG 'academico_pessoa_titulacao', @AUXILIAR, '~', 2137,@AUX, NULL, NULL
									fetch next from CUR_TITULACAO into @AUXILIAR
									END
							close CUR_TITULACAO 
						deallocate CUR_TITULACAO
						SET @AUXILIAR = 0
						--  **** GERAR LOG FIM
  
						update tab set tab.instituicao_id = @NOVO 
						  from academico_alunodisciplinainformada TAB WHERE tab.instituicao_id = @ATUAL
						--  **** GERAR LOG
						--SET @AUX = ( 'instituicao_id;' + CONVERT(VARCHAR(10),@ATUAL) + ';'+ CONVERT(VARCHAR(10),@NOVO))
						--declare CUR_DISINFORMADA cursor for 
						--	SELECT  ID FROM academico_alunodisciplinainformada WHERE instituicao_id  = @ATUAL 
						--	open CUR_DISINFORMADA 
						--		fetch next from CUR_DISINFORMADA into @AUXILIAR
						--		while @@FETCH_STATUS = 0
						--			BEGIN
						--				EXEC SP_GERAR_LOG 'academico_alunodisciplinainformada', @AUXILIAR, '~', 2137,@AUX, NULL, NULL
						--			fetch next from CUR_DISINFORMADA into @AUXILIAR
						--			END
						--	close CUR_DISINFORMADA 
						--deallocate CUR_DISINFORMADA
						--SET @AUXILIAR = 0
						--  **** GERAR LOG FIM 
  
						update tab set tab.instituicao_id = @NOVO 
						  from curriculos_disciplinainformada tab WHERE tab.instituicao_id = @ATUAL 
						--  **** GERAR LOG
						SET @AUX = ( 'instituicao_id;' + CONVERT(VARCHAR(10),@ATUAL) + ';'+ CONVERT(VARCHAR(10),@NOVO))
						declare CUR_DISINF cursor for 
							SELECT  ID FROM curriculos_disciplinainformada WHERE instituicao_id  = @ATUAL 
							open CUR_DISINF 
								fetch next from CUR_DISINF into @AUXILIAR
								while @@FETCH_STATUS = 0
									BEGIN
										EXEC SP_GERAR_LOG 'curriculos_disciplinainformada', @AUXILIAR, '~', 2137,@AUX, NULL, NULL
									fetch next from CUR_DISINF into @AUXILIAR
									END
							close CUR_DISINF 
						deallocate CUR_DISINF
						SET @AUXILIAR = 0
						--  **** GERAR LOG FIM 
  
						-- **** deletar  ****
						--  **** GERAR LOG
						SELECT @AUXILIAR = ID FROM core_instituicao WHERE ID  = @ATUAL
						EXEC SP_GERAR_LOG core_instituicao, @AUXILIAR, '-', 2137, NULL, NULL, NULL
						SET @AUXILIAR = 0
						--  **** GERAR LOG FIM 
						delete ins
						from core_instituicao ins WHERE ins.id = @ATUAL


					fetch next from abc_INST into @ATUAL, @NOVO
					END
			close abc_INST 
		deallocate abc_INST 

		COMMIT 

	END TRY 
	BEGIN CATCH
	    close abc_INST 
		deallocate abc_INST 

		ROLLBACK
		PRINT 'DEU RUIM'
		PRINT ERROR_MESSAGE()
	END CATCH

