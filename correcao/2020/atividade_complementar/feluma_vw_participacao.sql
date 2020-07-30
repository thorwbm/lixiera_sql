

--select * from  atividades_complementares_atividade
--select * from  atividades_complementares_modalidade order by nome
--select * from  atividades_complementares_subtipo
--select * from  atividades_complementares_tipo

select alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra, 
       atv.carga_horaria, atv.data_realizacao, atv.observacoes,
	   tpo.id as tipo_id, tpo.nome as tipo_nome,
	   mdl.id as modalidade_id, mdl.nome as modalidade_nome
  from atividades_complementares_atividade atv join curriculos_aluno cra on (cra.id = atv.curriculo_aluno_id)
                                               join academico_aluno  alu on (alu.id = cra.aluno_id)
											   join atividades_complementares_modalidade mdl on (mdl.id = atv.modalidade_id)
											   join atividades_complementares_tipo       tpo on (tpo.id = atv.tipo_id)
 where alu.nome = 'NATHALIA CAROLINE SOARES DOS SANTOS'