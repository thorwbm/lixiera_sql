select pro.descricao, hmg.descricao, pro.atualizado_em, pro.atualizado_por, hmg.atualizado_por --pro.* into bkp_competencias_competencia_2020_06_04

--update pro set pro.descricao = hmg.descricao
  from competencias_competencia pro join EDUCAT_HOMOLOGACAO.erp_hmg.[dbo].[competencias_competencia] hmg on (pro.id = hmg.id)
where pro.atualizado_por = 11444
pro.descricao <> hmg.descricao



select * from auth_user where id = 11444

