-- DROP TABLE #temp_enturmacao

    --------------------------------------------------
	SELECT ent.CURRICULO_ALUNO_ID, ENT.ALUNO_ID, ent.ALUNO_NOME, ENT.DESTINO, ENT.disciplina_id, DIS.NOME AS DISCIPLINA_NOME, 
	       CAN.TURMA_ID, CAN.TURMA_NOME, 
	       DST.NOME AS TURMA_DESTINO, cur.nome as curso_nome, tds.id as turmadisciplina_id
		   INTO #temp_enturmacao
      FROM vw_pro_aluno_disciplina_enturmar ENT JOIN ACADEMICO_DISCIPLINA           DIS ON (ENT.disciplina_id = DIS.ID)
	                                            join academico_curso                cur on (cur.id = ent.curso_id)
	                                            JOIN VW_PRO_ALUNO_TURMA_CANDIDATA   can on (can.curriculo_aluno_id = ent.curriculo_aluno_id AND
												                                            CAN.ANO = 2020 AND CAN.SEMESTRE = 1)
										   LEFT JOIN ACADEMICO_TURMA                DST ON (DST.turma_origem_rematricula_id = CAN.TURMA_ID)
										   left join academico_turmadisciplina      tds on (tds.turma_id = dst.id and 
												                                            tds.disciplina_id = dis.id)
										   LEFT JOIN VW_PRO_ALUNO_MAIS_DE_UM_ATIVO  MUA ON (MUA.ALUNO_ID = ENT.ALUNO_ID)
										   left join academico_turmadisciplinaaluno XXX ON (XXX.ALUNO_ID = ENT.ALUNO_ID AND 
										                                                    XXX.curriculo_aluno_id = ENT.curriculo_aluno_id AND
																							XXX.turma_disciplina_id = TDS.ID )

	WHERE ENT.curriculo_nome = 'MEDICINA 2020/12-1 (1-2020)' AND 
	      MUA.ALUNO_ID IS NULL and 
		  tds.id is not null AND
		  CUR.NOME NOT IN ('CURSO DE EXTENSÃO EM ORATÓRIA','CURSO DE TUTORIA') AND 
		  XXX.ID IS NULL 
	ORDER BY CUR.NOME, ENT.DESTINO, ENT.ALUNO_NOME, DIS.NOME
	-- order by   tds.id, ENT.ALUNO_NOME,  DIS.NOME
	--------------------------------------------------

--INSERT INTO academico_turmadisciplinaaluno (
--       ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
--	   exigencia_matricula_disciplina_id,TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
--	   FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
--
SELECT ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.turmadisciplina_id, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
       ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
	   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.curriculo_aluno_id
  FROM #temp_enturmacao tem LEFT JOIN academico_turmadisciplinaaluno XXX ON (XXX.aluno_id = tem.ALUNO_ID AND 
                                                                             XXX.turma_disciplina_id = tem.turmadisciplina_id AND
																			 XXX.curriculo_aluno_id = tem.curriculo_aluno_id)
 WHERE XXX.id IS NULL AND 
       (select isnull(tdsx.maximo_vagas,0) - count(tdsx.id) 
			  from academico_turmadisciplina      tdsx 
								   left join academico_turmadisciplinaaluno tdax on (tdsx.id = tdax.turma_disciplina_id)
			  where tdsx.id = tem.turmadisciplina_id  			        
			 group by tdsx.id, isnull(tdsx.maximo_vagas,0)) > 0