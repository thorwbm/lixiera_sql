--USE avaliacao_educat

--- COPIAR OS DADOS DO OUTRO BANCO
--EXEC SP_COPIAR_TABELA_IMPORTACAO

-- CURSOR QUE RODA APRA CADA AVALIACAO A SER IMPORTADA 
declare @AVALIACAO_EXT_ID INT, @ID_DISCIPLINA int, @ID_CURSO int, @ID_PERIODO int,
        @DATA_APLICACAO datetime, @ID_INSTITUICAO int, @NR_RESPONDENTES int

declare CUR_sae cursor for
----------------------------------------------------------------------------------------------
	select distinct 
               avaliacao_id, curso_id, periodo_id, data_aplicacao, 
               instituicao_id, id_disciplina, qtd_participante
			   --, grade_nome as periodo_nome
			   --, curso_nome, grade_nome as periodo_nome, instituicao_nome, disciplina_nome
               into tmp_importacao_090520
          from 
               VW_SAE_PARAMENTRO_IMPORTACAO 
			   -- FILTRO POR PERIODO
			 --  where grade_nome = '7º ano'
---------------------------------------------------------------------------------------------
	open CUR_sae 
		fetch next from CUR_sae into @AVALIACAO_EXT_ID, @ID_CURSO, @ID_PERIODO, @DATA_APLICACAO, 
                                     @ID_INSTITUICAO, @ID_DISCIPLINA, @NR_RESPONDENTES
		while @@FETCH_STATUS = 0
			BEGIN
				exec sp_carga_prova_sae @AVALIACAO_EXT_ID, @ID_DISCIPLINA, @ID_CURSO, @ID_PERIODO, @DATA_APLICACAO, @ID_INSTITUICAO, @NR_RESPONDENTES  
			

				fetch next from CUR_sae into @AVALIACAO_EXT_ID, @ID_CURSO, @ID_PERIODO, @DATA_APLICACAO, 
										 @ID_INSTITUICAO, @ID_DISCIPLINA, @NR_RESPONDENTES
			END
	close CUR_sae 
deallocate CUR_sae 
