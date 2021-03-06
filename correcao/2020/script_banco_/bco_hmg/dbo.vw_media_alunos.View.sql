USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_media_alunos]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_media_alunos] as 
(
select cu.nome curriculo, al.nome, al.ra, round(sum(dc.nota) / count(dc.nota), 1) media, dc.curriculo_aluno_id from curriculos_disciplinaconcluida dc
join curriculos_aluno ca on ca.id = dc.curriculo_aluno_id
join curriculos_statusdisciplina sd on sd.id = dc.status_id
join academico_aluno al on al.id = ca.aluno_id
join curriculos_curriculo cu on cu.id = ca.curriculo_id
join curriculos_statusaluno sa on sa.id = ca.status_id
where
sd.media_geral_aluno = 1
and sa.curso_atual = 1
group by cu.nome, dc.curriculo_aluno_id, al.nome, al.ra
)

GO
