create procedure SP_PRO_CARGA_FISIOLOGIA_HUMANA_SUB_SUB AS 

SELECT TOP 1 * INTO #tmp_aux FROM vw_curriculo_curso_turma_disciplina_aluno_grade

declare @pai varchar(20), @filha varchar(20), @neta varchar(20),
        @pai_max int, @filha_max int, @neta_max int ,
		@CONT INT = 0, @CONTTOTAL INT = 0, @TURMA_DISCIPLINA_ALUNO_ID INT, @NOME VARCHAR(200)

BEGIN TRAN

declare CUR_PAI cursor for 
	select distinct  FILHA --, filha, filha_max_carga--, subfilha, subfilha_max_carga 
	from VW_PRO_CARGA_FISIOLOGIA_HUMANA 
	--WHERE PAI = 'M073S02A202T'
	order by 1

	open CUR_PAI 
		fetch next from CUR_PAI into @pai
		while @@FETCH_STATUS = 0
			BEGIN
----------------------------------------------------------------------------------------------------
				DELETE FROM #tmp_aux
				INSERT INTO #tmp_aux
				SELECT   *
				 from vw_curriculo_curso_turma_disciplina_aluno_grade dag 
				where 
					  dag.turma_nome = @PAI and 
					  dag.disciplina_nome = 'FISIOLOGIA HUMANA II'
				order by dag.aluno_nome
--------------------------------------------------------------------------------------------------
            
	
	        declare CUR_FILHA cursor for 
				select distinct SUBFILHA, SUBFILHA_max_carga --, filha, filha_max_carga--, subfilha, subfilha_max_carga 
				from VW_PRO_CARGA_FISIOLOGIA_HUMANA 
				  WHERE FILHA = @PAI
				order by 1
				open CUR_FILHA 
					fetch next from CUR_FILHA into @FILHA, @filha_max
					while @@FETCH_STATUS = 0
						BEGIN

							SET @CONT = 0
						
							WHILE (@CONT < @filha_max AND EXISTS (SELECT 1 FROM #tmp_aux))
								BEGIN
									SELECT TOP 1 @TURMA_DISCIPLINA_ALUNO_ID = TURMA_DISCIPLINA_ALUNO_ID , @NOME = ALUNO_NOME
									FROM #tmp_aux ORDER BY ALUNO_NOME

									INSERT INTO academico_turmadisciplinaaluno 
		                                   (ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
			                                exigencia_matricula_disciplina_id, TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
				                            FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
									SELECT ALUNO_ID = dag.aluno_id, TURMA_DISCIPLINA_ID = tds.turma_disciplina_id , CRIADO_EM = GETDATE(), 
		                                   CRIADO_POR = 11717, ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, 
			                               EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, STATUS_MATRICULA_DISCIPLINA_ID = 14, 
			                               FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = dag.tda_curriculo_aluno_id
                                      from #tmp_aux dag join VW_ACD_CURRICULO_TURMA_DISCIPLINA tds on (tds.disciplina_id = dag.disciplina_id and
                                                                                                         tds.turma_nome = @FILHA)
									 WHERE dag.TURMA_DISCIPLINA_ALUNO_ID = @TURMA_DISCIPLINA_ALUNO_ID
				                                      
                                    DELETE FROM #tmp_aux WHERE @TURMA_DISCIPLINA_ALUNO_ID = TURMA_DISCIPLINA_ALUNO_ID

									SET @CONT = @CONT + 1
								END								
    
						fetch next from CUR_FILHA into @FILHA, @filha_max
						END
				close CUR_FILHA 
			deallocate CUR_FILHA 

			
			fetch next from CUR_PAI into  @pai
			END
	close CUR_PAI 
deallocate CUR_PAI 



-- COMMIT 


