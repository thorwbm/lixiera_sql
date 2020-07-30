select distinct tda.* --  aluno.nome, td.disciplina_id, disc.nome, status.nome,  tda.status_matricula_disciplina_id , staMat.nome, status.id, staMat.id

---begin tran update tda set tda.status_matricula_disciplina_id = staMat.id
from academico_turmadisciplinaaluno tda
join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
join curriculos_aluno curralu on curralu.aluno_id = tda.aluno_id
join curriculos_disciplinaconcluida concluida on concluida.curriculo_aluno_id = curralu.id and concluida.disciplina_id = td.disciplina_id
join curriculos_statusdisciplina status on status.id = concluida.status_id
join academico_statusmatriculadisciplina staMat on (staMat.nome = status.nome)
join academico_aluno aluno on aluno.id = tda.aluno_id
join academico_disciplina disc on disc.id = td.disciplina_id
where status_matricula_disciplina_id is null

-- commit 
