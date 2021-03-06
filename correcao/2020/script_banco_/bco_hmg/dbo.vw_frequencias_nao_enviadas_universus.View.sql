USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencias_nao_enviadas_universus]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_frequencias_nao_enviadas_universus] as
select freq.id as frequencia_id, curso.nome as curso, turma.nome as turma, disc.nome as disciplina, prof.nome as professor,
       aula.data_inicio as data_inicio_aula, freq.criado_em, freq.presente, aluno.nome as aluno,
	   (case when aluno.atributos is null then 'Aluno cadastrado diretamente no Educat'
	         when td.atributos is null or turma.atributos is null then 'Aluno não relacionado do DE/PARA'
			 else 'Motivo desconhecido'
		end) as motivo,
	   turma.atributos as turma_attr, td.atributos as td_attr, aluno.atributos as aluno_attr
  from academico_frequenciadiaria freq
       inner join academico_aula aula on aula.id = freq.aula_id
	   inner join academico_turmadisciplina td on td.id = aula.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_disciplina disc on disc.id = td.disciplina_id
	   inner join academico_curso curso on curso.id = turma.curso_id
	   inner join academico_professor prof on prof.id = aula.professor_id
	   inner join academico_aluno aluno on aluno.id = freq.aluno_id
 where freq.atributos is null
   and freq.criado_em <= '2019-04-17'
   and curso.nome <> 'Apple Test'
   and curso.nome = 'MEDICINA'
   and ((left(turma.nome, 1) in ('5', '6')
	and (disc.nome = 'Internato de Cirurgia' or disc.nome = 'Internato de Clínica Médica' or disc.nome = 'Internato de Pediatria'
		or (disc.nome = 'Internato de Ginecologia' and turma.nome = '6MP02')
		or (disc.nome = 'Internato de Obstetrícia' and turma.nome = '6MP01')
		or disc.nome = 'Internato de Pediatria' or disc.nome = 'Internato de Saúde do Idoso' or disc.nome = 'Internato de Saúde Mental'))
    or left(turma.nome, 1) in ('1', '2', '3', '4'))
GO
