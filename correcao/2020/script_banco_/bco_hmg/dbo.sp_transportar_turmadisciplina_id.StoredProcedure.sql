USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_transportar_turmadisciplina_id]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure [dbo].[sp_transportar_turmadisciplina_id] @turmaDisciplina_id_origem int, @turmaDisciplina_id_destino int , @razao varchar(200)  
as    

DECLARE @DATA_ALTERECAO DATETIME 
DECLARE @ID_AUX INT
DECLARE @ATRIBUTOS VARCHAR(MAX)
DECLARE @TABELA VARCHAR(200)

SET @ATRIBUTOS =  DBO.FN_GERAR_JSON_UPDATE('turma_disciplina_id;'+ CONVERT(VARCHAR(10), @turmaDisciplina_id_origem)+';' + CONVERT(VARCHAR(10),@turmaDisciplina_id_destino ))

begin try  
begin tran  
 -- ****** academico_turmadisciplinaprofessor ****  
  SET @DATA_ALTERECAO = GETDATE()
  SET @TABELA = 'academico_turmadisciplinaprofessor'
  insert into academico_turmadisciplinaprofessor (atributos,atualizado_em,atualizado_por,criado_em,criado_por,professor_id,tipo_id,turma_disciplina_id)  
  select atributos,atualizado_em = @DATA_ALTERECAO,atualizado_por = 2136,criado_em = @DATA_ALTERECAO,criado_por = 2136,professor_id,tipo_id,
         turma_disciplina_id = @turmaDisciplina_id_destino  
    from academico_turmadisciplinaprofessor tdp  
   where turma_disciplina_id = @turmaDisciplina_id_origem and   
         not exists (select 1 from academico_turmadisciplinaprofessor tdpx   
          where tdp.professor_id = tdpx.professor_id and   
             tdpx.turma_disciplina_id = @turmaDisciplina_id_destino)  
			 
		-- ******* GERAR LOG  ACADEMICO_TURMADISCIPLINAPROFESSOR   ******
		declare CUR_TDP cursor for 
			SELECT id FROM academico_turmadisciplinaprofessor 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_TDP 
				fetch next from CUR_TDP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplinaprofessor', @ID_AUX, '+', 2136, NULL, NULL, @razao
					fetch next from CUR_TDP into @ID_AUX
					END
			close CUR_TDP 
		deallocate CUR_TDP
		-- ******* GERAR LOG FIM ******
		-- ******* GERAR LOG  ACADEMICO_TURMADISCIPLINAPROFESSOR  DELECAO ******
		declare CUR_TDP_DEL cursor for 
			SELECT ID from academico_turmadisciplinaprofessor   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplinaprofessor', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
		-- ******* GERAR LOG DELECAO FIM ******
  delete from academico_turmadisciplinaprofessor   
   where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** academico_turmadisciplinaprofessor fim ****  

--############################################################################################################################################    
 -- ****** aulas_agendamento **** 
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'aulas_agendamento'

    update agd set agd.turma_disciplina_id = @turmaDisciplina_id_destino, agd.atualizado_em = @DATA_ALTERECAO, agd.atualizado_por = 2136  
    from aulas_agendamento agd  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from aulas_agendamento aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          isnull(aux.agendamento_id,0) = isnull(aux.agendamento_id,0))     
			 
		-- ******* GERAR LOG  AULAS_AGENDAMENTO   ******
		declare CUR_AGD cursor for 
			SELECT id FROM aulas_agendamento 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_AGD 
				fetch next from CUR_AGD into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'aulas_agendamento', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_AGD into @ID_AUX
					END
			close CUR_AGD 
		deallocate CUR_AGD
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  AULAS_AGENDAMENTO  DELECAO ******
		declare CUR_AGD_DEL cursor for 
			SELECT ID from aulas_agendamento   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_AGD_DEL 
				fetch next from CUR_AGD_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'aulas_agendamento', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_AGD_DEL into @ID_AUX
					END
			close CUR_AGD_DEL 
		deallocate CUR_AGD_DEL
		-- ******* GERAR LOG DELECAO FIM ******
  -- ***** deletar o que ficou de resto *****  
  delete from aulas_agendamento where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** aulas_agendamento fim ****  

