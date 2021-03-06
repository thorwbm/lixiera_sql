USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[SP_MESCLAR_DISCIPLINA]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_MESCLAR_DISCIPLINA @disciplina_atual, @disciplina_destino

--select * from vw_tabela_coluna where coluna = 'disciplina_id'
--select * from academico_disciplina where nome ='ABORDAGEM FISIOTERAPÊUTICA NAS DOENÇAS CEREBRAIS MAIS PREVALENTES' --	5242

-- commit
-- rollback

CREATE   PROCEDURE [dbo].[SP_MESCLAR_DISCIPLINA] @disciplina_atual int, @disciplina_destino int, @razao varchar(200) AS

DECLARE @ID_AUX int
DECLARE @ATRIBUTOS VARCHAR(MAX)
DECLARE @DATA_ALTERECAO DATETIME
DECLARE @TABELA VARCHAR(500)



SET @ATRIBUTOS =  DBO.FN_GERAR_JSON_UPDATE('disciplina_id;'+ CONVERT(VARCHAR(10), @disciplina_atual)+';' + CONVERT(VARCHAR(10),@disciplina_destino ))

BEGIN TRY
begin tran 
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'academico_turmadisciplina'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from academico_turmadisciplina tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from academico_turmadisciplina tdsx 
							where tdsx.turma_id = tds.turma_id and 
								  tdsx.disciplina_id = @disciplina_destino) 
								  
		-- ******* GERAR LOG  academico_turmadisciplina   ******
		declare CUR_TDP cursor for 
			SELECT id FROM academico_turmadisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_TDP 
				fetch next from CUR_TDP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
						PRINT 'TPD'
					fetch next from CUR_TDP into @ID_AUX
					END
			close CUR_TDP 
		deallocate CUR_TDP
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  academico_turmadisciplina  DELECAO ******
		declare CUR_TDP_DEL cursor for 
			SELECT ID from academico_turmadisciplina   
             where disciplina_id = @disciplina_atual    

			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						 EXEC SP_GERAR_LOG 'academico_turmadisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
						PRINT 'TPD DELL'
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM academico_turmadisciplina WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'materiais_didaticos_publicacao'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from materiais_didaticos_publicacao tds 
		 where disciplina_id = @disciplina_atual 		 
		-- ******* GERAR LOG  academico_turmadisciplina   ******
		declare CUR_MDPX cursor for 
			SELECT id FROM materiais_didaticos_publicacao 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_MDPX 
				fetch next from CUR_MDPX into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'materiais_didaticos_publicacao', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_MDPX into @ID_AUX
					END
			close CUR_MDPX 
		deallocate CUR_MDPX
		-- ******* GERAR LOG FIM ******
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'historicos_historicodisciplina'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from historicos_historicodisciplina tds 
		 where disciplina_id = @disciplina_atual 	
		 
		-- ******* GERAR LOG  academico_turmadisciplina   ******
		declare CUR_HDS cursor for 
			SELECT id FROM historicos_historicodisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_HDS 
				fetch next from CUR_HDS into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'historicos_historicodisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_HDS into @ID_AUX
					END
			close CUR_HDS 
		deallocate CUR_HDS
		-- ******* GERAR LOG FIM ******
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'curriculos_gradedisciplina'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from curriculos_gradedisciplina tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from curriculos_gradedisciplina tdsx 
							where tdsx.grade_id = tds.grade_id and 
								  tdsx.disciplina_id = @disciplina_destino)
								  
		-- ******* GERAR LOG  CURRICULOS_GRADEDISCIPLINA   ******
		declare CUR_GDS cursor for 
			SELECT id FROM curriculos_gradedisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_GDS 
				fetch next from CUR_GDS into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'curriculos_gradedisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_GDS into @ID_AUX
					END
			close CUR_GDS 
		deallocate CUR_GDS
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  CURRICULOS_GRADEDISCIPLINA  DELECAO ******
		declare CUR_GDS_DEL cursor for 
			SELECT ID from curriculos_gradedisciplina   
             where disciplina_id = @disciplina_atual    

			open CUR_GDS_DEL 
				fetch next from CUR_GDS_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'curriculos_gradedisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_GDS_DEL into @ID_AUX
					END
			close CUR_GDS_DEL 
		deallocate CUR_GDS_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM curriculos_gradedisciplina WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'historicos_historico'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from historicos_historico tds 
		 where disciplina_id = @disciplina_atual 
		 
		-- ******* GERAR LOG  HISTORICOS_HISTORICO   ******
		declare CUR_HIS cursor for 
			SELECT id FROM historicos_historico 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_HIS 
				fetch next from CUR_HIS into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'historicos_historico', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_HIS into @ID_AUX
					END
			close CUR_HIS 
		deallocate CUR_HIS
		-- ******* GERAR LOG FIM ******
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'academico_responsaveldisciplina'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from academico_responsaveldisciplina tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from academico_responsaveldisciplina tdsx 
							where tdsx.curso_id = tds.curso_id and
							      tdsx.professor_id = tds.professor_id  and
								  tdsx.disciplina_id = @disciplina_destino)
								  
		-- ******* GERAR LOG  ACADEMICO_RESPONSAVELDISCIPLINA   ******
		declare CUR_RES cursor for 
			SELECT id FROM academico_responsaveldisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_RES 
				fetch next from CUR_RES into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_responsaveldisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_RES into @ID_AUX
					END
			close CUR_RES 
		deallocate CUR_RES
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  ACADEMICO_RESPONSAVELDISCIPLINA  DELECAO ******
		declare CUR_RES_DEL cursor for 
			SELECT ID from academico_responsaveldisciplina   
             where disciplina_id = @disciplina_atual    

			open CUR_RES_DEL 
				fetch next from CUR_RES_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_responsaveldisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_RES_DEL into @ID_AUX
					END
			close CUR_RES_DEL 
		deallocate CUR_RES_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM academico_responsaveldisciplina WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'cronogramas_cronograma'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from cronogramas_cronograma tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from cronogramas_cronograma tdsx 
							where tdsx.curso_id = tds.curso_id and
							      tdsx.etapa_ano_id = tds.etapa_ano_id  and
								  tdsx.disciplina_id = @disciplina_destino)
								  
		-- ******* GERAR LOG  CRONOGRAMAS_CRONOGRAMA   ******
		declare CUR_CRO cursor for 
			SELECT id FROM cronogramas_cronograma 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_CRO 
				fetch next from CUR_CRO into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'cronogramas_cronograma', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_CRO into @ID_AUX
					END
			close CUR_CRO 
		deallocate CUR_CRO
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  CRONOGRAMAS_CRONOGRAMA  DELECAO ******
		declare CUR_CRO_DEL cursor for 
			SELECT ID from cronogramas_cronograma   
             where disciplina_id = @disciplina_atual    

			open CUR_CRO_DEL 
				fetch next from CUR_CRO_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'cronogramas_cronograma', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_CRO_DEL into @ID_AUX
					END
			close CUR_CRO_DEL 
		deallocate CUR_CRO_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM cronogramas_cronograma WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'curriculos_disciplinaconcluida'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from curriculos_disciplinaconcluida tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from curriculos_disciplinaconcluida tdsx 
							where tdsx.curriculo_aluno_id = tds.curriculo_aluno_id and
							      tdsx.etapa_ano_id = tds.etapa_ano_id  and
								  tdsx.disciplina_id = @disciplina_destino and 
								  tdsx.nota          = tds.nota)
								  
		-- ******* GERAR LOG  CURRICULOS_DISCIPLINACONCLUIDA   ******
		declare CUR_CON cursor for 
			SELECT id FROM curriculos_disciplinaconcluida 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_CON 
				fetch next from CUR_CON into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'curriculos_disciplinaconcluida', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_CON into @ID_AUX
					END
			close CUR_CON 
		deallocate CUR_CON
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  CURRICULOS_DISCIPLINACONCLUIDA  DELECAO ******
		declare CUR_CON_DEL cursor for 
			SELECT ID from curriculos_disciplinaconcluida   
             where disciplina_id = @disciplina_atual    

			open CUR_CON_DEL 
				fetch next from CUR_CON_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'curriculos_disciplinaconcluida', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_CON_DEL into @ID_AUX
					END
			close CUR_CON_DEL 
		deallocate CUR_CON_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM curriculos_disciplinaconcluida WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'planos_ensino_planoensino'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from planos_ensino_planoensino tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from planos_ensino_planoensino tdsx 
							where tdsx.etapa_ano_id = tds.etapa_ano_id and 
								  tdsx.ano          = tds.ano and
								  tdsx.disciplina_id = @disciplina_destino )
								  
		-- ******* GERAR LOG  PLANOS_ENSINO_PLANOENSINO   ******
		declare CUR_PLA cursor for 
			SELECT id FROM planos_ensino_planoensino 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_PLA 
				fetch next from CUR_PLA into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'planos_ensino_planoensino', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_PLA into @ID_AUX
					END
			close CUR_PLA 
		deallocate CUR_PLA
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  PLANOS_ENSINO_PLANOENSINO  DELECAO ******
		declare CUR_PLA_DEL cursor for 
			SELECT ID from planos_ensino_planoensino   
             where disciplina_id = @disciplina_atual    

			open CUR_PLA_DEL 
				fetch next from CUR_PLA_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'planos_ensino_planoensino', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_PLA_DEL into @ID_AUX
					END
			close CUR_PLA_DEL 
		deallocate CUR_PLA_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM planos_ensino_planoensino WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'curriculos_errofechamentodisciplina'
		update tds set tds.disciplina_id = @disciplina_destino, tds.atualizado_em = @DATA_ALTERECAO, tds.atualizado_por = 2136
		 from curriculos_errofechamentodisciplina tds 
		 where disciplina_id = @disciplina_atual and 
			   not exists (select 1 from curriculos_errofechamentodisciplina tdsx 
							where tdsx.aluno_id = tds.aluno_id and 
								  tdsx.disciplina_id = @disciplina_destino )
								  
		-- ******* GERAR LOG  CURRICULOS_ERROFECHAMENTODISCIPLINA   ******
		declare CUR_ERR cursor for 
			SELECT id FROM curriculos_errofechamentodisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  disciplina_id = @disciplina_destino  

			open CUR_ERR 
				fetch next from CUR_ERR into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'curriculos_errofechamentodisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_ERR into @ID_AUX
					END
			close CUR_ERR 
		deallocate CUR_ERR
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  CURRICULOS_ERROFECHAMENTODISCIPLINA  DELECAO ******
		declare CUR_ERR_DEL cursor for 
			SELECT ID from curriculos_errofechamentodisciplina   
             where disciplina_id = @disciplina_atual    

			open CUR_ERR_DEL 
				fetch next from CUR_ERR_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'curriculos_errofechamentodisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_ERR_DEL into @ID_AUX
					END
			close CUR_ERR_DEL 
		deallocate CUR_ERR_DEL
		-- ******* GERAR LOG DELECAO FIM ******
		DELETE FROM curriculos_errofechamentodisciplina WHERE disciplina_id = @disciplina_atual
