
select frming.curso_nome, frming.curriculo_nome, frming.statusalunoCurriculo_nome, 
       frming.aluno_nome, pessoa.cpf as CPF, usu.email,
       frming.FormaIngresso_nome, curalu.ano_admissao, curalu.periodo_admissao, 
	   etapa.etapa, STS.nome as status_curriculoaluno,
	   curalu.ano_admissao, curalu.periodo_admissao, vwalu.TEL1, vwalu.TEL2, vwalu.TEL3
  from curriculos_aluno curalu with(nolock) join vw_aluno_curriculo_forma_ingresso frming with(nolock) on (curalu.curriculo_id = frming.curriculo_id and 
                                                                                                           curalu.aluno_id     = frming.aluno_id)	
											join curriculos_statusaluno            STS     with(nolock) on (sts.id = curalu.status_id)								    
											join curriculos_grade                  grade   with(nolock) on (grade.id = curalu.grade_id)
											join academico_etapa                   etapa   with(nolock) on (etapa.id = grade.etapa_id)
											join academico_aluno                   aluno   with(nolock) on (aluno.id = curalu.aluno_id)
		                            		join auth_user                         usu     with(nolock) on (usu.id = aluno.user_id)
                                       left join pessoas_pessoa                    pessoa  with(nolock) on (pessoa.id = aluno.pessoa_id)
		                               left join carga_universus.dbo.VWALUNO       vwalu   with(nolock) on (json_value(curalu.atributos, '$.universus_key.codescola')    = vwalu.codescola and 
                                                                                                            json_value(curalu.atributos, '$.universus_key.codaluno')     = vwalu.CODALUNO)
order by 1, 2, 4, 7