--############################################################################################################################################     
 -- ****** materiais_didaticos_publicacao_turmadisciplina ****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'materiais_didaticos_publicacao_turmadisciplina'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from materiais_didaticos_publicacao_turmadisciplina dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from materiais_didaticos_publicacao_turmadisciplina aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          aux.publicacao_id = dpt.publicacao_id)      
			 
		-- ******* GERAR LOG  MATERIAIS_DIDATICOS_PUBLICACAO_TURMADISCIPLINA   ******
		declare CUR_MDPT cursor for 
			SELECT id FROM materiais_didaticos_publicacao_turmadisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_MDPT 
				fetch next from CUR_MDPT into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'materiais_didaticos_publicacao_turmadisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_MDPT into @ID_AUX
					END
			close CUR_MDPT 
		deallocate CUR_MDPT
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  MATERIAIS_DIDATICOS_PUBLICACAO_TURMADISCIPLINA  DELECAO ******
		declare CUR_MDPT_DEL cursor for 
			SELECT ID from materiais_didaticos_publicacao_turmadisciplina   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_MDPT_DEL 
				fetch next from CUR_MDPT_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'materiais_didaticos_publicacao_turmadisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_MDPT_DEL into @ID_AUX
					END
			close CUR_MDPT_DEL 
		deallocate CUR_MDPT_DEL
		-- ******* GERAR LOG DELECAO FIM ******  
  -- ***** deletar o que ficou de resto *****  
  delete from materiais_didaticos_publicacao_turmadisciplina where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** materiais_didaticos_publicacao_turmadisciplina fim ****  
 
--############################################################################################################################################  
 -- ****** atividades_protocolosegundachamadaprova **** 
	SET @DATA_ALTERECAO = GETDATE() 
    SET @TABELA = 'atividades_protocolosegundachamadaprova'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from atividades_protocolosegundachamadaprova dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from atividades_protocolosegundachamadaprova aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          aux.protocolo_id = dpt.protocolo_id)           
			 
		-- ******* GERAR LOG  ATIVIDADES_PROTOCOLOSEGUNDACHAMADAPROVA   ******
		declare CUR_PSCP cursor for 
			SELECT id FROM atividades_protocolosegundachamadaprova 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_PSCP 
				fetch next from CUR_PSCP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'atividades_protocolosegundachamadaprova', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_PSCP into @ID_AUX
					END
			close CUR_PSCP 
		deallocate CUR_PSCP
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  ATIVIDADES_PROTOCOLOSEGUNDACHAMADAPROVA  DELECAO ******
		declare CUR_PSCP_DEL cursor for 
			SELECT ID from atividades_protocolosegundachamadaprova   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_PSCP_DEL 
				fetch next from CUR_PSCP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'atividades_protocolosegundachamadaprova', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_PSCP_DEL into @ID_AUX
					END
			close CUR_PSCP_DEL 
		deallocate CUR_PSCP_DEL
		-- ******* GERAR LOG DELECAO FIM ****** 
  -- ***** deletar o que ficou de resto *****  
  delete from atividades_protocolosegundachamadaprova where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** atividades_protocolosegundachamadaprova fim ****  

--############################################################################################################################################  
 -- ****** atividades_criterio_turmadisciplina ****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'atividades_criterio_turmadisciplina'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from atividades_criterio_turmadisciplina dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from atividades_criterio_turmadisciplina aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          aux.criterio_id = dpt.criterio_id)           
			 
		-- ******* GERAR LOG  ATIVIDADES_CRITERIO_TURMADISCIPLINA   ******
		declare CUR_CTD cursor for 
			SELECT id FROM atividades_criterio_turmadisciplina 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_CTD 
				fetch next from CUR_CTD into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'atividades_criterio_turmadisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_CTD into @ID_AUX
					END
			close CUR_CTD 
		deallocate CUR_CTD
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  ATIVIDADES_CRITERIO_TURMADISCIPLINA  DELECAO ******
		declare CUR_CTD_DEL cursor for 
			SELECT ID from atividades_criterio_turmadisciplina   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_CTD_DEL 
				fetch next from CUR_CTD_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'atividades_criterio_turmadisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_CTD_DEL into @ID_AUX
					END
			close CUR_CTD_DEL 
		deallocate CUR_CTD_DEL
		-- ******* GERAR LOG DELECAO FIM ******    
  -- ***** deletar o que ficou de resto *****  
  delete from atividades_criterio_turmadisciplina where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** atividades_criterio_turmadisciplina fim ****   

