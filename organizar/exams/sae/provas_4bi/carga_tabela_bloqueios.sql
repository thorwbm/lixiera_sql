
select *  from (
select escolaNome,	[Serie], ingles, espanhol, artes,filosofia, sociologia, data_aplicacao from tmp_imp_agendamento_4bi_1serie union 
select escolaNome,	[Serie], ingles, espanhol, artes,filosofia, sociologia, data_aplicacao from tmp_imp_agendamento_4bi_2serie union 
select escolaNome,	[Serie], ingles, espanhol, artes,filosofia, sociologia, data_aplicacao from tmp_imp_agendamento_4bi_3serie  union 


select [Nome da escola],	[Série], ingles= null, espanhol= null, artes= null,filosofia = null, sociologia = null,[Data de Aplicação] from tmp_imp_agendamento_4bi_4ano    union 
select [Nome da escola],	[Série], ingles= null, espanhol= null, artes= null,filosofia = null, sociologia = null,[Data de Aplicação]  from tmp_imp_agendamento_4bi_5ano    union 


select f1,	[Série], inglês, espanhol, artes,filosofia = null, sociologia = null,[Data de Aplicação] from tmp_imp_agendamento_4bi_6ano  union 
select f1,	[Série], inglês, espanhol, artes,filosofia = null, sociologia = null,[Data de Aplicação] from tmp_imp_agendamento_4bi_7ano  union 
select f1,	[Série], inglês, espanhol, artes,filosofia = null, sociologia = null,[Data de Aplicação] from tmp_imp_agendamento_4bi_8ano  union 
select f1,	[Deseja participar do Desafio Sae Teens?], inglês, espanhol, artes,filosofia = null, sociologia = null,[Data de Aplicação] from tmp_imp_agendamento_4bi_9ano  
) as tab
where data_aplicacao is null 

 select * from tmp_imp_agendamento_4bi_9ano 
select distinct sae.escolanome, hie.id, hie.name --into #tmp 
from sae_4bi_ultima_semana sae join TMP_IMP_ALUNOS_4BI alu on (alu.EscolaNome = sae.EscolaNome)
join hierarchy_hierarchy hie on (hie.type = 'unity' and alu.EscolaId = hie.value)
                                                      
where hie.id is null 

[Deseja participar do Desafio Sae Teens?]


select  escolanome from #tmp
group by escolanome 
having count(id) > 1


select *
  from hierarchy_hierarchy 
 where name in (
select  escolanome from #tmp
group by escolanome 
having count(id) > 1
) 
order by name 

select * from vw_hierarquia_geral where escola_id in (15119,
15126) order by escola_id

select *
--  update usu set usu.extra = JSON_MODIFY(usu.extra, '$.hierarchy.unity.value', 'daebf736117dee7255656f1a49817ce8')
from auth_user usu where json_value(extra, '$.hierarchy.unity.value') = '98ad759e93ca0ca84349bf0132e855fd'

select * from vw_coordenador where usuario_id in (
262463,
262383,
262149
)


select *
-- delete 
from hierarchy_hierarchy where id = 35545


select * from vw_hierarquia_geral where escola_id in (15119,15126) order by escola_id


select distinct usu.extra from auth_user usu where json_value(extra, '$.hierarchy.unity.value') = 'f4059c6a908a27ece45fee9277c6de26'

select distinct usu.extra from auth_user usu where json_value(extra, '$.hierarchy.unity.value') = '99e2bdef69fdd07372531d907ac68cb8'

select * from TMP_IMP_ALUNOS_4BI where EscolaNome = 'CENTRO EDUCACIONAL PINGO DE GENTE'




select * from tmp_imp_4bi_agendamento_blk

--insert into tmp_imp_4bi_agendamento_blk
select f1,	[Deseja participar do Desafio Sae Teens?], inglês, espanhol, artes,filosofia = null, sociologia = null,[Data de Aplicação] from tmp_imp_agendamento_4bi_9ano  