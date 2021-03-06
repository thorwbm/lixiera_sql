/****** Object:  View [dbo].[vw_relatorio_acompanhamento_quarta_correcao]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_relatorio_acompanhamento_quarta_correcao] as
select DISTINCT
       HIE.usuario_id,
       hie.nome,
    HIE.POLO_ID,
    HIE.indice,
    HIE.POLO_DESCRICAO,
    HIE.time_id,
    HIE.time_descricao,
       DIS_cota_1 = (SELECT CRTX.MAX_CORRECOES_DIA
                    FROM LOG_CORRECOES_CORRETOR CRTX
                   WHERE CRTX.ID = cor.id_corretor AND
                         history_date = (SELECT MAX(CRTXx.history_date) FROM LOG_CORRECOES_CORRETOR CRTXx join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
                                              WHERE CRTXx.ID = CRTX.ID AND
                                                    CAST(CRTXx.history_date AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[0].inicio') AND json_value(par.valor_padrao, '$.cotas[0].termino'))),
    COR_COTA_1 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[0].inicio') AND json_value(par.valor_padrao, '$.cotas[0].termino')),
     DIS_cota_2 = (SELECT CRTX.MAX_CORRECOES_DIA
                  FROM LOG_CORRECOES_CORRETOR CRTX
                 WHERE CRTX.ID = cor.id_corretor AND
                       CRTX.history_date = (SELECT MAX(CRTXx.history_date) FROM LOG_CORRECOES_CORRETOR CRTXx join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
                                            WHERE CRTXx.ID = CRTX.ID AND
                                                  CAST(CRTXx.history_date AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[1].inicio') AND json_value(par.valor_padrao, '$.cotas[1].termino'))),
    COR_COTA_2 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[1].inicio') AND json_value(par.valor_padrao, '$.cotas[1].termino')),
     DIS_cota_3 = (SELECT CRTX.MAX_CORRECOES_DIA
                  FROM LOG_CORRECOES_CORRETOR CRTX
                 WHERE CRTX.ID = cor.id_corretor AND
                       CRTX.history_date = (SELECT MAX(CRTXx.history_date) FROM LOG_CORRECOES_CORRETOR CRTXx join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
                                            WHERE CRTXx.ID = CRTX.ID AND
                                                  CAST(CRTXx.history_date AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[2].inicio') AND json_value(par.valor_padrao, '$.cotas[2].termino'))),
    COR_COTA_3 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) >= json_value(par.valor_padrao, '$.cotas[2].inicio'))
  from  vw_usuario_hierarquia hie  left join correcoes_correcao cor on (cor.id_corretor = hie.usuario_id and
                                                                        cor.id_tipo_correcao = 4 and
                                                                        cor.id_status = 3)
where HIE.PERFIL = 'SUPERVISOR'

GO
