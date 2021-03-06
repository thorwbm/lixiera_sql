/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_relatorio_distribuicao_notas_situacao_geral] as
select  ROW_NUMBER() over (order by hierarquia_id) as id, *,
       (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) as nr_corrigidas,
       (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) as nr_situacoes from (
select polo_id as hierarquia_id, polo_descricao as descricao, polo_indice as indice, data,
       isnull([1], 0) as nr_nm, isnull([2], 0) as nr_fea, isnull([3], 0) as nr_copia, isnull([6], 0) as nr_ft, isnull([7], 0) as nr_natt, isnull([9], 0) as nr_pd from (
select c.polo_id, c.polo_descricao, c.polo_indice, a.id_correcao_situacao, convert(date, a.data_termino) as data,
       count(*) as nr_corrigidas
  from correcoes_correcao a
       left outer join correcoes_situacao b on a.id_correcao_situacao = b.id
	   inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, a.id_correcao_situacao, convert(date, a.data_termino)
) z pivot (sum(nr_corrigidas) for id_correcao_situacao in ([1], [2], [3], [6], [7], [9])) z
) y

GO