--############################################################################################################################################  
 -- ****** frequencias_excecaofrequenciaforaprazo ****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'frequencias_excecaofrequenciaforaprazo'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from frequencias_excecaofrequenciaforaprazo dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from frequencias_excecaofrequenciaforaprazo aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          aux.protocolo_frequencia_fora_prazo_id = dpt.protocolo_frequencia_fora_prazo_id)              
			 
		-- ******* GERAR LOG  FREQUENCIAS_EXCECAOFREQUENCIAFORAPRAZO   ******
		declare CUR_EFFP cursor for 
			SELECT id FROM frequencias_excecaofrequenciaforaprazo 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_EFFP 
				fetch next from CUR_EFFP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_excecaofrequenciaforaprazo', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_EFFP into @ID_AUX
					END
			close CUR_EFFP 
		deallocate CUR_EFFP
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  FREQUENCIAS_EXCECAOFREQUENCIAFORAPRAZO  DELECAO ******
		declare CUR_EFFP_DEL cursor for 
			SELECT ID from frequencias_excecaofrequenciaforaprazo   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_EFFP_DEL 
				fetch next from CUR_EFFP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_excecaofrequenciaforaprazo', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_EFFP_DEL into @ID_AUX
					END
			close CUR_EFFP_DEL 
		deallocate CUR_EFFP_DEL
		-- ******* GERAR LOG DELECAO FIM ******  
  -- ***** deletar o que ficou de resto *****  
  delete from frequencias_excecaofrequenciaforaprazo where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** frequencias_excecaofrequenciaforaprazo fim ****   

--############################################################################################################################################  
 -- ****** frequencias_protocolofrequenciaforaprazo ****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'frequencias_protocolofrequenciaforaprazo'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from frequencias_protocolofrequenciaforaprazo dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from frequencias_protocolofrequenciaforaprazo aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          aux.protocolo_id = dpt.protocolo_id)                
			 
		-- ******* GERAR LOG  FREQUENCIAS_PROTOCOLOFREQUENCIAFORAPRAZO   ******
		declare CUR_PFFP cursor for 
			SELECT id FROM frequencias_protocolofrequenciaforaprazo 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_PFFP 
				fetch next from CUR_PFFP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_PFFP into @ID_AUX
					END
			close CUR_PFFP 
		deallocate CUR_PFFP
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  FREQUENCIAS_PROTOCOLOFREQUENCIAFORAPRAZO  DELECAO ******
		declare CUR_PFFP_DEL cursor for 
			SELECT ID from frequencias_protocolofrequenciaforaprazo   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_PFFP_DEL 
				fetch next from CUR_PFFP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_PFFP_DEL into @ID_AUX
					END
			close CUR_PFFP_DEL 
		deallocate CUR_PFFP_DEL
		-- ******* GERAR LOG DELECAO FIM ******  
  -- ***** deletar o que ficou de resto *****  
  delete from frequencias_protocolofrequenciaforaprazo where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** frequencias_protocolofrequenciaforaprazo fim ****  

--############################################################################################################################################   
 -- ****** academico_complementacaocargahoraria ****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'academico_complementacaocargahoraria'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from academico_complementacaocargahoraria dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from academico_complementacaocargahoraria aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          aux.aluno_id = dpt.aluno_id)                
			 
		-- ******* GERAR LOG  FREQUENCIAS_PROTOCOLOFREQUENCIAFORAPRAZO   ******
		declare CUR_PFFP cursor for 
			SELECT id FROM frequencias_protocolofrequenciaforaprazo 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_PFFP 
				fetch next from CUR_PFFP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_PFFP into @ID_AUX
					END
			close CUR_PFFP 
		deallocate CUR_PFFP
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  FREQUENCIAS_PROTOCOLOFREQUENCIAFORAPRAZO  DELECAO ******
		declare CUR_PFFP_DEL cursor for 
			SELECT ID from frequencias_protocolofrequenciaforaprazo   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_PFFP_DEL 
				fetch next from CUR_PFFP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_PFFP_DEL into @ID_AUX
					END
			close CUR_PFFP_DEL 
		deallocate CUR_PFFP_DEL
		-- ******* GERAR LOG DELECAO FIM ******  
  -- ***** deletar o que ficou de resto *****  
  delete from academico_complementacaocargahoraria where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** academico_complementacaocargahoraria fim ****   

