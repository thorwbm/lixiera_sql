/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_relatorio_aproveitamento_notas_geral] as
select 1 as id, hierarquia_id, descricao, indice, data,
       sum(redacoes_corrigidas) as redacoes_corrigidas, sum(notas_aproveitadas) as notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou
  from (
select polo_id as hierarquia_id, polo_descricao as descricao, indice, data, sum(redacoes_corrigidas) as redacoes_corrigidas, notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou from (
  select e.polo_id, e.polo_descricao, e.polo_indice as indice, convert(date, d.data_termino) as data, count(*) as redacoes_corrigidas,
        sum(convert(int, isnull(a.aproveitamento, 1))) as notas_aproveitadas, sum((case when a.conclusao_analise in (0,1,2) then 1 else 0 end)) as nao_discrepou, sum((case when a.conclusao_analise in (3,4,5) then 1 else 0 end)) as discrepou
    from correcoes_analise a, usuarios_hierarquia_usuarios b, usuarios_hierarquia c, correcoes_correcao d, vw_usuario_hierarquia_completa e
  where a.id_corretor_A = b.user_id
    and b.hierarquia_id = c.id
    and a.id_tipo_correcao_B = 3
    and d.id = a.id_correcao_A
	and e.usuario_id = b.user_id
  group by e.polo_id, e.polo_descricao, e.polo_indice, convert(date, d.data_termino)
) z
group by polo_id, polo_descricao, indice, data, notas_aproveitadas
union all
select polo_id as hierarquia_id, polo_descricao as descricao, indice, data, sum(redacoes_corrigidas) as redacoes_corrigidas, notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou from (
  select e.polo_id, e.polo_descricao, e.polo_indice as indice, convert(date, d.data_termino) as data, count(*) as redacoes_corrigidas,
        sum(convert(int, isnull(a.aproveitamento, 1))) as notas_aproveitadas, sum((case when a.conclusao_analise in (0,1,2) then 1 else 0 end)) as nao_discrepou, sum((case when a.conclusao_analise in (3,4,5) then 1 else 0 end)) as discrepou
    from correcoes_analise a, usuarios_hierarquia_usuarios b, usuarios_hierarquia c, correcoes_correcao d, vw_usuario_hierarquia_completa e
  where a.id_corretor_B = b.user_id
    and b.hierarquia_id = c.id
    and a.id_tipo_correcao_B = 3
    and d.id = a.id_correcao_B
	and e.usuario_id = b.user_id
  group by e.polo_id, e.polo_descricao, e.polo_indice, convert(date, d.data_termino)
) z
group by polo_id, polo_descricao, indice, data, notas_aproveitadas
) w
group by hierarquia_id, descricao, indice, data

GO
