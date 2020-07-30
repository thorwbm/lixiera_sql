with cte_alunosMatriculados as (
		select distinct curso.nome as CURSO, turma.nome as TURMA, etapa.nome as Etapa, aluno.nome as ALUNO, aluno.id as aluno_id,
		                aluno.ra as RA, pessoaAluno.cpf as CPF_ALUNO, cast(pessoaAluno.data_nascimento as date) as DTANASC_ALUNO,
						userAluno.email as EMAIL_ALUNO, crc.id as curriculo_id, crc.nome as curriculo_nome, 
						frming.id as forma_ingresso_id, frming.nome as forma_ingresso_nome, alucurr.id as alucurriculo_id, 
						tpmat.id as tipo_matricula_id, tpmat.nome as tipo_matricula_nome
			from academico_aula                 aula        with(nolock)
			join academico_turmadisciplina      td          with(nolock) on (td.id          = aula.turma_disciplina_id)
			join academico_turma                turma       with(nolock) on (turma.id       = td.turma_id			  )
		--	join academico_disciplina           disc        with(nolock) on (disc.id        = td.disciplina_id		  )
			join academico_turmadisciplinaaluno tda         with(nolock) on (td.id          = tda.turma_disciplina_id )
			join academico_tipomatricula        tpmat       with(nolock) on (tpmat.id       = tda.tipo_matricula_id   )
			join academico_aluno                aluno       with(nolock) on (aluno.id       = tda.aluno_id			  )
			join academico_curso                curso       with(nolock) on (curso.id       = turma.curso_id		  )
		--	join academico_professor            prof        with(nolock) on (prof.id        = aula.professor_id		  )
			join pessoas_pessoa                 pessoaAluno with(nolock) on (pessoaAluno.id = aluno.pessoa_id		  )
	--		join pessoas_pessoa                 pessoaProf  with(nolock) on (pessoaProf.id  = prof.pessoa_id		  )
			join auth_user                      userAluno   with(nolock) on (userAluno.id   = aluno.user_id			  )
		--	join auth_user                      userProf    with(nolock) on (userProf.id    = prof.user_id			  )
			join academico_etapaano             etapaano    with(nolock) on (etapaano.id    = turma.etapa_ano_id	  )
			join academico_etapa                etapa       with(nolock) on (etapa.id       = etapaano.etapa_id		  )
			join curriculos_aluno               alucurr     with(nolock) on (aluno.id       = alucurr.aluno_id		  )
			join curriculos_grade               grade       with(nolock) on (grade.id       = alucurr.grade_id		  )
			join curriculos_curriculo           crc         with(nolock) on (crc.id          = alucurr.curriculo_id   )
			join curriculos_formaingresso       frming      with(nolock) on (frming.id       = alucurr.metodo_admissao_id)
			where cast(aula.data_inicio as date) >= '2019-07-14'
			  and alucurr.status_id = 13 -- cursando
			  and curso.id in (1,2,4,5)
),
	cte_curriculo_etapa as (
	select distinct curriculo_id, etapa, curriculo_nome
	from cte_alunosMatriculados
),

	cte_alunos_tipo_regular as (
		select DISTINCT curriculo_id, Etapa, aluno_id, tipo_aluno =  'REGULAR' 
		  from cte_alunosMatriculados 
		  WHERE tipo_matricula_id = 1
), 

	cte_alunos_tipo_iregular as (
		select DISTINCT curriculo_id, Etapa, aluno_id, tipo_aluno =  'IREGULAR' 
		  from cte_alunosMatriculados alu 
		  WHERE not exists (select 1 from cte_alunos_tipo_regular aux where aux.aluno_id = alu.aluno_id )
),

	cte_forma_ingresso_pro_uni as (
		select cce.curriculo_id, cce.Etapa,   count(distinct alu.alucurriculo_id) as quantidade		       
		  from  cte_curriculo_etapa cce with(nolock) left join cte_alunosMatriculados alu with(nolock) on (cce.curriculo_id = alu.curriculo_id and 
		                                                                                                   cce.Etapa        = alu.Etapa and 
																										   forma_ingresso_id in (9,21))
         group by cce.curriculo_id, cce.Etapa

),
 
    cte_forma_ingresso_pro_uni_regular as (
		select cce.curriculo_id, cce.Etapa,   count(distinct alu.alucurriculo_id) as quantidade		       
		  from  cte_curriculo_etapa cce with(nolock) left join cte_alunos_tipo_regular TIP WITH(NOLOCK) ON (cce.curriculo_id = TIP.curriculo_id AND 
		                                                                                                    cce.Etapa        = TIP.Etapa)
		                                             left join cte_alunosMatriculados alu with(nolock) on (cce.curriculo_id = alu.curriculo_id and 
		                                                                                                   cce.Etapa        = alu.Etapa and 														  
																								           ALU.aluno_id     = TIP.aluno_id  and 
																										   alu.forma_ingresso_id in (9,21)) 
		  group by cce.curriculo_id, cce.Etapa
),

    cte_forma_ingresso_pro_uni_Iregular as (
		select cce.curriculo_id, cce.Etapa,   count(distinct alu.alucurriculo_id) as quantidade		       
		  from  cte_curriculo_etapa cce with(nolock) left join cte_alunos_tipo_Iregular TIP WITH(NOLOCK) ON (cce.curriculo_id = TIP.curriculo_id AND 
		                                                                                                    cce.Etapa        = TIP.Etapa)
		                                             left join cte_alunosMatriculados alu with(nolock) on (cce.curriculo_id = alu.curriculo_id and 
		                                                                                                   cce.Etapa        = alu.Etapa and 														  
																								            ALU.aluno_id     = TIP.aluno_id and 
																										   alu.forma_ingresso_id in (9,21)) 
		  group by cce.curriculo_id, cce.Etapa
),

    cte_forma_ingresso_outros as (
		select cce.curriculo_id, cce.Etapa,   count(distinct alu.alucurriculo_id) as quantidade		       
		  from  cte_curriculo_etapa cce with(nolock) left join cte_alunosMatriculados alu with(nolock) on (cce.curriculo_id = alu.curriculo_id and 
		                                                                                                   cce.Etapa        = alu.Etapa and 
																										   forma_ingresso_id  not in (9,21))
         group by cce.curriculo_id, cce.Etapa

)		
		
		select distinct cce.curriculo_nome, cce.Etapa, 
		       forma_ingresso_proUni = proUni.quantidade,
			   forma_ingresso_proUni_regular = pruReg.quantidade,
			   forma_ingresso_proUni_Iregular = pruIReg.quantidade, 
			   forma_ingresso_outras = outros.quantidade
		  from cte_curriculo_etapa  cce with(nolock) join cte_forma_ingresso_pro_uni               proUni on (cce.curriculo_id = proUni.curriculo_id and 
		                                                                                                            cce.Etapa        = proUni.Etapa)
                                                           join cte_forma_ingresso_pro_uni_regular       pruReg on (cce.curriculo_id = pruReg.curriculo_id and 
		                                                                                                            cce.Etapa        = pruReg.Etapa)
                                                            join cte_forma_ingresso_pro_uni_Iregular pruIReg on (cce.curriculo_id = pruIReg.curriculo_id and 
		                                                                                                         cce.Etapa        = pruIReg.Etapa)
														   join cte_forma_ingresso_outros                outros  on (cce.curriculo_id = outros.curriculo_id and 
		                                                                                                             cce.Etapa        = outros.Etapa)
		  order by 1,2
		  --group by nome_curriculo, Etapa

---select * from ACADEMICO_TIPOMATRICULA
		  --