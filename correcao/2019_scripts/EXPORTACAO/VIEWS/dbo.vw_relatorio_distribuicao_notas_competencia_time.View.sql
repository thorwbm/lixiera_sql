/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_competencia_time]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    view [dbo].[vw_relatorio_distribuicao_notas_competencia_time] as
select polo.id as polo_id, polo.descricao as polo_descricao, polo.indice as polo_indice, time.id as time_id, time.descricao as time_descricao, time.indice as indice, p.usuario_id, p.nome,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
	   sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
	   sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
	   sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
	   sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
	   sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
	   sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
	   sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
	   sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
	   sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
	   sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
	   sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
	   sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
	   sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
	   sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
	   sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
	   sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
	   sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
	   sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
	   sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
	   sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data,
	   count_big(a.id) as nr_corrigidas,
	   count_big(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from dbo.correcoes_correcao2019 a
       right join dbo.usuarios_pessoa p on p.usuario_id = a.id_corretor and a.id_status = 3
       inner join dbo.usuarios_hierarquia_usuarios b on b.user_id = p.usuario_id
       inner join dbo.usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join dbo.usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join dbo.usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join dbo.usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
group by polo.id, polo.descricao, polo.indice, time.id, time.descricao, time.indice, p.usuario_id, p.nome, convert(date, a.data_termino)

GO
