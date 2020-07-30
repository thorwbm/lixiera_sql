with cte_turmas_disciplinas as (
		select tipo = case when tur.turma_pai_id IS null then 'PAI' ELSE 'FILHA' END, 
			   cur.id as curso_id, cur.nome as curso_nome, 
			   tur.id as turma_id, tur.nome as turma_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome, 
			   tdc.id as turmadisciplina_id, 
			   tur.turma_pai_id       
				from academico_turma tur join academico_turmadisciplina tdc on (tur.id = tdc.turma_id)
										  join academico_disciplina      dis on (dis.id = tdc.disciplina_id) 
										  join academico_curso           cur on (cur.id = tur.curso_id) 
	)

	,cte_turma_disciplina_pai as (
		select * 
		  from cte_turmas_disciplinas cte 
		 where tipo = 'pai')

	,CTE_TURMA_PAI_FILHAS AS (
		 select curso_nome_PAI = pai.curso_nome, turma_nome_PAI = pai.turma_nome, disciplina_nome_PAI = pai.disciplina_nome,
				TDC.CURSO_NOME, TDC.TURMA_NOME, TDC.DISCIPLINA_NOME
		  from cte_turma_disciplina_pai pai join cte_turmas_disciplinas TDC ON (pai.turma_id = TDC.turma_pai_id AND TDC.turma_pai_id IS NOT NULL )
	)

	
		 SELECT * FROM CTE_TURMA_PAI_FILHAS
		 WHERE turma_nome_PAI = '1MB1º2019-1'

	/*SELECT * 
	 FROM CTE_TURMA_PAI_FILHAS
	 WHERE CURSO_NOME = 'ENFERMAGEM' AND TURMA_NOME = '10EP011º' AND DISCIPLINA_NOME = 'ESTÁGIO SUPERVISIONADO III'

	 */


	SELECT * -- CURSO_NOME, TURMA_NOME, disciplina_nome, COUNT( DISTINCT DISCIPLINA_NOME_PAI) 
	 FROM CTE_TURMA_PAI_FILHAS
	-- GROUP BY CURSO_NOME, TURMA_NOME, disciplina_nome
	 

/*	 SELECT * FROM CTE_TURMA_PAI_FILHAS WHERE TURMA_NOME_PAI = '7E1º02'*/