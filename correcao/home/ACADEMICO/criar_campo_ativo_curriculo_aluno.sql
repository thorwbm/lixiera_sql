select * from curriculos_statusaluno



--  ALTER TABLE curriculos_aluno ADD ativo bit;
--  update curriculos_aluno set ativo = 0
--  ALTER TABLE curriculos_aluno alter column ativo bit not null;

select * 
-- update alu set alu.ativo = 1
from curriculos_aluno alu where status_id = 13 and ativo = 0

select * 
-- update alu set alu.ativo = 1
from curriculos_aluno alu where status_id = 16 and ativo = 0

select cra.*
--  update cra set cra.ativo = 1
from (
select aluno_id, max(id) as curriculo_aluno_id from curriculos_aluno where aluno_id not in (
select aluno_id from curriculos_aluno where ativo = 1 ) 
group by aluno_id) as tab join curriculos_aluno cra on (tab.curriculo_aluno_id = cra.id)
														



select aluno_id , count(curriculo_id)
from curriculos_aluno
where ativo = 1
group by aluno_id
having  count(curriculo_id)> 1
order by 2 desc


select * from curriculos_aluno where aluno_id = 48832