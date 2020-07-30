-- select top 10 * from atividades_complementares_tipo 
--insert into atividades_complementares_tipo (criado_em, atualizado_em, nome, criado_por, atualizado_por, atributos)
select distinct criado_em = getdate(), atualizado_em = getdate(), nome = edu.categoria, criado_por = 2137, atualizado_por = 2137, atributos = null 
  from atividade_complementar..VW_INTEGRACAO_EDUCAT edu left join atividades_complementares_tipo act on (act.nome collate database_default = edu.CATEGORIA collate database_default)
where act.id is null 



-- select top 10 * from atividades_complementares_modalidade 
--insert into atividades_complementares_modalidade (criado_em, atualizado_em, nome, criado_por, atualizado_por, atributos)
select distinct criado_em = getdate(), atualizado_em = getdate(), nome = edu.funcao, criado_por = 2137, atualizado_por = 2137, atributos = null
  from atividade_complementar..VW_INTEGRACAO_EDUCAT edu left join atividades_complementares_modalidade acm on (acm.nome collate database_default = edu.funcao collate database_default)
where acm.id is null 
  