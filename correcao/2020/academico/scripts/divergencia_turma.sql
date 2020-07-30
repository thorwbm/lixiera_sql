WITH CTE_CONFLITO AS (
	
select distinct  tdg.turma_nome, tdg.grade_nome, tdg.disciplina_nome, tdg.curriculo_nome, tdg.disciplina_id, tdg.curriculo_id, tdg.grade_id
  from vw_turma_disciplina_grade tdg left join vw_curriculo_grade_disciplina_oferta gdo on (tdg.curriculo_id = gdo.curriculo_id and 
                                                                                            tdg.grade_id        = gdo.grade_id  and 
																							tdg.disciplina_id  = gdo.disciplina_id)
where gdo.curriculo_id is null and 
      tdg.inicio_vigencia >= '2020-01-01')
----

        SELECT DISTINCT CTE.* , REAL_DISCIPLINA = ISNULL(OFT.GRADE_NOME, 'NAO EXISTE')
		FROM CTE_CONFLITO CTE LEFT JOIN vw_curriculo_grade_disciplina_oferta OFT ON (CTE.DISCIPLINA_ID = OFT.DISCIPLINA_ID AND 
		                                                                        CTE.CURRICULO_ID  = OFT.CURRICULO_ID and 
																				cte.grade_id = oft.grade_id)


--select tur.* from academico_turmadisciplina tds join academico_turma tur on (tur.id = tds.turma_id)


select 

		