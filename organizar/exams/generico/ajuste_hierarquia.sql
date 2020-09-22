select * from hierarchy_hierarchy where name = 'EEIEF Tirando de Letra'

--insert into hierarchy_hierarchy (type, value, name, parent_id)
SELECT 'unity', newid(), 'EEIEF Tirando de Letra', null 


select * from VW_HIERARQUIA 
where nome = 'Única' and tipo= 'class'



select distinct turma from tmp_imp_aluno_tirando_letra


update tmp_imp_aluno_tirando_letra set grade = '9º Ano' where grade = '9° Ano'


--insert into hierarchy_hierarchy (type, value, name, parent_id)
select distinct type = 'grade',hie.codigo, hie.NOME, parent_id = 36662
from tmp_imp_aluno_tirando_letra tmp join vw_hierarquia hie on (hie.tipo = 'grade' and hie.nome = tmp.grade)
                                left join hierarchy_hierarchy xxx on (xxx.value = codigo and 
								                                      xxx.parent_id = 36662)
where xxx.id is null 


--   insert into hierarchy_hierarchy (type, value, name, parent_id)
select type = 'class',newid(), 'Única', grade_id 
  from vw_hierarquia_exam 
 where escola_nome = 'EEIEF Tirando de Letra'





