SELECT distinct acc.aluno_id, acc.aluno_nome, 
       acc.curriculo_id, acc.curriculo_nome, 
	   acc.curso_nome, acc.statuscurriculo_nome, 
	   acfi.formaingresso_nome
	FROM vw_aluno_curriculo_curso_turma_etapa_discplina acc join vw_aluno_curriculo_forma_ingresso acfi on (acc.aluno_id     = acfi.aluno_id and 
	                                                                                                        acc.curriculo_id = acfi.curriculo_id and 
																											acc.curso_id     = acfi.curso_id)
where turma_iniciovigencia >= '2019-07-01' and  
      ACC.CURRICULOALUNO_data_admissao = (select max(crax.data_admissao) from curriculos_aluno crax  join curriculos_curriculo   crcx on (crcx.id = ACC.curriculo_id)
	           where crax.aluno_id = ACC.aluno_id and 
	                 crcx.curso_id = ACC.curso_id) AND 
	  acc.statuscurriculo_id not in (19)
order by 2