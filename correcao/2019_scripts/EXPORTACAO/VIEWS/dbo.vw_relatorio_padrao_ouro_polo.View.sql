/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_polo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_padrao_ouro_polo] as
select 1 as id, b.id as polo_id, b.descricao as polo_descricao, c.id as hierarquia_id, c.descricao, c.indice,
        convert(date, a.data) as data, count(a.id) as padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as discrepancia_padrao_ouro
    from usuarios_hierarquia c
         inner join usuarios_hierarquia b on b.id = c.id_hierarquia_usuario_pai
         left outer join vw_relatorio_padrao_ouro_avaliador a on c.id = a.time_id
   where c.id_tipo_hierarquia_usuario = 4
  group by b.id, b.descricao, c.id, c.descricao, c.indice, convert(date, a.data)
GO
