/*
with cte_turmas_duplicadas as (
			select nome 
			from academico_turma 
			group by nome 
			having count(1) >1
)
	,	cte_duplicidade as (
			select tur.id, tur.nome 
			  from cte_turmas_duplicadas cte join academico_turma tur on (tur.nome = cte.nome)

)

			select dup1.nome, convert(varchar(10),dup1.id) + ', ' + convert(varchar(10),dup2.id)
			  from cte_duplicidade dup1 join cte_duplicidade dup2 on (dup1.nome = dup2.nome and dup1.id <> dup2.id and   dup1.id < dup2.id)

			select * from academico_turmadisciplina            where turma_id in (1587, 1617)
            select * from materiais_didaticos_publicacao_turma where turma_id in (1587, 1617)

*/
			--###########################################################################
			--###########################################################################
			--###########################################################################

DECLARE @turma_id_origem int, @turma_id_destino int, @DATA_ALTERECAO datetime, 
        @ID_AUX int, @ATRIBUTOS VARCHAR(MAX), @TABELA VARCHAR(200)

set @turma_id_origem = 1617
set @turma_id_destino = 1587
set @DATA_ALTERECAO = getdate()

SET @ATRIBUTOS =  DBO.FN_GERAR_JSON_UPDATE('turma_id;'+ CONVERT(VARCHAR(10), @turma_id_origem)+';' + CONVERT(VARCHAR(10),@turma_id_destino ))

begin try  
begin tran   
--###########################################################################	
   SET @TABELA = 'academico_turmadisciplina'

			update academico_turmadisciplina set turma_id = @turma_id_destino, atualizado_em = @DATA_ALTERECAO
			where turma_id = @turma_id_origem		 
		-- ******* GERAR LOG  ACADEMICO_TURMADISCIPLINA   ******
		declare CUR_TDP cursor for 
			SELECT id FROM ACADEMICO_TURMADISCIPLINA 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_id = @turma_id_destino  

			open CUR_TDP 
				fetch next from CUR_TDP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'academico_turmadisciplina', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, 'HIGIENIZACAO'
					fetch next from CUR_TDP into @ID_AUX
					END
			close CUR_TDP 
		deallocate CUR_TDP
		-- ******* GERAR LOG FIM ******
--###########################################################################
   SET @TABELA = 'materiais_didaticos_publicacao_turma'

			update materiais_didaticos_publicacao_turma set turma_id = @turma_id_destino, atualizado_em = @DATA_ALTERECAO
			where turma_id = @turma_id_origem
			-- ******* GERAR LOG  materiais_didaticos_publicacao_turma   ******
		declare CUR_TDP cursor for 
			SELECT id FROM materiais_didaticos_publicacao_turma 
			where atualizado_em = @DATA_ALTERECAO and 
			      atualizado_por = 2136 and 
				  turma_id = @turma_id_destino  

			open CUR_TDP 
				fetch next from CUR_TDP into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						EXEC SP_GERAR_LOG 'materiais_didaticos_publicacao_turma', @ID_AUX, '~', 2136, NULL, @ATRIBUTOS, 'HIGIENIZACAO'
					fetch next from CUR_TDP into @ID_AUX
					END
			close CUR_TDP 
		deallocate CUR_TDP
		-- ******* GERAR LOG FIM ******
--###########################################################################
--###########################################################################
   SET @TABELA = 'academico_turma'

		-- ******* GERAR LOG  academico_turma  DELECAO ******
			EXEC SP_GERAR_LOG 'ACADEMICO_TURMA', @turma_id_origem, '-', 2136, NULL, NULL, 'HIGIENIZACAO'
--###########################################################################
			delete academico_turma 
			where id = @turma_id_origem			
  COMMIT

insert into tmp_erro_higienizacao
SELECT @turma_id_origem, @turma_id_destino, null, 'TURMA_ID',GETDATE(), null, 'ok'  
print 'SUCESSO'
 end try  
 begin catch  
 rollback   

insert into tmp_erro_higienizacao
SELECT @turma_id_origem, @turma_id_destino, @TABELA, 'TURMA_ID',GETDATE(), ERROR_MESSAGE(), 'erro'  
 end catch  



 --  SELECT * FROM tmp_erro_higienizacao ORDER BY ID DESC
 --  SELECT * FROM LOG_ACADEMICO_TURMA ORDER BY HISTORY_ID DESC 
 --  SELECT * FROM ACADEMICO_TURMA ORDER BY ID DESC