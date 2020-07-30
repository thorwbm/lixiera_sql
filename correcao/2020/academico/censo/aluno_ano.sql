with cte_aluno_sem_ano as (
			select distinct aluno_id, year(tur.inicio_vigencia) as ano_cursado
			  from academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)
													  join academico_turma           tur on (tur.id = tds.turma_id) 
			  where  year(tur.inicio_vigencia) is null 
)

	, cte_alunos as (
			select distinct aluno_id, year(tur.inicio_vigencia) as ano_cursado
			  from academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)
													  join academico_turma           tur on (tur.id = tds.turma_id) 
			where  year(tur.inicio_vigencia) is not null 
)

        select * from cte_aluno_sem_ano san left join cte_alunos alu on (san.aluno_id = alu.aluno_id)
		where alu.aluno_id is null 

		select aluno_id, aluno_nome, TURMA_NOME
		from vw_aluno_curriculo_curso_turma_etapa_discplina
		where aluno_id in (48066,53253)

        select * from academico_turmadisciplinaaluno where aluno_id in (48066,53253)
		select * from academico_turmadisciplina where id in (10706,10349)
		
		select * from academico_turma where id in (555,393)
		select * from academico_turma where id in (884,1257)


/*
create view vw_aluno_ano_cursado as 
			select distinct aluno_id, year(tur.inicio_vigencia) as ano_cursado
			  from academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)
													  join academico_turma           tur on (tur.id = tds.turma_id) 
			where  year(tur.inicio_vigencia) is not null
*/