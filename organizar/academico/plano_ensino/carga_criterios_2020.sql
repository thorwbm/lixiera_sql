select * from atividades_criterio_turmadisciplina


select * from planos_ensino_planoensino_criterio


select distinct ple.id as plano_ensino_id, ple.matriz,
                cur.id as curso_id, cur.nome as curso_nome, dis.id as disciplina_id,  dis.nome as disciplina_nome, 
                cri.id as criterio_id, cri.nome as criterio_nome, cri.valor as criterio_valor, cri.peso as criterio_peso, 
				cri.posicao as criterio_posicao, cri.recuperacao as criterio_recuperacao, cri.tipo_id as criterio_tipo_id
  from atividades_criterio_turmadisciplina ctd join academico_turmadisciplina tds on (tds.id = ctd.turma_disciplina_id)
                                               join academico_turma           tur on (tur.id = tds.turma_id)
											   join academico_curso           cur on (cur.id = tur.curso_id)
											   join academico_disciplina      dis on (dis.id = tds.disciplina_id)
											   join planos_ensino_planoensino ple on (ple.disciplina_id = tds.disciplina_id and
												                                      ple.curso_id      = tur.curso_id ) 
											   join atividades_criterio       cri on (cri.id = ctd.criterio_id)

where ple.matriz like '%2020 - 2' and 
      year(tur.inicio_vigencia) = 2020 and
	  month(tur.inicio_vigencia) > 6
order by cur.nome, dis.nome, cri.posicao, cri.nome


select * from atividades_criterio 
where id = 112

select * from planos_ensino_planoensino order by id desc