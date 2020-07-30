
begin tran
-- ###############################################################################################
--------------------------------------------------------------------------------------------------
-- alterar na turma disciplina aluno
--------------------------------------------------------------------------------------------------
--select * 
update tda set tda.turma_disciplina_id = 15524 -- tur.nome = 'P013S07A201T'   dis.nome = 'PSICOPATOLOGIA CLINICA'
from  academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)
                                         join academico_turma           tur on (tur.id = tds.turma_id)
										 join academico_disciplina      dis on (dis.id = tds.disciplina_id)
where tur.nome = 'P013S07A201T' and 
       dis.nome = 'PSICOPATOLOGIA' 
-- ###############################################################################################
--------------------------------------------------------------------------------------------------
-- alterar na tabela aula
--------------------------------------------------------------------------------------------------
--select * 
update aul set aul.turma_disciplina_id = 15524 -- tur.nome = 'P013S07A201T'   dis.nome = 'PSICOPATOLOGIA CLINICA'
from   academico_turmadisciplina tds  join academico_turma           tur on (tur.id = tds.turma_id)
								      join academico_disciplina      dis on (dis.id = tds.disciplina_id)
									  join academico_aula            aul on (tds.id = aul.turma_disciplina_id)
where tur.nome = 'P013S07A201T' and 
       dis.nome = 'PSICOPATOLOGIA'
-- ###############################################################################################
--------------------------------------------------------------------------------------------------
-- alterar na tabela grupo aula
--------------------------------------------------------------------------------------------------
--select aul.*
update aul set aul.turma_disciplina_id = 15524 -- tur.nome = 'P013S07A201T'   dis.nome = 'PSICOPATOLOGIA CLINICA'
from   academico_turmadisciplina tds  join academico_turma           tur on (tur.id = tds.turma_id)
								      join academico_disciplina      dis on (dis.id = tds.disciplina_id)
									  join academico_grupoaula       aul on (tds.id = aul.turma_disciplina_id)
where tur.nome = 'P013S07A201T' and 
       dis.nome = 'PSICOPATOLOGIA'
-- ###############################################################################################
--------------------------------------------------------------------------------------------------
-- alterar na tabela AGENDAMENTO
--------------------------------------------------------------------------------------------------
--select aul.* 
 update aul set aul.turma_disciplina_id = 15524 -- tur.nome = 'P013S07A201T'   dis.nome = 'PSICOPATOLOGIA CLINICA'
from   academico_turmadisciplina tds  join academico_turma           tur on (tur.id = tds.turma_id)
								      join academico_disciplina      dis on (dis.id = tds.disciplina_id)
									  join aulas_agendamento      aul on (tds.id = aul.turma_disciplina_id)
where tur.nome = 'P013S07A201T' and 
       dis.nome = 'PSICOPATOLOGIA'
-- ###############################################################################################
--------------------------------------------------------------------------------------------------
-- alterar na tabela TURMA DISCIPLINA PROFESSOR
--------------------------------------------------------------------------------------------------
--select aul.* 
 update aul set aul.turma_disciplina_id = 15524 -- tur.nome = 'P013S07A201T'   dis.nome = 'PSICOPATOLOGIA CLINICA'
from   academico_turmadisciplina tds  join academico_turma           tur on (tur.id = tds.turma_id)
								      join academico_disciplina      dis on (dis.id = tds.disciplina_id)
									  join academico_turmadisciplinaprofessor      aul on (tds.id = aul.turma_disciplina_id)
where tur.nome = 'P013S07A201T' and 
       dis.nome = 'PSICOPATOLOGIA'

-- commit 
-- ROLLBACK 
