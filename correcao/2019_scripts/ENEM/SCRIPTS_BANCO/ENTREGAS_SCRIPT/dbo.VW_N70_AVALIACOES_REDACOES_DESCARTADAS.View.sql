/****** Object:  View [dbo].[VW_N70_AVALIACOES_REDACOES_DESCARTADAS]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[VW_N70_AVALIACOES_REDACOES_DESCARTADAS]
GO
/****** Object:  View [dbo].[VW_N70_AVALIACOES_REDACOES_DESCARTADAS]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   view [dbo].[VW_N70_AVALIACOES_REDACOES_DESCARTADAS] as 
select
ID                    = 0, 
LOTE_ID               = 0, 
CRIADO_EM             = DBO.GETLOCALDATE(),
REDACAO_ID            = cor.redacao_id, 
CORRECAO_ID           = cor.id,
CO_PROJETO            = N02.CO_PROJETO,
CO_INSCRICAO          = RED.co_inscricao,
SIGLA_UF              = N02.SG_UF_PROVA,
NU_CPF                = PES.cpf, 
TP_TIPO_CORRECAO      = tpa.co_tipo_auditoria_n70,
IN_DESCARTADA         = vw.descartada,
NU_CORRECAO           = CASE WHEN cor.id_tipo_correcao IN (1,2) THEN 1 
                          WHEN cor.id_tipo_correcao = 3      THEN 3 
                          WHEN cor.id_tipo_correcao = 4      THEN 4 
                          WHEN cor.id_tipo_correcao = 7      THEN 5 ELSE 1000 END ,
CO_SITUACAO_REDACAO   = cor.id_correcao_situacao,
NU_NOTA_REDACAO	      = cor.nota_final,
NU_NOTA_COMP1_REDACAO = cor.NOTA_COMPETENCIA1,
NU_NOTA_COMP2_REDACAO = cor.NOTA_COMPETENCIA2,
NU_NOTA_COMP3_REDACAO = cor.NOTA_COMPETENCIA3,
NU_NOTA_COMP4_REDACAO = cor.NOTA_COMPETENCIA4,
NU_NOTA_COMP5_REDACAO = cor.NOTA_COMPETENCIA5

  from correcoes_correcao cor join correcoes_correcao      aud on (cor.redacao_id = aud.redacao_id and 
                                                                           aud.id_tipo_correcao = 7)
							  JOIN CORRECOES_REDACAO       RED  ON (RED.ID = AUD.redacao_id and 
							                                      RED.cancelado = 0)
							  JOIN inep_N02                N02  ON (N02.CO_INSCRICAO     = RED.co_inscricao)
							  JOIN usuarios_pessoa         PES  ON (PES.usuario_id       = AUD.id_corretor)
							  join correcoes_tipoauditoria tpa  on (tpa.id               = aud.tipo_auditoria_id)
							  join vw_descartada_n70       vw   on (vw.redacao_id  = cor.redacao_id and 
							                                                   vw.id_tipo_correcao  = cor.id_tipo_correcao)



GO
