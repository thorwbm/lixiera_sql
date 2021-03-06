USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aluno_aula_faltante]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_aluno_aula_faltante] as 
with cte_aulas as (
select alu.nome as Aluno, alu.ra, tur.nome as Turma, dis.nome as Disciplina, tda.criado_em, aul.data_inicio, aul.data_termino, 
                  aul.id as aula_id, tda.aluno_id, tds.id as turmaDisciplina_id ,dis.id as disciplina_id
  from academico_aula aul join academico_turmadisciplina      tds on (tds.id = aul.turma_disciplina_id)
                          join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id)
						  join academico_turma                tur on (tur.id = tds.turma_id)
						  join academico_disciplina           dis on (dis.id = tds.disciplina_id)
						  join academico_aluno                alu on (alu.id = tda.aluno_id)
 where aul.status_id = 3
   and cast(tur.termino_vigencia as date) >= '2019-12-01'
   and dis.nome not like '%estagio%'
)

select aul.* from cte_aulas aul left join academico_frequenciadiaria fre on (aul.aula_id = fre.aula_id and 
                                                                         aul.aluno_id = fre.aluno_id)

where fre.id is null

GO
