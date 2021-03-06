/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_padrao_ouro_geral] as
select 1 as id, * from (
  SELECT c.id as hierarquia_id, c.descricao, c.indice,
        convert(date, a.data) as data, count(a.id) as padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as discrepancia_padrao_ouro
    from usuarios_hierarquia c 
        left outer join vw_relatorio_padrao_ouro_avaliador a on c.id = a.polo_id
   where c.id_tipo_hierarquia_usuario = 3
  group by c.id, c.descricao, c.indice, convert(date, a.data)
) z
GO
