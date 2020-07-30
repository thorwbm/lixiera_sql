with cte_frequencia_diaria as (
		select DISTINCT crc.id as curriculoaluno_id, 
               cur.id as curso_id, cur.nome as curso_nome,  
       		   dis.id as disciplina_id, dis.nome as disciplina_nome, 
       		   alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra,-- usu.id as aluno_usuario_id, 
			   count(aul.id) as qtd_aulas_dadas,
       		   sum(case when frq.presente = 1 then 0 else 1 end) as qtd_faltas, 
			   TPF.TURMA_PAI_ID AS TURMA_ID
         from academico_aula aul  join academico_turmadisciplinaaluno tda on (aul.turma_disciplina_id = tda.turma_disciplina_id)
                                  join academico_turmadisciplina      tds on (tds.id = aul.turma_disciplina_id)
       						      join academico_turma                tur on (tur.id = tds.turma_id)
       						      join academico_curso                cur on (cur.id = tur.curso_id)
       						      join academico_disciplina           dis on (dis.id = tds.disciplina_id)
       						      join academico_aluno                alu on (alu.id = tda.aluno_id)
       						      join academico_frequenciadiaria     frq on (aul.id = frq.aula_id and 
       						                                                  alu.id = frq.aluno_id)
       						      join curriculos_aluno               crc on (alu.id = crc.aluno_id and 
       						                                                  crc.status_id = 13)
						          JOIN VW_TURMA_PAI_FILHA             TPF ON (TUR.ID = TPF.TURMA_ID)

       group by crc.id, cur.id, cur.nome, dis.id, dis.nome, alu.id, alu.nome, alu.ra, TPF.TURMA_PAI_ID
)


	, cte_complemento_frequencia as (
				select cra.id as curriculoaluno_id, 
		       cur.id as curso_id, cur.nome as curso_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome, 
			   alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra, 
			   sum(comp.carga_horaria) as qtd_aulas_dadas, 
			   sum(comp.faltas) as qtd_faltas,
			   TPF.TURMA_PAI_ID AS TURMA_ID
		  from academico_complementacaocargahoraria comp join academico_aluno           alu on (alu.id = comp.aluno_id)
		                                                 join academico_turmadisciplina tds on (tds.id = comp.turma_disciplina_id)
														 join academico_turma           tur on (tur.id = tds.turma_id)
														 join academico_curso           cur on (cur.id = tur.curso_id)
														 join academico_disciplina      dis on (dis.id = tds.disciplina_id)
														 join curriculos_aluno          cra on (alu.id = cra.aluno_id and 
														                                        cra.status_id = 13)
														 JOIN VW_TURMA_PAI_FILHA        TPF ON (TUR.ID = TPF.TURMA_ID)

        group by cra.id, cur.id, cur.nome, dis.id, dis.nome, alu.id, alu.nome, alu.ra, TPF.TURMA_PAI_ID
)
 
	, cte_calculo_frequencia_alunos as (
		select dia.curriculoaluno_id, dia.curso_id, dia.curso_nome, dia.disciplina_id, dia.disciplina_nome, dia.aluno_id, 
		       dia.aluno_nome, dia.aluno_ra, DIA.TURMA_ID,
			   qtd_aulas_dadas = isnull(dia.qtd_aulas_dadas,0) + isnull(comp.qtd_aulas_dadas,0), 
			   qtd_faltas      = isnull(dia.qtd_faltas,0) + isnull(comp.qtd_faltas,0),
			   porcentagem_FREQUENCIA = 100 - ((isnull(dia.qtd_faltas,0) + isnull(comp.qtd_faltas,0)) * 100.0 / (isnull(dia.qtd_aulas_dadas,0) + isnull(comp.qtd_aulas_dadas,0)) * 1.0),
			   porcentagem_FALTA      =       ((isnull(dia.qtd_faltas,0) + isnull(comp.qtd_faltas,0)) * 100.0 / (isnull(dia.qtd_aulas_dadas,0) + isnull(comp.qtd_aulas_dadas,0)) * 1.0)
		  from cte_frequencia_diaria dia left join cte_complemento_frequencia comp on (dia.aluno_id = comp.aluno_id and 
		                                                                               dia.curriculoaluno_id = comp.curriculoaluno_id and 
																					   dia.curso_id          = comp.curso_id and 
																					   dia.disciplina_id     = comp.disciplina_id AND 
																					   DIA.TURMA_ID          = COMP.TURMA_ID)
)
                
		select CAL.*, TDS.frequencia_minima * 100.0 AS PERCENTUAL_MINIMO_EXIGIDO, 
		CASE WHEN CAL.porcentagem_FREQUENCIA < (TDS.frequencia_minima * 100.0) THEN 'REPROVADO' ELSE 'APROVADO' END AS STATUS_CALCULADO, 
		STD.nome AS STATUS_DO_CURRICULO_DISCIPLINA
		  from cte_calculo_frequencia_alunos cal JOIN academico_turmadisciplina      TDS ON (TDS.turma_id = CAL.TURMA_ID AND 
		                                                                                     TDS.disciplina_id = CAL.disciplina_id)
		                                    left join curriculos_disciplinaconcluida cdc on (cdc.curriculo_aluno_id = cal.curriculoaluno_id and 
		                                                                                          cdc.disciplina_id      = cal.disciplina_id)
											LEFT JOIN curriculos_statusdisciplina    STD ON (STD.ID = CDC.status_id)
       WHERE CAL.porcentagem_FREQUENCIA < (TDS.frequencia_minima * 100.0) AND 
	         CDC.status_id <> 10 --AND 
		--	 CAL.ALUNO_nome = 'VIVIAN DA SILVA BOTELHO SILVA'

		 
		-- SELECT * FROM curriculos_statusdisciplina