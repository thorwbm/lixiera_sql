/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_time]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_padrao_ouro_time] as
SELECT d.polo_id, d.polo_descricao, d.time_id, d.time_descricao, b.user_id as usuario_id, b.hierarquia_id, c.id_usuario_responsavel, c.indice, c.id_tipo_hierarquia_usuario, d.nome as avaliador,
        convert(date, a.data) as data, count(a.id) as nr_padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as nr_discrepancia_padrao_ouro
    from usuarios_hierarquia c
        inner join usuarios_hierarquia_usuarios b on c.id = b.hierarquia_id
        inner join vw_usuario_hierarquia_completa d on d.usuario_id = b.user_id
        left outer join vw_relatorio_padrao_ouro_avaliador a on a.id_corretor = b.user_id
   where c.id_tipo_hierarquia_usuario = 4
  group by d.polo_id, d.polo_descricao, d.time_id, d.time_descricao, b.user_id, b.hierarquia_id, c.id_usuario_responsavel, c.indice,
           c.id_tipo_hierarquia_usuario, d.nome, convert(date, a.data)

GO
