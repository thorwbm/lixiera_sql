
-- *** ###################################################################################################
-- *** SELECT QUE BUSCA TODAS AS CORRECOES COM PROBLEMA DE DIVERGENCIA DE NOTAS 
insert into TMP_REDACAO
select ANA.ID AS ANALISE_ID, ANA.redacao_id, ANA.id_projeto
--INTO TMP_REDACAO
  from correcoes_analise ana with(nolock) JOIN CORRECOES_REDACAO  RED  WITH(NOLOCK) ON (RED.ID = ANA.redacao_id AND 
                                                                                        RED.id_projeto = ANA.id_projeto) 
                                          join correcoes_correcao cora with(nolock) on (ANA.id_correcao_A = CORA.ID AND 
                                                                                        ANA.REDACAO_ID    = CORA.REDACAO_ID AND
                                                                                        ANA.aproveitamento = 1 AND 
																						ANA.id_tipo_correcao_B = 3)
										  JOIN CORRECOES_CORRECAO CORB WITH(NOLOCK) ON (ANA.id_correcao_B = CORB.ID AND 
										                                                ANA.redacao_id = CORB.redacao_id AND 
																						ANA.APROVEITAMENTO = 1 )
	WHERE (RED.nota_final <> (ABS(CORA.nota_final + CORB.nota_final) /2 ) OR 
	      RED.nota_competencia1 <> (ABS(CORA.nota_competencia1 + CORB.nota_competencia1)/2)OR 
	      RED.nota_competencia2 <> (ABS(CORA.nota_competencia2 + CORB.nota_competencia2)/2)OR 
	      RED.nota_competencia3 <> (ABS(CORA.nota_competencia3 + CORB.nota_competencia3)/2)OR 
	      RED.nota_competencia4 <> (ABS(CORA.nota_competencia4 + CORB.nota_competencia4)/2)OR 
	      RED.nota_competencia5 <> (ABS(CORA.nota_competencia5 + CORB.nota_competencia5)/2)) AND 
	--	  ANA.data_termino_B < '2019-12-09' AND
		   RED.id_status = 4 and 
		   not exists (select 1 from tmp_redacao tem where ana.id = tem.analise_id) 


-- *** ###################################################################################################
-- *** CURSOR PARA CORRECAO DAS NOTAS
declare @redacao_id int, @PROEJTO_ID INT, @ANALISE_ID INT
declare abc cursor for 
	select top 3000 * from tmp_redacao  
	open abc 
		fetch next from abc into @ANALISE_ID, @redacao_id, @PROEJTO_ID
		while @@FETCH_STATUS = 0
			BEGIN
				exec SP_COPIAR_NOTAS_FINAL_REDACAO 3,@redacao_id, @ANALISE_ID, @PROEJTO_ID
				delete from tmp_redacao where redacao_id = @redacao_id

			fetch next from abc into @ANALISE_ID, @redacao_id, @PROEJTO_ID
			END
	close abc 
deallocate abc 

-- ***  ##########################################################################
-- ***  TESTE 
/*
exec SP_COPIAR_NOTAS_FINAL_REDACAO 3, 375183, 4406664, 4

declare @redacao_id int  set @redacao_id = 375183
SELECT NOTA_FINAL, nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5 
  FROM correcoes_redacao WHERE ID= @redacao_id

SELECT NOTA_FINAL, nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5, id_tipo_correcao, data_termino
 FROM CORRECOES_CORRECAO WHERE REDACAO_ID =@redacao_id      ORDER BY id_tipo_correcao

SELECT id_tipo_correcao_A, id_tipo_correcao_B, conclusao_analise, aproveitamento, redacao_id, id_projeto, id
 FROM correcoes_analise  WHERE redacao_id =@redacao_id      AND APROVEITAMENTO = 1 


 */