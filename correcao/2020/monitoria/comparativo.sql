with cte_importacao as (
			select disciplina, count(1) AS QTD
			from tmp_importacao_monitoria_2019
			group by disciplina
)

	,	CTE_BANCO AS (
			select disc.nome AS disciplina, count(1) AS QTD
			from academico_turmadisciplinaaluno tda
			join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
			join academico_disciplina disc on disc.id = td.disciplina_id
			join academico_turma turma on turma.id = td.turma_id
			join academico_aluno aluno on aluno.id = tda.aluno_id
			join curriculos_aluno ca on ca.aluno_id = aluno.id
			where 
			      ca.status_id = 13
			  and turma.turma_pai_id is null
			  group by disc.nome
)

             SELECT BAN.disciplina, BAN.QTD AS QTD_BANCO, IMP.QTD AS QTD_MONITORIA
			 FROM CTE_BANCO BAN JOIN cte_importacao IMP ON (BAN.disciplina = IMP.disciplina)
			 where  BAN.QTD <> IMP.QTD 

			 order by 1