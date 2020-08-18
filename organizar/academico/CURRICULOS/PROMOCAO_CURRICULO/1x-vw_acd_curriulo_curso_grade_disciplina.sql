create or alter view VW_ACD_CURRIULO_CURSO_GRADE_DISCIPLINA as
select crc.id as curriculo_id, crc.nome as curriculo_nome, eta.id as etapa_id, eta.nome as etapa_nome, 
       cur.id as curso_id, cur.nome as curso_nome, 
       dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   gra.id as grade_id, gra.nome as grade_nome,  
       exi.id as exigenciadisciplina_id, exi.nome as exigenciadisciplina_nome

  from academico_curso cur join curriculos_curriculo           crc with(nolock) on (cur.id = crc.curso_id)
                           join curriculos_grade               gra with(nolock) on (crc.id = gra.curriculo_id)
                           join curriculos_gradedisciplina     grd with(nolock) on (gra.id = grd.grade_id)
                           join academico_disciplina           dis with(nolock) on (dis.id = grd.disciplina_id)
                           join academico_etapa                eta with(nolock) on (eta.id = gra.etapa_id)
						   join curriculos_exigenciadisciplina exi on (exi.id = grd.exigencia_disciplina_id)  

