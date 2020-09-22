
  
WITH cte_grade AS (  
   SELECT distinct TYPE AS TIPO, name AS NOME,  max(value)  AS CODIGO   
    from hierarchy_hierarchy WHERE type = 'grade'  
    group by name, type  
)  
 , cte_turma as (  
   SELECT distinct TYPE AS TIPO, name AS Turma_nome, max(value) AS Turma_id  
    from hierarchy_hierarchy WHERE type = 'class'   
    group by name, type  
)  
 , cte_escola as (  
   SELECT distinct TYPE AS TIPO, name AS escola_nome, max(value) AS escola_id  
    from hierarchy_hierarchy WHERE type = 'unity'   
    group by name, type  
)  
  
SELECT * FROM CTE_GRADE  UNION  
SELECT * FROM CTE_TURMA  UNION   
SELECT * FROM CTE_ESCOLA 

drop table tmp_herarchy_hierarchy

select ROW_NUMBER() OVER(ORDER BY name ASC) as id, * 
-- into tmp_hierarchy_hierarchy
from (
select distinct tab.tipo as type, escola_nome as name, escola_id as value, parent_id = 0 
from (
SELECT distinct TYPE AS TIPO, name AS escola_nome, max(value) AS escola_id  
    from hierarchy_hierarchy WHERE type = 'unity'   and name <> '' 
    group by name, type  ) as tab join hierarchy_hierarchy hie on (hie.name = escola_nome and hie.type = 'unity') ) as tab2
	order by name

-- update tmp_hierarchy_hierarchy set parent_id = null

select * from hierarchy_hierarchy


insert into tmp_hierarchy_hierarchy(type, name, value, parent_id)
select distinct tab.tipo, tab.nome, tab.codigo, fin.id as parente_id_final from (
SELECT distinct TYPE AS TIPO, name AS NOME,  max(value)  AS CODIGO   
    from hierarchy_hierarchy WHERE type = 'grade'    and name <> '' 
    group by name, type ) as tab join hierarchy_hierarchy hie on (hie.name = tab.nome and hie.type = 'grade') 
	                             join hierarchy_hierarchy pai on (pai.id = hie.parent_id and pai.type = 'unity')
								 join tmp_hierarchy_hierarchy fin on (fin.name = pai.name and fin.type = 'unity')


with cte_hie as (
select 
  from hierarchy_hierarchy tur join hierarchy_hierarchy gra on (gra.type = 'grade' and
                                                                tur.type = 'class' and
																tur.parent_id = gra.id)
							   join hierarchy_hierarchy esc on (esc.type = 'unity' and
							                                    esc.id = gra.parent_id)
)
;

with cte_turma as (
select distinct tipo, turma_nome, turma_id, gra.name as grade_nome, esc.name as escola_nome  from (
SELECT distinct TYPE AS TIPO, name AS Turma_nome, max(value) AS Turma_id  
    from hierarchy_hierarchy WHERE type = 'class'   
    group by name, type) as tab join hierarchy_hierarchy cla on (cla.type = 'class' and 
	                                                              cla.name = tab.Turma_nome and 
																  cla.name <> '')
							    join hierarchy_hierarchy gra on (gra.type = 'grade' and
								                                 gra.id = cla.parent_id)
							    join hierarchy_hierarchy esc on (esc.type = 'unity' and
								                                 esc.id = gra.parent_id)
)

    
insert into tmp_hierarchy_hierarchy(type, name, value, parent_id)
    select distinct  tur.TIPO, tur.Turma_nome, tur.Turma_id, gra.id  
	from cte_turma tur join tmp_hierarchy_hierarchy esc on (tur.escola_nome = esc.name and 
	                                                                 esc.type = 'unity')
							    join tmp_hierarchy_hierarchy gra on (gra.type = 'grade' and
								                                     gra.name = tur.grade_nome and
																	 gra.parent_id = esc.id)
								 





create view vw_hierarquia_exam as 
select esc.value as escola_id, esc.name as escola_nome, 
       gra.value as grade_id, gra.name as grade_nome, 
	   cla.value as turma_id, cla.name as turma_nome
  from hierarchy_hierarchy esc left join hierarchy_hierarchy gra on (esc.id = gra.parent_id and
                                                                               esc.type = 'unity' and 
																			   gra.type = 'grade')
										 left  join hierarchy_hierarchy cla on (cla.type = 'class' and
										                                       gra.id = cla.parent_id)

select * from vw_hierarquia_exam

where escola_nome = '3º ENSINO MÉDIO'
intersect
select * from vw_tmp_hierarquia 
where escola_nome = '3º ENSINO MÉDIO'



select * from vw_tmp_hierarquia where escola_id = 'd07e0a07387e91cde8c81768443f235b'
select * from vw_tmp_hierarquia where escola_nome = 'Centro de Integração Escolar Dom Bosco'

select * from vw_hierarquia_exam where escola_id = 'd07e0a07387e91cde8c81768443f235b'
select * from vw_hierarquia_exam where escola_nome = 'Centro de Integração Escolar Dom Bosco'