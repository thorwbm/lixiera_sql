/****** Object:  View [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES]
GO
/****** Object:  View [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create    VIEW [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES] AS 
SELECT 
   LOTE_ID = 0, 
   PROJETO_ID = PRO.ID, 
   CRIADO_EM  = DBO.GETLOCALDATE(), 
   CORRECAO_ID           = COR.ID,
   REDACAO_ID            = RED.ID,
   CORRETOR_ID           = COR.id_corretor,
   CO_PROJETO            = PRO.CODIGO,
   TP_ORIGEM             = 'F',
   CO_PROVA_OURO         = ROU.id,
   NU_CPF                = pes.cpf,
   TP_REFERENCIA         = rou.id_redacaotipo,
   DT_INICIO             = COR.data_inicio,
   DT_FIM                = COR.data_termino,
   CO_SITUACAO_REDACAO   = COR.id_correcao_situacao,
   NU_NOTA_REDACAO       = COR.nota_final,
   NU_NOTA_COMP1_REDACAO = COR.nota_competencia1,
   NU_NOTA_COMP2_REDACAO = COR.nota_competencia2,
   NU_NOTA_COMP3_REDACAO = COR.nota_competencia3,
   NU_NOTA_COMP4_REDACAO = COR.nota_competencia4,
   NU_NOTA_COMP5_REDACAO = COR.nota_competencia5,
   CO_JUSTIFICATIVA      = NULL
                  
  FROM CORRECOES_REDACAO RED join correcoes_redacaoouro rou on (rou.id = red.id_redacaoouro)
                             JOIN projeto_projeto       PRO ON (PRO.ID = RED.id_projeto)
                             JOIN CORRECOES_CORRECAO    COR ON (RED.ID = COR.REDACAO_ID)
                             JOIN usuarios_pessoa       pes ON (COR.id_corretor = pes.usuario_id)
WHERE  
      cor.id_status = 3
GO