--############################################################################################################################################  
 /*
 -- ****** aulas_pendentes ****  
	SET @DATA_ALTERECAO = GETDATE()

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino  
     from aulas_pendentes dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from aulas_pendentes aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
                aux.professor_id = dpt.professor_id )              
			 
		-- ******* GERAR LOG  AULAS_PENDENTES   ******
		declare CUR_PEN cursor for 
			SELECT id FROM aulas_pendentes 
			where -- atualizado_em = @DATA_ALTERECAO and 
			      -- atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_PEN 
				fetch next from CUR_PEN into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'aulas_pendentes', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_PEN into @ID_AUX
					END
			close CUR_PEN 
		deallocate CUR_PEN
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  AULAS_PENDENTES  DELECAO ******
		declare CUR_PEN_DEL cursor for 
			SELECT ID from aulas_pendentes   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_PEN_DEL 
				fetch next from CUR_PEN_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'aulas_pendentes', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_PEN_DEL into @ID_AUX
					END
			close CUR_PEN_DEL 
		deallocate CUR_PEN_DEL
		-- ******* GERAR LOG DELECAO FIM ******      
  -- ***** deletar o que ficou de resto *****  
  delete from aulas_pendentes where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** aulas_pendentes fim ****   
 */
--############################################################################################################################################  
 -- ****** frequencias_revisao **** 
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'frequencias_revisao'
 
    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from frequencias_revisao dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from frequencias_revisao aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
                aux.professor_id = dpt.professor_id and   
          aux.aluno_id  = dpt.aluno_id)                  
			 
		-- ******* GERAR LOG  FREQUENCIAS_REVISAO   ******
		declare CUR_REV cursor for 
			SELECT id FROM frequencias_revisao 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_REV 
				fetch next from CUR_REV into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_revisao', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_REV into @ID_AUX
					END
			close CUR_REV 
		deallocate CUR_REV
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  FREQUENCIAS_REVISAO  DELECAO ******
		declare CUR_REV_DEL cursor for 
			SELECT ID from frequencias_revisao   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_REV_DEL 
				fetch next from CUR_REV_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'frequencias_revisao', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_REV_DEL into @ID_AUX
					END
			close CUR_REV_DEL 
		deallocate CUR_REV_DEL
		-- ******* GERAR LOG DELECAO FIM ****** 
  -- ***** deletar o que ficou de resto *****  
  delete from frequencias_revisao where turma_disciplina_id = @turmaDisciplina_id_origem  
 -- ****** frequencias_revisao fim **** 

--############################################################################################################################################    
 -- ****** academico_aula ****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'academico_aula'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from academico_aula dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from academico_aula aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
                aux.professor_id = dpt.professor_id and   
          aux.data_inicio  = dpt.data_inicio  )                   
			 
		-- ******* GERAR LOG  ACADEMICO_AULA   ******
		declare CUR_AUL cursor for 
			SELECT id FROM academico_aula 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_AUL 
				fetch next from CUR_AUL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_aula', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_AUL into @ID_AUX
					END
			close CUR_AUL 
		deallocate CUR_AUL
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  ACADEMICO_AULA  DELECAO ******
		declare CUR_AUL_DEL cursor for 
			SELECT ID from academico_aula   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_AUL_DEL 
				fetch next from CUR_AUL_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_aula', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_AUL_DEL into @ID_AUX
					END
			close CUR_AUL_DEL 
		deallocate CUR_AUL_DEL
		-- ******* GERAR LOG DELECAO FIM ******   
  -- ***** deletar o que ficou de resto *****  
  delete from academico_aula where turma_disciplina_id = @turmaDisciplina_id_origem   
 -- ****** academico_aula fim ****  
 
--############################################################################################################################################  
  -- ****** academico_grupoaula ****  
    SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'academico_grupoaula'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from academico_grupoaula dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from academico_grupoaula aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
          isnull(aux.agendamento_id,0) = isnull(dpt.agendamento_id,0))
			 
		-- ******* GERAR LOG  ACADEMICO_GRUPOAULA   ******
		declare CUR_GPA cursor for 
			SELECT id FROM academico_grupoaula 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_GPA 
				fetch next from CUR_GPA into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_grupoaula', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_GPA into @ID_AUX
					END
			close CUR_GPA 
		deallocate CUR_GPA
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  ACADEMICO_GRUPOAULA  DELECAO ******
		declare CUR_GPA_DEL cursor for 
			SELECT ID from academico_grupoaula   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_GPA_DEL 
				fetch next from CUR_GPA_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_grupoaula', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_GPA_DEL into @ID_AUX
					END
			close CUR_GPA_DEL 
		deallocate CUR_GPA_DEL
		-- ******* GERAR LOG DELECAO FIM ******
  -- ***** deletar o que ficou de resto *****  
   delete from academico_grupoaula where turma_disciplina_id =  @turmaDisciplina_id_origem  
 -- ****** academico_grupoaula fim ****  

