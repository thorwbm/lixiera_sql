/*******************************************************************************
1) aluno enturmado sem contrato assinado
nome do curso
nome do curriculo
nome do aluno 
status curricular ativo = cursando
status da enturmação ativa = cursando
*******************************************************************************/

select distinct 
       dag.curso_nome, crc.nome as curriculo_nome, dag.aluno_nome, 
       dag.status_mat_dis_nome as matricula_status, 
	   csa.nome as curricular_status
  from vw_curriculo_curso_turma_disciplina_aluno_grade dag 
                           join academico_turma        tur on (tur.id = dag.turma_id)
						   join curriculos_aluno       cra on (cra.id = dag.tda_curriculo_aluno_id)
						   join curriculos_statusaluno csa on (csa.id = cra.status_id)
						   join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)
				      left join contratos_contrato     con on (con.curriculo_aluno_id = dag.tda_curriculo_aluno_id and 
					                                           con.vigente = 1)
where year(tur.inicio_vigencia) = 2020 and
      month(tur.inicio_vigencia) > 6 and 
	  con.id is null 
	  
	  and csa.nome = 'cursando' -- curricular_status
	  and dag.status_mat_dis_nome = 'cursando' --matricula_status
order by aluno_nome

