SELECT atc.*, atq.* ,  alunos_matriculados = agp.matriculados
  FROM VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF atc join vw_atividade_quantidades_com_sem_nota atq on (atc.ATIVIDADE_ID = atq.atividade_id )
                                                            join (select turmadisciplina_id, matriculados =COUNT(1) 
															        from vw_curso_turma_disciplina_aluno
																	group by turmadisciplina_id) as agp on (agp.turmaDisciplina_id = atc.turmadisciplina_id)
WHERE TURMA_INICIO_VIGENCIA IS NOT NULL AND 
      TURMA_TERMINO_VIGENCIA IS NOT NULL AND
	  TURMA_TERMINO_VIGENCIA >= '2019-07-14' and 
	  com_nota <> agp.matriculados

	  and 
	   TURMA_NOME = '1MAP011º2019-1' and 
	        DISCIPLINA_NOME = 'FISIOLOGIA HUMANA I'
			


			--- O ALUNO QUE ESTA SENDO REFERENCIADO NO COMENTARIO NAS DUAS CONSULTAS POSSUI REGISTRO NA ATIVIDADES_ATIVIDADE_ALUNO POREM NAO EXISTE NA 
			--- TURMADISCIPLINAALUNO. 
			--- *** ISSO E CORRETO? EXISTEM VARIOS OUTROS CASOS ASSIM 
			
			select * 
			from academico_turmadisciplinaaluno 
			where turma_disciplina_id = 4441 
			--       and aluno_id = 48623			
			order by aluno_id


			select distinct alu.* from atividades_atividade_aluno alu join atividades_atividade ati on (ati.id = alu.atividade_id)
			                                                 join atividades_criterio_turmadisciplina act on (act.id = ati.criterio_turma_disciplina_id)
			where turma_disciplina_id = 4441 and atividade_id = 11
			--      and aluno_id = 48623
			order by aluno_id