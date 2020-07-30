with cte_aulas_aluno as (
		select fre.aluno_id as aluno_id, 
			   tds.disciplina_id, 
			   count(1) as qtd
		  from academico_frequenciadiaria fre join academico_aula aul on (fre.aula_id = aul.id  and aul.status_id = 3)
											  join academico_turmadisciplina tds on (tds.id = aul.turma_disciplina_id)
		group by fre.aluno_id, tds.disciplina_id
) 

	, cte_frequencia_minima_aluno as (
		select alu.aluno_id, grd.disciplina_id, grd.carga_horaria
		  from curriculos_gradedisciplina grd join curriculos_grade gra on (grd.grade_id = gra.id)
											  join curriculos_aluno alu on (alu.curriculo_id = gra.curriculo_id)
)

	, cte_aulas as (
select alu.nome as Aluno, alu.ra, tur.nome as Turma, dis.nome as Disciplina, dis.id as disciplina_id, 
       tda.criado_em, aul.data_inicio, aul.data_termino, aul.id as aula_id, tda.aluno_id, tds.id as turmaDisciplina_id 
  from academico_aula aul join academico_turmadisciplina      tds on (tds.id = aul.turma_disciplina_id)
                          join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id)
						  join academico_turma                tur on (tur.id = tds.turma_id)
						  join academico_disciplina           dis on (dis.id = tds.disciplina_id)
						  join academico_aluno                alu on (alu.id = tda.aluno_id)
 where aul.status_id = 3
   and cast(tur.termino_vigencia as date) >= '2019-12-01'
   and dis.nome not like '%estagio%'
)

	select distinct aul.aluno, aul.ra, aul.turma, aul.Disciplina,
	 fre.carga_horaria, alu.qtd as aulas_do_aluno, aul.data_inicio, aul.data_termino, aul.aula_id
	  from cte_frequencia_minima_aluno fre join cte_aulas_aluno alu on  (fre.aluno_id = alu.aluno_id and 
	                                                                     fre.disciplina_id = alu.disciplina_id) 
										   join vw_aluno_aula_faltante aul on (aul.aluno_id = alu.aluno_id and 
										                                       aul.disciplina_id = fre.disciplina_id )

		where --aul.ra = '1161.000213' and 
		fre.carga_horaria > alu.qtd and 
			(fre.carga_horaria - alu.qtd) <= 10


			/*
			select top 10 atributos= '{"justificativa":"ajuste manual de frequencia a pedido da CMMG"}', presente = 1, aluno_id, aula_id, atualizado_em = getdate(), criado_em = getdate(),
			       criado_por = 2136, tipo_id = 1
		     from academico_frequenciadiaria
			 */