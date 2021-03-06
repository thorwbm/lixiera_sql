USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_diferenca_turmadisciplinaaluno_X_frequenciadiaria]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************************************************************
*                                      VW_DIFERENCA_TURMADISCIPLINAALUNO_X_FREQUENCIADIARIA                                       *
*                                                                                                                                 *
*  VIEW QUE LISTA TODOS OS ALUNOS QUE ESTAO EM UMA TURMADISCIPLINA POREM NAO POSSUEM FREQUENCIA LANCADA EM UMA AULA E TODOS OS    *
* ALUNOS QUE POSSUEM UM LANCAMENTO DE FREQUENCIA PARA UMA AULA DE UMA TURMADISCIPLINA EM QUE ELE NAO ESTA RELACIONADO             *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/01/2020 *
**********************************************************************************************************************************/

CREATE    view [dbo].[vw_diferenca_turmadisciplinaaluno_X_frequenciadiaria] as 
with cte_diferencas as (
select * , 'turmaDisciplina' as tabela from (
		select distinct  aul.id as aula_id, tda.turma_disciplina_id as turmadisciplina_id, tda.aluno_id  
		  from academico_turmadisciplinaaluno tda join academico_aula aul on (tda.turma_disciplina_id = aul.turma_disciplina_id) 

		except

		select distinct  fre.aula_id, aul.turma_disciplina_id, fre.aluno_id from academico_frequenciadiaria fre join academico_aula aul on (aul.id = fre.aula_id)    
			 ) as tab_turma


		union


		select *, 'frequenciadiaria' from (
		select distinct  fre.aula_id, aul.turma_disciplina_id, fre.aluno_id from academico_frequenciadiaria fre join academico_aula aul on (aul.id = fre.aula_id)  

		except

		select distinct  aul.id as aula_id, tda.turma_disciplina_id as turmadisciplina_id, tda.aluno_id  
		  from academico_turmadisciplinaaluno tda join academico_aula aul on (tda.turma_disciplina_id = aul.turma_disciplina_id) 
  
) as tab_frequenciadiaria
)


select  cte.aula_id, cte.turmadisciplina_id, cte.aluno_id, cte.tabela, 
        alu.nome as aluno_nome, alu.ra as aluno_ra, 
		aul.data_inicio, aul.data_termino, aul.status_id, sta.nome as aula_status, 
		cur.id as curso_id, cur.nome as curso_nome, 
		tur.id as turma_id, tur.nome as turma_nome, 
		dis.id as disciplina_id, dis.nome as disciplina_nome
  from cte_diferencas cte join academico_aluno           alu on (alu.id = cte.aluno_id)
                          join academico_aula            aul on (aul.id = cte.aula_id)
						  join academico_statusaula      sta on (sta.id = aul.status_id)
						  join academico_turmadisciplina tds on (tds.id = cte.turmadisciplina_id)
						  join academico_turma           tur on (tur.id = tds.turma_id)
						  join academico_curso           cur on (cur.id = tur.curso_id)
						  join academico_disciplina      dis on (dis.id = tds.disciplina_id)
GO
