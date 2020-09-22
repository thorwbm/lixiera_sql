/*******************************************************************************
     ESCOLA, GRADE, TURMA
*******************************************************************************/
select distinct usu.id, usu.name, 
       hie.escola_nome, 
	   hie.grade_nome, hie.grade_id, 
	   hie.turma_nome, hie.turma_id,json_value(usu.extra, '$.hierarchy.class.name') ,
       usu.extra,
		json_modify(
			json_modify(
				json_modify(usu.extra, '$.hierarchy.unity.value',hie.escola_id),
				'$.hierarchy.grade.value',hie.grade_id),
			'$.hierarchy.class.value',hie.turma_id)
-- begin tran update usu set usu.extra = json_modify(json_modify(json_modify(usu.extra, '$.hierarchy.unity.value',hie.escola_id),'$.hierarchy.grade.value',hie.grade_id),'$.hierarchy.class.value',hie.turma_id)
  from auth_user usu left join vw_hierarquia_exam hie on (hie.escola_nome = json_value(usu.extra, '$.hierarchy.unity.name') and 
                                                          hie.grade_nome  = json_value(usu.extra, '$.hierarchy.grade.name') and
													      hie.turma_nome  = json_value(usu.extra, '$.hierarchy.class.name') and 
													      hie.escola_id   = '9618df4005ddc7d05a384b22553fd393')
where json_value(usu.extra, '$.hierarchy.unity.name') = 'COLÉGIO DOM BOSCO (BALSAS)' and
      hie.escola_nome is not null 
  
-- commit
-- rollback


/*******************************************************************************
     ESCOLA, GRADE  -- ALUNO
*******************************************************************************/
select distinct usu.id, usu.name, 
       hie.escola_nome, 
	   hie.grade_nome, hie.grade_id, 
--   hie.turma_nome, hie.turma_id,json_value(usu.extra, '$.hierarchy.class.name') ,
       usu.extra,
			json_modify(
				json_modify(usu.extra, '$.hierarchy.unity.value',hie.escola_id),
				'$.hierarchy.grade.value',hie.grade_id)
--begin tran update usu set usu.extra = json_modify(json_modify(usu.extra, '$.hierarchy.unity.value',hie.escola_id),'$.hierarchy.grade.value',hie.grade_id)
  from auth_user usu left join vw_hierarquia_exam hie on (hie.escola_nome = json_value(usu.extra, '$.hierarchy.unity.name') and 
                                                          hie.grade_nome  = json_value(usu.extra, '$.hierarchy.grade.name') and 
													      hie.escola_id   = '9618df4005ddc7d05a384b22553fd393')
where json_value(usu.extra, '$.hierarchy.unity.name') = 'COLÉGIO DOM BOSCO (BALSAS)' and
      hie.escola_nome is not null 

-- commit 
-- rollback 

/*******************************************************************************
     ESCOLA  -- COORDENADOR
*******************************************************************************/
	select usu.id,  json_value(usu.extra, '$.hierarchy.unity.name') , json_value(usu.extra, '$.hierarchy.unity.value')
	       , json_value(usu.extra, '$.hierarchy.grade.name'),
		   usu.extra,
		   json_modify(usu.extra, '$.hierarchy.unity.value','9618df4005ddc7d05a384b22553fd393')
-- begin tran update usu set usu.extra = json_modify(usu.extra, '$.hierarchy.unity.value','9618df4005ddc7d05a384b22553fd393')
			from auth_user usu   
	where json_value(usu.extra, '$.hierarchy.unity.name')= 'COLÉGIO DOM BOSCO (BALSAS)' and 
	      json_value(usu.extra, '$.hierarchy.unity.value') in (N'4', N'dae1e5d16ceecbbc14586bb1b8a9b418')


-------------------------------------------------------------------


SELECT distinct json_value(usu.extra, '$.hierarchy.unity.value')
from auth_user usu   
	where json_value(usu.extra, '$.hierarchy.unity.name')= 'COLÉGIO DOM BOSCO (BALSAS)'
	AND json_value(usu.extra, '$.hierarchy.unity.value') <>'9618df4005ddc7d05a384b22553fd393'

	


	   select id, name,
	   json_value(usu.extra, '$.hierarchy.unity.name') as escola,
	   json_value(usu.extra, '$.hierarchy.grade.name') as grade, 
	   json_value(usu.extra, '$.hierarchy.class.name') as turma
	   from auth_user usu
	   where json_value(usu.extra, '$.hierarchy.unity.name') = 'COLÉGIO DOM BOSCO (BALSAS)' 


select * from hierarchy_hierarchy where value = '9618df4005ddc7d05a384b22553fd393'


--------------------------------------------------------------------------------
-- encontrar as grades faltantes
--------------------------------------------------------------------------------


select distinct grade_nome
from vw_usuario
where escola_nome =  'COLÉGIO DOM BOSCO (BALSAS)' 
except
select distinct name from hierarchy_hierarchy where parent_id in (36479)


-- inserir as grades faltantes 
--  insert hierarchy_hierarchy (type, value, name, parent_id)
	select distinct type = 'grade', grade_id as value, grade_nome as name, parent_id = 36479
	  from vw_usuario where escola_nome =  'COLÉGIO DOM BOSCO (BALSAS)' and 
	      grade_nome  in ( select distinct grade_nome
							from vw_usuario
							where escola_nome =  'COLÉGIO DOM BOSCO (BALSAS)' 
							except
							select distinct name from hierarchy_hierarchy where parent_id in (36479))


	select distinct grade_nome, escola_id from vw_hierarquia_exam 
	where escola_nome =  'COLÉGIO DOM BOSCO (BALSAS)' and 
	      escola_id = '9618df4005ddc7d05a384b22553fd393'

select * from hierarchy_hierarchy 
where name = 'COLÉGIO DOM BOSCO (BALSAS)'




select * from auth_user usu 
where json_value(usu.extra, '$.hierarchy.unity.value') = 'dae1e5d16ceecbbc14586bb1b8a9b418'