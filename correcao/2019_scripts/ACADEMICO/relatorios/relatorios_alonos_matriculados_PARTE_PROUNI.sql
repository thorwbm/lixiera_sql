alter VIEW VW_ALUNOS_MATRICULADOS_OUTROS AS 
with cte_alunosMatriculados as (
		select distinct curso.nome as CURSO,  etapa.nome as Etapa,  aluno.id as aluno_id, crc.id as curriculo_id, crc.nome as curriculo_nome, 
						frming.id as forma_ingresso_id, tpmat.id as tipo_matricula_id, STAALUCUR.id AS STATUS_ID
			from academico_aula                 aula        with(nolock)
			join academico_turmadisciplina      td          with(nolock) on (td.id          = aula.turma_disciplina_id  )
			join academico_turma                turma       with(nolock) on (turma.id       = td.turma_id			    )
			join academico_turmadisciplinaaluno tda         with(nolock) on (td.id          = tda.turma_disciplina_id   )
			join academico_tipomatricula        tpmat       with(nolock) on (tpmat.id       = tda.tipo_matricula_id     )
			join academico_aluno                aluno       with(nolock) on (aluno.id       = tda.aluno_id			    )
			join academico_etapaano             etapaano    with(nolock) on (etapaano.id    = turma.etapa_ano_id	    )
			join academico_etapa                etapa       with(nolock) on (etapa.id       = etapaano.etapa_id		    )
			join curriculos_aluno               alucurr     with(nolock) on (aluno.id       = alucurr.aluno_id		    )
			join curriculos_grade               grade       with(nolock) on (grade.id       = alucurr.grade_id		    )
			join curriculos_curriculo           crc         with(nolock) on (crc.id         = alucurr.curriculo_id      )
			join academico_curso                curso       with(nolock) on (curso.id       = CRC.curso_id		        )
			join curriculos_formaingresso       frming      with(nolock) on (frming.id      = alucurr.metodo_admissao_id)
			JOIN curriculos_statusaluno         STAALUCUR   WITH(NOLOCK) ON (STAALUCUR.id   = alucurr.status_id         )
			where cast(aula.data_inicio as date) >= '2019-07-14'and 
			      alucurr.STATUS_ID IN (13, 18)
	)

	-- *** TODOS OS CURRICULOS ETAPA
	, cte_curriculo_curso_etapa as (
		select distinct curriculo_id, etapa, curriculo_nome, CURSO
		  from cte_alunosMatriculados
	)

	-- *** ALUNOS REGULARES
	, cte_alunos_tipo_regular as (
		select DISTINCT curriculo_id, Etapa, CURSO, aluno_id, tipo_aluno =  'REGULAR' 
		  from cte_alunosMatriculados 
		  WHERE tipo_matricula_id = 1 
	)
	-- *** ALUNOS IRREGULARES	
	, cte_alunos_tipo_irregular as (
		select DISTINCT curriculo_id, Etapa, CURSO, aluno_id, tipo_aluno =  'IRREGULAR' 
		  from cte_alunosMatriculados alu 
		  WHERE not exists (select 1 from cte_alunos_tipo_regular aux where aux.aluno_id = alu.aluno_id )
	)
	
	-- *** TODOS OS ALUNOS PRO_UNI 
	, cte_alunosMatriculados_proUni as (
		select DISTINCT ALU.curriculo_id, ALU.curriculo_nome, alu.CURSO, ALU.Etapa, ALU.aluno_id, ALU.STATUS_ID,
		                tipo_aluno = ISNULL(IREG.tipo_aluno, REG.tipo_aluno)
		  from cte_alunosMatriculados ALU LEFT JOIN cte_alunos_tipo_regular   REG  ON  (ALU.curriculo_id   = REG.curriculo_id AND 
		                                                                                ALU.CURSO          = REG.CURSO        and
		                                                                                ALU.Etapa          = REG.Etapa        AND
																					    ALU.aluno_id       = REG.aluno_id       )
										  LEFT JOIN cte_alunos_tipo_Irregular IREG ON  (ALU.curriculo_id  = IREG.curriculo_id AND
		                                                                                ALU.CURSO         = IREG.CURSO        and 
		                                                                                ALU.Etapa         = IREG.Etapa        AND
																					    ALU.aluno_id      = IREG.aluno_id )
		 where forma_ingresso_id in (9,21)
	)
	 
	-- *** TODOS OS ALUNOS OUTROS
	, cte_alunosMatriculados_outros as (
		select DISTINCT ALU.curriculo_id, ALU.curriculo_nome, alu.CURSO, ALU.Etapa, ALU.aluno_id, ALU.STATUS_ID,
		                tipo_aluno = ISNULL(IREG.tipo_aluno, REG.tipo_aluno)
		  from cte_alunosMatriculados ALU LEFT JOIN cte_alunos_tipo_regular   REG  ON  (ALU.curriculo_id = REG.curriculo_id AND
		                                                                                ALU.CURSO        = REG.CURSO        and 
		                                                                                ALU.Etapa        = REG.Etapa        AND
																					    ALU.aluno_id     = REG.aluno_id )
										  LEFT JOIN cte_alunos_tipo_Irregular IREG ON  (ALU.curriculo_id = IREG.curriculo_id AND 
		                                                                                ALU.CURSO        = IREG.CURSO        and
		                                                                                ALU.Etapa        = IREG.Etapa        AND
																					    ALU.aluno_id     = IREG.aluno_id )
		 where NOT EXISTS (SELECT 1 FROM cte_alunosMatriculados_proUni CTEX
		                    WHERE CTEX.curriculo_id = ALU.curriculo_id AND 
							      CTEX.CURSO        = ALU.CURSO        and
						          CTEX.Etapa        = ALU.Etapa        AND 
								  CTEX.aluno_id     = ALU.aluno_id )
	)
		
	-- **** CONTAGEM OUTROS 
	, CTE_QUANTIDADE_OUTROS AS (
		SELECT curriculo_id, CURSO, Etapa, QTD = COUNT(1) 
		FROM cte_alunosMatriculados_OUTROS
		GROUP BY curriculo_id, CURSO, Etapa
	)
	
	-- **** CONTAGEM OUTROS POR TIPO
	, CTE_QUANTIDADE_OUTROS_TIPO AS (
		SELECT curriculo_id, CURSO, Etapa, tipo_aluno, QTD = COUNT(1) 
		FROM cte_alunosMatriculados_OUTROS
		GROUP BY curriculo_id, CURSO, Etapa, tipo_aluno
	)
	
			select distinct cce.curriculo_id, cce.curriculo_nome, cce.curso, cce.Etapa,  
			   forma_ingresso_outras          = ISNULL(CQO.QTD,0),
			   forma_ingresso_outras_regular  = ISNULL(CQOR.QTD,0),
			   forma_ingresso_outras_iregular = ISNULL(CQOI.QTD,0)

		  from cte_curriculo_curso_etapa  cce with(nolock)    
	                                                       LEFT JOIN CTE_QUANTIDADE_OUTROS      CQO  ON (CQO.curriculo_id  = cce.curriculo_id AND 
														                                                 CQO.CURSO         = cce.CURSO        AND
		                                                                                                 CQO.Etapa         = cce.Etapa) 
													       LEFT JOIN CTE_QUANTIDADE_OUTROS_TIPO CQOR ON (CQOR.curriculo_id = cce.curriculo_id AND 
		                                                                                                 CQOR.CURSO        = cce.CURSO        and
		                                                                                                 CQOR.Etapa        = cce.Etapa        AND
													      										         CQOR.tipo_aluno   = 'REGULAR') 																							  
								                           LEFT JOIN CTE_QUANTIDADE_OUTROS_TIPO CQOI ON (CQOI.curriculo_id = cce.curriculo_id AND 
		                                                                                                 CQOI.CURSO        = cce.CURSO        and
		                                                                                                 CQOI.Etapa        = cce.Etapa        AND
													      										         CQOI.tipo_aluno   = 'IRREGULAR')     	