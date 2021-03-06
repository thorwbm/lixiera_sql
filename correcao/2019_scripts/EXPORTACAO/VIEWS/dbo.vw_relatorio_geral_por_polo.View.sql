/****** Object:  View [dbo].[vw_relatorio_geral_por_polo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_geral_por_polo] AS
SELECT  ROW_NUMBER() over (order by TIME_id) as id,
        POLO_ID,
        POLO_DESCRICAO,
        HIERARQUIA,
        TIME_ID,
        indice,
        DSP = AVG(MEDIA_DSP) ,
        TIME_DESCRICAO,
        TOTAL_CORRIGIDAS,
        TOTAL_CORRIGIDAS_POR_DIA = CAST(ROUND(TOTAL_CORRIGIDAS / (SELECT (CASE WHEN dbo.getlocaldate() <= DATA_TERMINO THEN DATEDIFF(DAY,DATEADD(DAY,-1,DATA_INICIO), dbo.getlocaldate())
                                                                                                             ELSE DATEDIFF(DAY,DATEADD(DAY,-1,DATA_INICIO), DATA_TERMINO) END) * 1.0
                                                                  FROM PROJETO_PROJETO with (nolock) WHERE ID = 4), 2) AS NUMERIC(10,2)),
        TOTAL_CORRETORES,
        TEMPO_MEDIO = CAST(ROUND(CASE WHEN TOTAL_CORRIGIDAS = 0 THEN 0 ELSE  SOMA_TEMPO / (TOTAL_CORRIGIDAS * 1.0) END , 2) AS NUMERIC(10,2)),
        APROVEITAMENTO_NOTA = ISNULL( CAST(ROUND((case when TOTAL_CORRIGIDAS = 0 then 0.00 else aproveitamento_nota / (total_corrigidas * 1.0) end) * 100, 2) AS NUMERIC(10,2)),0)
  FROM (
SELECT DISTINCT
       POLO_ID = HIE2.POLO_ID ,
       POLO_DESCRICAO =  HIE2.POLO_DESCRICAO,
       HIE.indice,
       HIERARQUIA =  HIE2.HIERARQUIA,
       HIE.TIME_ID,
       HIE.TIME_DESCRICAO,
       TOTAL_CORRIGIDAS = ISNULL(COR.QTD,0),
       SOMA_TEMPO = ISNULL(TEMPO,0),
       MEDIA_DSP  = CCI.MEDIA_DSP,
       APROVEITAMENTO_NOTA = QTD_APROVEITAMENTO,
       TOTAL_CORRETORES = ISNULL(CORRETOR.QTD,0)


  FROM (SELECT DISTINCT TIME_ID, TIME_DESCRICAO , INDICE
          FROM VW_USUARIO_HIERARQUIA
          WHERE id_tipo_hierarquia_usuario = 4) AS  HIE   left join (select HIEX.TIME_id, QTD = ISNULL(count(CORX.ID),0), TEMPO = SUM(ISNULL(CORX.TEMPO_EM_CORRECAO,0))
                                                             from correcoes_correcao corX join vw_usuario_hierarquia hieX on (corX.id_corretor = hieX.usuario_id)
                                                            where id_status = 3 GROUP BY HIEX.TIME_id ) AS COR ON (HIE.TIME_id = COR.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, MEDIA_DSP = AVG(ISNULL(CCIX.DSP,0))
                                                             FROM correcoes_corretor_indicadores CCIX join vw_usuario_hierarquia hieX on (CCIX.USUARIO_ID = hieX.usuario_id)
                                                            GROUP BY HIEX.TIME_id) AS CCI ON (HIE.TIME_id = CCI.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, QTD = ISNULL(count(CORR.ID),0)
                                                             FROM correcoes_corretor CORR join vw_usuario_hierarquia hieX on (CORR.id = hieX.usuario_id)
                                                            GROUP BY HIEX.TIME_id) AS CORRETOR ON (HIE.TIME_id = CORRETOR.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, QTD_APROVEITAMENTO = ISNULL(COUNT(ANAX.ID),0)
                                                             FROM correcoes_analise ANAX JOIN VW_USUARIO_HIERARQUIA HIEX ON (ANAX.id_correTOR_A = HIEX.USUARIO_ID AND
                                                                                                                             ANAX.ID_TIPO_CORRECAO_B = 3          AND
                                                                                                                             ANAX.aproveitamento = 1)
                                                            GROUP BY HIEX.TIME_id) AS ANA ON (ANA.TIME_id = HIE.TIME_id)
                                               LEFT JOIN (SELECT DISTINCT HIEX.TIME_ID, POLO_ID, POLO_DESCRICAO, HIERARQUIA
                                                            FROM VW_USUARIO_HIERARQUIA HIEX) AS HIE2 ON (HIE2.TIME_ID = HIE.TIME_ID)) AS TAB
GROUP BY POLO_ID,
      POLO_DESCRICAO,
      HIERARQUIA,
      TIME_ID,
      indice,
      TIME_DESCRICAO,
      TOTAL_CORRIGIDAS,
      SOMA_TEMPO,
      APROVEITAMENTO_NOTA,
      TOTAL_CORRETORES

GO
