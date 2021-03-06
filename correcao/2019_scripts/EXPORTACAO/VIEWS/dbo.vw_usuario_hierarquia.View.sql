/****** Object:  View [dbo].[vw_usuario_hierarquia]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_usuario_hierarquia]
AS
    SELECT pes.usuario_id,
            pes.nome,
            hie.id,
            hierarquia = hie.descricao,
            hie.id_usuario_responsavel,
            RESPONSAVEL = RES.nome,
            ID_HIERARQUIA = HIE.id,
            COR.MAX_CORRECOES_DIA,
            COR.ID_GRUPO,
            COR.PODE_CORRIGIR_1,
            COR.PODE_CORRIGIR_2,
            COR.PODE_CORRIGIR_3,
            COR.STATUS_Id,
            hie.indice,
            ppu.projeto_id,
            hie.id_tipo_hierarquia_usuario,
            hie.id_hierarquia_usuario_pai,
            [time].id AS time_id,
            polo.id AS polo_id,
            fgv.id AS fgv_id,
            geral.id AS geral_id,
            [time].descricao AS time_descricao,
            polo.descricao AS polo_descricao,
            fgv.descricao AS fgv_descricao,
            geral.descricao AS geral_descricao,
            [time].indice AS time_indice,
            polo.indice AS polo_indice,
            fgv.indice AS fgv_indice,
            geral.indice AS geral_indice,
            perfil = grp.name
     FROM usuarios_pessoa pes
         INNER JOIN usuarios_hierarquia_usuarios hieUsu WITH(NOLOCK)
                   ON(pes.usuario_id = hieUsu.user_id)
         INNER JOIN usuarios_hierarquia hie WITH(NOLOCK)
                   ON(hie.id = hieUsu.hierarquia_id)
         INNER JOIN usuarios_pessoa RES WITH(NOLOCK)
                   ON(RES.USUARIO_ID = HIE.id_usuario_responsavel)
         INNER JOIN projeto_projeto_usuarios ppu WITH(NOLOCK)
                   ON(res.usuario_id = ppu.user_id)
         INNER JOIN usuarios_hierarquia [time] WITH(NOLOCK)
                   ON [time].id = hieUsu.hierarquia_id
          LEFT JOIN CORRECOES_CORRETOR COR WITH(NOLOCK)
                   ON(COR.ID = PES.USUARIO_ID)
          LEFT JOIN usuarios_hierarquia polo WITH(NOLOCK)
                   ON polo.id = [time].id_hierarquia_usuario_pai
          LEFT JOIN usuarios_hierarquia fgv WITH(NOLOCK)
                   ON fgv.id = polo.id_hierarquia_usuario_pai
          LEFT JOIN usuarios_hierarquia geral WITH(NOLOCK)
                   ON geral.id = fgv.id_hierarquia_usuario_pai
          LEFT JOIN auth_user_groups gup WITH(NOLOCK)
                   ON(gup.user_id = pes.usuario_id)
          LEFT JOIN auth_group grp WITH(NOLOCK)
                   ON(grp.id = gup.group_id);

GO
