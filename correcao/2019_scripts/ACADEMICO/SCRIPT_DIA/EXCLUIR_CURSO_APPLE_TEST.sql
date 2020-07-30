select * from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME = 'turma_id' and TABLE_NAME not like 'log%'

	
		select * 
		-- begin tran delete 
		from  academico_curso where id = 500


select * 
-- begin tran delete 
from academico_turma                               
where curso_id = 500 -- 665

select * 
-- begin tran delete 
from academico_turmadisciplina
where turma_id = 665  -- 10050


select * 
-- begin tran delete 
from academico_grupoaula
where turma_disciplina_id = 10050

select * 
-- begin tran delete 
from academico_aula
where grupo_id in (select id from academico_grupoaula where turma_disciplina_id = 10050)


select * 
-- begin tran delete
from academico_frequenciadiaria
where aula_id in (select id from academico_aula where grupo_id in (select id from academico_grupoaula where turma_disciplina_id = 10050))


select * 
-- begin tran delete 
from academico_turmadisciplinaaluno 
where turma_disciplina_id = 10050

-- rollback 

-- commit

select * from sys.tables where name like '%_081019__%'