--############################################################################################################################################   
 -- ****** academico_turmadisciplinaaluno ****  
       -- ****** atualizar o que existe *****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'academico_turmadisciplinaaluno'

    update dpt set dpt.turma_disciplina_id = @turmaDisciplina_id_destino, dpt.atualizado_em = @DATA_ALTERECAO, dpt.atualizado_por = 2136  
    from academico_turmadisciplinaaluno dpt  
    where turma_disciplina_id = @turmaDisciplina_id_origem and   
          not exists (select 1 from academico_turmadisciplinaaluno aux  
                         where aux.turma_disciplina_id = @turmaDisciplina_id_destino and   
                aux.aluno_id = dpt.aluno_id)               
			 
		-- ******* GERAR LOG  ACADEMICO_TURMADISCIPLINAALUNO   ******
		declare CUR_TDA cursor for 
			SELECT id FROM academico_turmadisciplinaaluno 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_disciplina_id = @turmaDisciplina_id_destino  

			open CUR_TDA 
				fetch next from CUR_TDA into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplinaaluno', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, @razao
					fetch next from CUR_TDA into @ID_AUX
					END
			close CUR_TDA 
		deallocate CUR_TDA
		-- ******* GERAR LOG FIM ******

		-- ******* GERAR LOG  ACADEMICO_TURMADISCIPLINAALUNO  DELECAO ******
		declare CUR_TDA_DEL cursor for 
			SELECT ID from academico_turmadisciplinaaluno   
             where turma_disciplina_id = @turmaDisciplina_id_origem    

			open CUR_TDA_DEL 
				fetch next from CUR_TDA_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplinaaluno', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_TDA_DEL into @ID_AUX
					END
			close CUR_TDA_DEL 
		deallocate CUR_TDA_DEL
		-- ******* GERAR LOG DELECAO FIM ******    
  -- ***** deletar o que ficou de resto *****  
  delete from academico_turmadisciplinaaluno where turma_disciplina_id = @turmaDisciplina_id_origem   
 -- ****** academico_turmadisciplinaaluno fim ****  

 
--############################################################################################################################################   
 -- ****** academico_turmadisciplina ****  
       -- ****** atualizar o que existe *****  
	SET @DATA_ALTERECAO = GETDATE()
    SET @TABELA = 'academico_turmadisciplina'
	
		-- ******* GERAR LOG  ACADEMICO_TURMADISCIPLINAALUNO  DELECAO ******
		declare CUR_TDS_DEL cursor for 
			SELECT ID from academico_turmadisciplina   
             where id = @turmaDisciplina_id_origem    

			open CUR_TDS_DEL 
				fetch next from CUR_TDS_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplina', @ID_AUX, '-', 2136, NULL, NULL, @razao
					fetch next from CUR_TDS_DEL into @ID_AUX
					END
			close CUR_TDS_DEL 
		deallocate CUR_TDS_DEL
		-- ******* GERAR LOG DELECAO FIM ******    
  -- ***** deletar o que ficou de resto *****  
  delete from academico_turmadisciplina where id = @turmaDisciplina_id_origem   
 -- ****** academico_turmadisciplinaaluno fim ****  
  
 commit   
 PRINT 'MIGRACAO EFETUADA COM SUCESSO, APAGAR A TURMA DISCIPLINA COM O ID '  
 PRINT @turmaDisciplina_id_origem  
 
insert into tmp_erro_higienizacao
SELECT @turmaDisciplina_id_origem, @turmaDisciplina_id_destino, null, 'TURMA_DISCIPLINA_ID',GETDATE(), null, 'ok'  
 end try  
 begin catch  
 rollback   

insert into tmp_erro_higienizacao
SELECT @turmaDisciplina_id_origem, @turmaDisciplina_id_destino, @TABELA, 'TURMA_DISCIPLINA_ID',GETDATE(), ERROR_MESSAGE(), 'erro'  
 end catch  
 --    select  dbo.fn_retorna_colunas_tabela('aulas_agendamento')  
--     select * from vw_tabela_coluna where coluna = 'turmadisciplinaaluno_id'  
  
  
  
  
  
  
GO
