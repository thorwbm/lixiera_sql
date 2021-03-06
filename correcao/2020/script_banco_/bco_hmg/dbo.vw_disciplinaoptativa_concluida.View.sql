USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_disciplinaoptativa_concluida]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_disciplinaoptativa_concluida] as 
select crd.id as disciplinaconcluida_id, cra.id as curriculoaluno_id,
       cra.aluno_id, alu.nome as aluno_nome, alu.ra,
	   cuc.id as curriculo_id, cuc.nome as curriculo_nome, 
	   dis.id as disciplina_id, dis.nome as disciplina_nome, crd.carga_horaria as cargahoraria_concluida
  from curriculos_disciplinaconcluida crd join curriculos_aluno     cra on (cra.id = crd.curriculo_aluno_id)
                                          join academico_aluno      alu on (alu.id = cra.aluno_id)
										  join curriculos_curriculo cuc on (cuc.id = cra.curriculo_id)
										  join academico_disciplina dis on (dis.id = crd.disciplina_id)
  where crd.exigencia_id = 1 and   -- optativa
        crd.status_id in (2,6) and -- situacao aprovado e dispensado
		cra.status_id = 13         -- status curricular em curso.



GO
