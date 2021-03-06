USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aluno_matricula_equivalente]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_aluno_matricula_equivalente] as 
with cte_aluno_matricula_equivalente as (
select alu.id, alu.nome as aluno_Nome, 
       crc.id as curriculo_matricula_id, crc.nome as curriculo_matricula, 
	   cra.nome as curriculo_aluno, 
	   dis.id as disciplina_id, dis.nome as disciplina_matriculada, 
	   tur.id as turma_id, tur.nome as turma_nome, caa.curriculo_id as curriculo_aluno_id, 
	   grd.id as gradedisciplina_matricula_id
  from academico_turmadisciplinaaluno tda join academico_turmadisciplina  tds on (tds.id = tda.turma_disciplina_id)
                                          join academico_disciplina       dis on (dis.id = tds.disciplina_id)
                                          join academico_aluno            alu on (alu.id = tda.aluno_id)
                                          join academico_turma            tur on (tur.id = tds.turma_id and turma_pai_id is null )
										  join curriculos_grade           gra on (gra.id = tur.grade_id)
										  join curriculos_gradedisciplina grd on (grd.disciplina_id = tds.disciplina_id and 
										                                          grd.grade_id      = gra.id)
										  join curriculos_curriculo       crc on (crc.id = gra.curriculo_id)
										  join curriculos_aluno           caa on (caa.aluno_id = alu.id and
										                                          caa.status_id = 13)
										  join curriculos_curriculo       cra on (cra.id = caa.curriculo_id)
	where crc.id <> caa.curriculo_id
) 									  
select EQU.ID AS ALUNO_ID, EQU.ALUNO_NOME, 
       EQU.curriculo_aluno_id , EQU.CURRICULO_ALUNO,
       EQU.CURRICULO_MATRICULA_ID AS CURRICULO_EQUIVALENTE_ID, EQU.CURRICULO_MATRICULA AS CURRICULO_EQUIVALENTE,
	   GDE.grade_disciplina_id AS GRADE_DISCIPLINA_ALUNO, 
	   GDE.grade_disciplina_equivalente_id AS GRADE_DISCIPLINA_EQUIVALENTE_ID,
	   GDE.disciplina_equivalente AS DISCIPLINA_EQUIVALENTE,
	   GDE.disciplina AS DISCIPLINA_ALUNO
  from cte_aluno_matricula_equivalente equ join vw_gradedisciplinaequivalente gde on (gde.curriculo_equivalente_id = equ.curriculo_matricula_id and 
                                                                                      gde.grade_disciplina_equivalente_id = equ.gradedisciplina_matricula_id and 
																				      gde.curriculo_id = equ.curriculo_aluno_id)
where gde.disciplina <> gde.disciplina_equivalente
GO
