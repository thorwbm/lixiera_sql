/******   ANTIGO 
--Cria atividades para critérios sem nenhuma atividade 
insert into atividades_atividade(criado_em, atualizado_em, criado_por, atualizado_por, criterio_turma_disciplina_id, status_id, valor, peso, nome, recuperacao)
select getdate(), getdate(), 2137, 2137, ctd.id, 1, cri.valor, 1, cri.nome, 0
  from atividades_criterio_turmadisciplina ctd 
       join atividades_criterio cri on cri.id = ctd.criterio_id
 where not exists (select top 1 1 from atividades_atividade atv where atv.criterio_turma_disciplina_id = ctd.id)

 ******/

 --Cria atividades para critérios sem nenhuma atividade 
insert into atividades_atividade(criado_em, atualizado_em, criado_por, atualizado_por, criterio_turma_disciplina_id, status_id, valor, peso, nome, recuperacao)
select getdate(), getdate(), 2137, 2137, ctd.id, 1, cri.valor, 1, cri.nome,  cri.recuperacao
  from atividades_criterio_turmadisciplina ctd 
       join atividades_criterio cri on cri.id = ctd.criterio_id
 where not exists (select top 1 1 from atividades_atividade atv where atv.criterio_turma_disciplina_id = ctd.id)