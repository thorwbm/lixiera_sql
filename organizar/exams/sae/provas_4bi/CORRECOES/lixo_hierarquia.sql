
select * from (
select distinct escolaid, escolanome, UsuariosTurma, TurmaNome, UsuarioSerie
from TMP_IMP_ALUNOS_4BI tmp

except

select distinct escolaid, escolanome, UsuariosTurma, TurmaNome, UsuarioSerie
from TMP_IMP_ALUNOS_4BI tmp join hierarchy_hierarchy esc on (esc.value = tmp.escolaid)
                            join hierarchy_hierarchy gra on (gra.name = tmp.UsuarioSerie and 
							                                 gra.parent_id = esc.id)
                            join hierarchy_hierarchy cla on (cla.value = tmp.UsuariosTurma and 
							                                 cla.parent_id = gra.id)
) as tab
where usuarioserie <> '3ª série / Extensivo ,Extensivo'


--#############################################################################################################################
insert into tmp_aux_hie_class_4bi
select distinct type = 'class', value =  usuariosturma,  name = turmanome, parent_id = null, escolaid, UsuarioSerie
--into tmp_aux_hie_class_4bi
from TMP_IMP_ALUNOS_4BI tmp left join hierarchy_hierarchy hie on (hie.value = tmp.UsuariosTurma and type = 'class')
where hie.id is null 

with cte_aux as (
select distinct escolaid, escolanome, UsuariosTurma, TurmaNome, UsuarioSerie, esc.id as esc_id, gra.id as gra_id
from TMP_IMP_ALUNOS_4BI tmp join hierarchy_hierarchy esc on (esc.value = tmp.escolaid)
                            join hierarchy_hierarchy gra on (gra.name = tmp.UsuarioSerie and 
							                                 gra.parent_id = esc.id)														
)

-- insert into hierarchy_hierarchy (type, value, name, parent_id)
select distinct type = 'class',  tmp.value,  tmp.name, parent_id = gra_id
  from tmp_aux_hie_class_4bi tmp  join cte_aux aux on (tmp.escolaid = aux.EscolaId and tmp.usuarioserie = aux.UsuarioSerie)
                           left join hierarchy_hierarchy xxx on (xxx.value = tmp.value)
  where gra_id is not null  and xxx.id is null 
--#############################################################################################################################

create or alter view vw_hierarquia_geral as 
select esc.id as escola_id, esc.value as escola_value, esc.name as escola_nome,  
       gra.id as grade_id, gra.value as grade_value, gra.name as grade_nome, 
	   cla.id as class_id, cla.value as class_value, cla.name as class_nome
from hierarchy_hierarchy esc left join hierarchy_hierarchy gra on (esc.id = gra.parent_id  and gra.type = 'grade' )
                             left join hierarchy_hierarchy cla on (gra.id = cla.parent_id and cla.type = 'class') 
where  esc.type = 'unity'
 
--#############################################################################################################################

select distinct tmp.EscolaId, escolanome, usuarioserie
into tmp_aux_hie_gra_4bi
  from TMP_IMP_ALUNOS_4BI tmp left join vw_hierarquia_geral esc on (tmp.EscolaId = esc.escola_value)
                              left join vw_hierarquia_geral gra on (tmp.EscolaId = gra.escola_value and gra.grade_nome = tmp.UsuarioSerie)
where gra.escola_id is null and tmp.usuarioserie <> '3ª série / Extensivo ,Extensivo'


insert into hierarchy_hierarchy (type, value, name, parent_id)
select distinct type = 'grade', value  =gra.value, name = aux.UsuarioSerie, parent_id = esc.id
from tmp_aux_hie_gra_4bi aux join vw_grade gra on (gra.name = aux.UsuarioSerie)
                             join hierarchy_hierarchy esc on (esc.value = aux.EscolaId)
						left join hierarchy_hierarchy xxx on (xxx.value = gra.value and xxx.parent_id = esc.id)
where xxx.id is null  
--#############################################################################################################################

select distinct name from hierarchy_hierarchy where name in (
select * from TMP_IMP_ALUNOS_4BI where escolanome = 'NÚCLEO DE EDUCAÇÃO E CULTURA TIPURA')

select * from hierarchy_hierarchy 
--update hierarchy_hierarchy set type = 'class'

--update hierarchy_hierarchy set parent_id = 34598
where name = 'TURMA CONVIDADA PARA REALIZAR O SIMULADO BIMESTRAL'
select * from TMP_IMP_ALUNOS_4BI where turmanome = 'TURMA CONVIDADA PARA REALIZAR O SIMULADO BIMESTRAL'


select * from vw_hierarquia_geral where escola_nome = 'NÚCLEO DE EDUCAÇÃO E CULTURA TIPURA'
order by class_nome

--#######################################################################################################