-- ##############################################################################################################
-- ##############################################################################################################
        SET @DATA_ALTERECAO = GETDATE()
		SET @TABELA = 'academico_disciplina'
		-- ******* GERAR LOG  CURRICULOS_ERROFECHAMENTODISCIPLINA  DELECAO ******
		declare CUR_DIS_DELX cursor for 
			SELECT ID from academico_disciplina   
             where id = @disciplina_atual    

			open CUR_DIS_DELX 
				fetch next from CUR_DIS_DELX into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_disciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
						PRINT 'DEL DISCIPLINA LOG'
					fetch next from CUR_DIS_DELX into @ID_AUX
					END
			close CUR_DIS_DELX 
		deallocate CUR_DIS_DELX
		-- ******* GERAR LOG DELECAO FIM ******
        
delete from academico_disciplina 
  where id = @disciplina_atual
-- ##############################################################################################################

insert into tmp_erro_higienizacao
SELECT @disciplina_atual, @disciplina_destino, @TABELA, 'DISCIPLINA_ID',GETDATE(), ERROR_MESSAGE(), 'ok'
COMMIT
END TRY 

BEGIN CATCH

ROLLBACK

insert into tmp_erro_higienizacao
SELECT @disciplina_atual, @disciplina_destino, @TABELA, 'DISCIPLINA_ID',GETDATE(), ERROR_MESSAGE(), 'erro'
END CATCH



-- select id_anterior = 0, id_novo = 0,  tabela = replicate('x',200), campo = replicate('x',200), data_processo = getdate(), erro = replicate('x',2900) into tmp_erro_higienizacao
-- select *  from tmp_erro_higienizacao

-- academico_turmadisciplina

-- materiais_didaticos_publicacao
-- historicos_historicodisciplina
-- curriculos_gradedisciplina
-- historicos_historico
-- ofertas_disciplina_ofertadisciplina----?????
-- curriculos_solicitacaodiscinformada  -- vazia 
-- academico_responsaveldisciplina
-- view_comparativo_turmadisciplina_gradedisciplina
-- cronogramas_cronograma
-- curriculos_disciplinaconcluida
-- planos_ensino_planoensino
-- curriculos_errofechamentodisciplina



--ANTROPOLOGIA *** 3861 -> 4197

-- SELECT * FROM academico_disciplina WHERE NOME = 'ANTROPOLOGIA'
GO
