USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencias_pendentes_integracao]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_frequencias_pendentes_integracao] as
select tda.id as turma_disciplina_aluno_id, tda.turma_disciplina_id, freq.id as frequencia_id, freq.atributos as freq_attr, aula.data_envio_frequencia, td.atributos as td_attr, tda.atributos as tda_attr, turma.nome as turma_attr, aluno.nome as aluno, curso.nome as curso, turma.nome as turma, disc.nome as disciplina, tda.criado_em, tda.criado_por
  from academico_frequenciadiaria freq
       inner join academico_aula aula on aula.id = freq.aula_id
	   inner join academico_turmadisciplina td on td.id = aula.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_aluno aluno on aluno.id = freq.aluno_id
	   inner join academico_turmadisciplinaaluno tda on tda.turma_disciplina_id = td.id and tda.aluno_id = freq.aluno_id
	   inner join academico_disciplina disc on disc.id = td.disciplina_id
	   inner join academico_curso curso on curso.id = turma.curso_id
 where 1 = 1
   and tda.atributos is null
   and freq.atributos is null
   and td.atributos is null
   and turma.nome <> 'Apple Test'
   and aluno.nome not in (
'ANA CLARA BARROS PINHEIRO',
'ANA PAULA RIBEIRO REIS',
'ANDRÉ NASCIMENTO CAMPOS',
'ANDRESSA DE ALMEIDA FILARDI',
'CAMILA LANZA DE CASTRO',
'FERNANDA CRISTINA THEREZA DOS SANTOS',
'FLAMINIUS MENDES JÚNIOR',
'FLAMINIUS MENDES JÚNIOR',
'IAGO GAMA PIMENTA MURTA',
'IAGO GAMA PIMENTA MURTA',
'IAGO PEDRO DE MENÊZES VIEIRA',
'IZABELA CURY CARDOSO DE PADUA',
'IZABELA CURY CARDOSO DE PADUA',
'JULIA AGUIAR RATH',
'KARLENE KRISTINA DOS SANTOS',
'LAÍS SOUZA VILELA',
'LAURA DE PAULA MACHADO',
'MARIANA DE ALMEIDA CAMPOS',
'MARINA MARTINS MEIRELES',
'NAYANI ABRANTES BORGES',
'PEDRO ANDRADE SIQUEIRA',
'PEDRO HENRIQUE DE ALMEIDA NICESIO',
'PEDRO VIDIGAL REZENDE',
'WILLIAN SOARES NEVES'

)
GO