COLÉGIO SAIPH
Escola teste Avaliações Bimestrais


select * from hierarchy_hierarchy 
----update hierarchy_hierarchy set value = 'AB7F7E32-2399-4028-99A9-A02C6CB257B6'
where --value = '41f8ae1755363221e6769793682738a7' and 
      id = 14783 

select json_modify(usu.extra, '$.hierarchy.unity.value','AB7F7E32-2399-4028-99A9-A02C6CB257B6'), *
update usu set usu.extra = json_modify(usu.extra, '$.hierarchy.unity.value','AB7F7E32-2399-4028-99A9-A02C6CB257B6')
from auth_user usu 
where json_value(usu.extra, '$.hierarchy.unity.value') = '41f8ae1755363221e6769793682738a7' and
      json_value(usu.extra, '$.hierarchy.unity.name') = 'UNIVERSO CANAÃ DOS CARAJÁS'

	  ----------------------------------------------------------------------------

select * 
from hierarchy_category where name = 'Escola teste'
select * from hierarchy_hierarchy 
 where  name like 'Escola teste%'

 
select * 
--update usu set usu.extra = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, "unity":{"value":"1e7955dece8fa86b4a718b93e3e3b5cc","name":"Escola teste Avaliações Bimestrais"}, "class":{"value":"1c6c1b3a8513d63bce498165d0a8ef8e","name":"2ª série"}, "grade":{"value":"8156F05E-6020-43FA-B10B-B4DD3C2E0A32","name":"2ª série"}}}'
from auth_user usu
 where  json_value(usu.extra, '$.hierarchy.unity.value') like '1e7955dece8fa86b4a718b93e3e3b5cc' and id = 258984

 
 select * delete from hierarchy_hierarchy where parent_id = 22872
 select * delete from hierarchy_hierarchy where parent_id = 22871 
 select * delete from hierarchy_hierarchy where id = 22871 

 --------------------------------------------------------------------------------
  insert into hierarchy_hierarchy (type, value, name, parent_id)
 select distinct type= 'class', value= usuariosturma, name = turmanome, parent_id = 23793
 from TMP_IMP_ALUNOS_4BI
 where TurmaNome = 'MULTI IND' 


 ----------------------------------------------------------------------------------
 
select * from TMP_IMP_ALUNOS_4BI
update TMP_IMP_ALUNOS_4BI set usuarioserie = '8º ano'
where usuarioId = '426d8b29635025d3d7eb1b1fea043391'

--------------------------------------------------------------------------------------

 select alu.EscolaId, alu.escolanome, UsuariosTurma,TurmaNome, usuarioid
into #tmp_carga_aluno_4
from TMP_IMP_ALUNOS_4BI alu left join auth_user usu on (alu.UsuarioId = usu.public_identifier)
                            left join vw_hierarquia_geral hie on (alu.EscolaId = hie.escola_value and 
							                                      alu.UsuariosTurma = hie.class_value)
where usu.id is null 
  and hie.escola_id is  null 
  order by usuarioid

insert into hierarchy_hierarchy (type, value,name, parent_id)
select DISTINCT type = 'grade', value= 'EC369C51-44F6-4B5D-8E5D-2B3927C38B2F', name = '3ª Série', hie.id 
from #tmp_carga_aluno_4 CAR  JOIN hierarchy_hierarchy HIE ON (HIE.value = CAR.EscolaId)
                             LEFT join vw_hierarquia_geral HIEX ON (CAR.EscolaId = HIEX.escola_value AND 
                                                                      HIEX.grade_nome IN ('3ª série','extensivo'))
							 left join hierarchy_hierarchy xxx on (xxx.parent_id = hie.id and xxx.value =  'EC369C51-44F6-4B5D-8E5D-2B3927C38B2F')
WHERE HIEX.ESCOLA_ID IS NULL and 
      xxx.id is null 


---------------------------------------------------------------------------------------
 select alu.EscolaId, alu.escolanome, UsuariosTurma,TurmaNome, usuarioid, UsuarioSerie 
into #tmp_carga_aluno_5
from TMP_IMP_ALUNOS_4BI alu left join auth_user usu on (alu.UsuarioId = usu.public_identifier)
                            left join vw_hierarquia_geral hie on (alu.EscolaId = hie.escola_value and 
							                                      alu.UsuariosTurma = hie.class_value)
where usu.id is null 
  and hie.escola_id is  null 
  order by usuarioid
   

  insert into hierarchy_hierarchy (type, value,name, parent_id)
   select distinct type = 'class',  alu.UsuariosTurma, alu.TurmaNome, hie.grade_id
   from  #tmp_carga_aluno_5 alu left join vw_hierarquia_geral hie on (alu.EscolaId = hie.escola_value and 
                                                                            '3ª série' = hie.grade_nome)
