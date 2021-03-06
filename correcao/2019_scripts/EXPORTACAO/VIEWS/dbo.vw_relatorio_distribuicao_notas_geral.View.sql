/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_relatorio_distribuicao_notas_geral] as
select ROW_NUMBER() over (order by hierarquia_id) as id, hierarquia_id, descricao, indice, data, nr_total_avaliadores, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
	   (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
	   (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
	   (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
	   (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
	   (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
	   (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
	   (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
	   (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
	   (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
	   (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
	   (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
	   (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
	   (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
	   (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
	   (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
	   (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
	   (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
	   (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
	   (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
	   (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
	   (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id as hierarquia_id, c.polo_descricao as descricao, c.polo_indice as indice,
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
       convert(date, a.data_termino) as data, count(distinct a.id_corretor) as nr_total_avaliadores, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
	   inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, convert(date, a.data_termino)
) z

GO
