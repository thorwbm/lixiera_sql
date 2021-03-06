/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_por_polo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_relatorio_aproveitamento_notas_por_polo] as
select polo_id, polo_descricao, hierarquia_id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, indice, data,
       sum(redacoes_corrigidas) as redacoes_corrigidas,
	   sum(notas_aproveitadas) as notas_aproveitadas,
	   sum(notas_nao_aproveitadas) as notas_nao_aproveitadas,
	   sum(nao_discrepou) as nao_discrepou,
	   sum(discrepou) as discrepou
 from (

select a.polo_id, a.polo_descricao, time_id as hierarquia_id, time_descricao as descricao, time_indice as indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino) as data,
       count(*) as redacoes_corrigidas,
	   sum(case when isnull(d.aproveitamento, 0) = 1 then 1 else 0 end) as notas_aproveitadas,
	   sum(case when d.aproveitamento = 0 and d.aproveitamento is not null then 1 else 0 end) as notas_nao_aproveitadas,
	   sum(convert(int, isnull(e.discrepou, 0))) as discrepou,
	   count(*) - sum(convert(int, isnull(e.discrepou, 0))) as nao_discrepou
  from vw_usuario_hierarquia_completa a
       inner join correcoes_correcao b on a.usuario_id = b.id_corretor and b.id_tipo_correcao = 1
	   inner join correcoes_analise c on c.id_correcao_a = b.id
	   inner join usuarios_hierarquia f on f.id = a.time_id
	   left outer join correcoes_analise d on d.id_correcao_a = b.id and d.id_tipo_correcao_b = 3   /*verificar aproveitamento e discrepância de comparação com terceiras*/
	   left outer join correcoes_conclusao_analise e on e.id = c.conclusao_analise
 where b.data_termino is not null
group by a.polo_id, a.polo_descricao, a.polo_indice, time_id, time_descricao, time_indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino)
union
select a.polo_id, a.polo_descricao, time_id as hierarquia_id, time_descricao as descricao, time_indice as indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino) as data,
       count(*) as redacoes_corrigidas,
	   sum(case when isnull(d.aproveitamento, 0) = 1 then 1 else 0 end) as notas_aproveitadas,
	   sum(case when d.aproveitamento = 0 and d.aproveitamento is not null then 1 else 0 end) as notas_nao_aproveitadas,
	   sum(convert(int, isnull(e.discrepou, 0))) as discrepou,
	   count(*) - sum(convert(int, isnull(e.discrepou, 0))) as nao_discrepou
  from vw_usuario_hierarquia_completa a
       inner join correcoes_correcao b on a.usuario_id = b.id_corretor and b.id_tipo_correcao = 2
	   inner join correcoes_analise c on c.id_correcao_b = b.id
	   inner join usuarios_hierarquia f on f.id = a.time_id
	   left outer join correcoes_analise d on d.id_correcao_a = b.id and d.id_tipo_correcao_b = 3   /*verificar aproveitamento e discrepância de comparação com terceiras*/
	   left outer join correcoes_conclusao_analise e on e.id = c.conclusao_analise
 where b.data_termino is not null
group by a.polo_id, a.polo_descricao, a.polo_indice, time_id, time_descricao, time_indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino)
) z
group by polo_id, polo_descricao, hierarquia_id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, indice, data

GO
