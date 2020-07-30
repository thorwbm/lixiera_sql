ALTER VIEW VW_ALUNOS_MATRICULADOS_PROUNI AS 
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
			where cast(aula.data_inicio as date) >= '2019-07-14' and 
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
	 
		
	-- *** CONTAGEM PROUNI
	, CTE_QUANTIDADE_PROUNI AS (
		SELECT curriculo_id, CURSO, Etapa, QTD = COUNT(1) 
		FROM cte_alunosMatriculados_proUni
		GROUP BY curriculo_id, CURSO, Etapa
	)
	
	-- *** CONTAGEM PROUNI POR TIPO
	, CTE_QUANTIDADE_PROUNI_TIPO AS (
		SELECT curriculo_id, CURSO, Etapa, tipo_aluno, QTD = COUNT(1) 
		FROM cte_alunosMatriculados_proUni
		GROUP BY curriculo_id, CURSO, Etapa, tipo_aluno
	)

	-- **** CONTAGEM ALUNOS 
	, CTE_QUANTIDADE AS (
		SELECT curriculo_id, CURSO, Etapa,  QTD = COUNT(DISTINCT aluno_id) 
		FROM cte_alunosMatriculados
		GROUP BY curriculo_id, CURSO, Etapa
	)
	
	-- **** CONTAGEM ALUNOS TRANCADOS
	, CTE_QUANTIDADE_TRANCADOS AS (
		SELECT curriculo_id, CURSO, Etapa,  QTD = COUNT(DISTINCT aluno_id) 
		FROM cte_alunosMatriculados
		WHERE STATUS_ID = 18
		GROUP BY curriculo_id, CURSO, Etapa
	)

	-- **** CONTAGEM ALUNOS ATIVOS
	, CTE_QUANTIDADE_ATIVOS AS (
		SELECT curriculo_id, CURSO, Etapa,  QTD = COUNT(DISTINCT aluno_id) 
		FROM cte_alunosMatriculados
		WHERE STATUS_ID = 13
		GROUP BY curriculo_id, CURSO, Etapa
	)
	

		select distinct cce.curriculo_id, cce.curriculo_nome, cce.curso, cce.Etapa,   
		       forma_ingresso_proUni          = ISNULL(CPT.QTD,0),
			   forma_ingresso_proUni_regular  = ISNULL(CPTR.QTD,0) ,
			   forma_ingresso_proUni_iregular = ISNULL(CPTI.QTD,0),			   
			   ALUNOS                         = ISNULL(TOT.QTD,0), 
			   TRANCADOS                      = ISNULL(TRA.QTD,0),
			   ALUNOS_VALIDOS                 = ISNULL(ATI.QTD,0)

		  from cte_curriculo_curso_etapa  cce with(nolock) LEFT JOIN CTE_QUANTIDADE_PROUNI      CPT  ON (CPT.curriculo_id  = cce.curriculo_id AND 
		                                                                                                 CPT.CURSO         = cce.CURSO        and
		                                                                                                 CPT.Etapa         = cce.Etapa) 
													       LEFT JOIN CTE_QUANTIDADE_PROUNI_TIPO CPTR ON (CPTR.curriculo_id = cce.curriculo_id AND 
		                                                                                                 CPTR.CURSO        = cce.CURSO        and
		                                                                                                 CPTR.Etapa        = cce.Etapa        AND
													      										         CPTR.tipo_aluno   = 'REGULAR') 																							  
								                           LEFT JOIN CTE_QUANTIDADE_PROUNI_TIPO CPTI ON (CPTI.curriculo_id = cce.curriculo_id AND 
		                                                                                                 CPTI.CURSO        = cce.CURSO        and
		                                                                                                 CPTI.Etapa        = cce.Etapa        AND
													      										         CPTI.tipo_aluno   = 'IRREGULAR')   			  
								                           LEFT JOIN CTE_QUANTIDADE             TOT  ON (TOT.curriculo_id  = cce.curriculo_id AND 
		                                                                                                 TOT.CURSO         = cce.CURSO        and														                                                 
		                                                                                                 TOT.Etapa         = cce.Etapa          ) 																																				  
								                           LEFT JOIN CTE_QUANTIDADE_TRANCADOS   TRA  ON (TRA.curriculo_id  = cce.curriculo_id AND
		                                                                                                 TRA.CURSO         = cce.CURSO        and 
		                                                                                                 TRA.Etapa         = cce.Etapa          )    																																				  
								                           LEFT JOIN CTE_QUANTIDADE_ATIVOS      ATI  ON (ATI.curriculo_id  = cce.curriculo_id AND
		                                                                                                 ATI.CURSO         = cce.CURSO        and 
		                                                                                                 ATI.Etapa         = cce.Etapa          )        
	
