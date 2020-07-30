SELECT * 
  FROM vw_aluno_curriculo_curso_turma_etapa_discplina atd left join vw_curriculo_turma_disciplina_grade_oferta CRO ON (atd.CURRICULO_ID = cro.curriculo_id and 
                                                                                                                  atd.DISCIPLINA_ID = cro.disciplina_id)
where atd.TURMA_INICIOVIGENCIA >= '2020-01-01' AND 
      atd.STATUSCURRICULO_ID = 13 and 
	  cro.curriculo_id is null
	  


select * from vw_curriculo_turma_disciplina_grade_oferta
where curriculo_id = 2276 and disciplina_id = 3886