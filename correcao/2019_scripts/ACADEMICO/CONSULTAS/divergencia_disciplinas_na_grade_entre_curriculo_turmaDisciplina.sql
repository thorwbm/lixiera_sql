with cte_curriculo_grade_disciplina as (
		select crc.id as curriculo_id, crc.nome as curriculo_nome, 
			   gra.id as grade_id, gra.nome as grade_nome,
			   eta.id as etepa_id, eta.nome as etapa_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome,
			   cgd.id as gradeDisciplina_id 
		  from curriculos_grade gra join curriculos_curriculo       crc on (crc.id = gra.curriculo_id)
									join academico_etapa            eta on (eta.id = gra.etapa_id)
									join curriculos_gradedisciplina cgd on (gra.id = cgd.grade_id)
									join academico_disciplina       dis on (dis.id = cgd.disciplina_id)
)


select * from cte_curriculo_grade_disciplina where curriculo_id = 2335 order by disciplina_nome

	, cte_grade_via_turmaDisciplina as (
		select tds.id as turmaDisciplina_id,
		       cur.id as curso_id, cur.nome as curso_nome,
			   tur.id as turma_id, tur.nome as turma_nome,
			   dis.id as disciplina_id, dis.nome as disciplina_nome,
			   gra.id as grade_id, gra.nome as grade_nome, 
			   eta.id as etapa_id, eta.nome as etapa_nome

		  from academico_turmadisciplina tds join academico_turma      tur on (tur.id = tds.turma_id)
		                                     join academico_disciplina dis on (dis.id = tds.disciplina_id)
											 join academico_curso      cur on (cur.id = tur.curso_id)
											 join curriculos_grade     gra on (gra.id = tur.grade_id)
									         join academico_etapa      eta on (eta.id = gra.etapa_id)
)

	---, cte_turmas_disciplinas_fora_da_grade as (
		select distinct 
		       tur.curso_nome, tur.turma_nome, tur.disciplina_nome, tur.grade_id, tur.grade_nome, tur.etapa_nome, tur.turmaDisciplina_id
			   , gra.grade_id
		  from cte_grade_via_turmaDisciplina tur 
		                                         left join cte_curriculo_grade_disciplina gra on (tur.grade_id = gra.grade_id and 
		                                                                                          tur.disciplina_id = gra.disciplina_id)

	      where gra.grade_id is null 


		  select * from curriculos_grade where id = 6782


		  select * from academico_disciplina where nome = 'PRÁTICAS EM SAÚDE COLETIVA I'


		  select a.name as tabela, b.name as coluna from sysobjects a join syscolumns b on a.id = b.id and a.xtype = 'U' and b.name in ('disciplina_id', 'id_disciplina')



		  cronogramas_cronograma


		  select * from academico_disciplina where id = 4080