/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_terceira_correcao_geral] as
select u.id as polo_id,
       u.descricao as polo_descricao,
       u.indice,
	   y.data,
	   y.id_hierarquia_usuario_pai,
	   y.id_tipo_hierarquia_usuario,
	   isnull(y.terceiras_corrigidas, 0) as terceiras_corrigidas,
	   isnull(y.terceiras_aproveitadas, 0) as terceiras_aproveitadas,
       isnull(y.foram_quarta, 0) as foram_quarta,
	   isnull(y.aproveitadas_quarta, 0) as aproveitadas_quarta,
	   isnull(y.nao_aproveitadas_quarta, 0) as nao_aproveitadas_quarta
  from usuarios_hierarquia u left outer join (
                                              select a.polo_id as hierarquia_id,
											         a.polo_descricao as descricao,
													 a.polo_indice as indice,
													 convert(date, data) as data,
													 a.id_hierarquia_usuario_pai,
													 a.id_tipo_hierarquia_usuario,
                                                     count(a.id_correcao) as terceiras_corrigidas,
													 sum(convert(int, a.aproveitamento)) as terceiras_aproveitadas,
                                                     sum(a.foi_para_quarta) as foram_quarta,
													 sum((case when isnull(c.discrepou, 1) = 1 then 0 else 1 end)) as aproveitadas_quarta,
                                                     sum((case when quarta_soma is null then 0 else isnull(convert(int, c.discrepou), 1) end)) as nao_aproveitadas_quarta
                                                from vw_relatorio_terceira_correcao_avaliador_AUX a
                                                     left outer join correcoes_analise b on a.id_correcao = b.id_correcao_A and b.id_tipo_correcao_B = 4
                                                     left outer join correcoes_conclusao_analise c on c.id = b.conclusao_analise
                                              group by a.polo_id, a.polo_descricao, a.polo_indice, convert(date, data), a.id_hierarquia_usuario_pai, a.id_tipo_hierarquia_usuario
                                              ) y on u.id = y.hierarquia_id where u.id_tipo_hierarquia_usuario = 3

GO
