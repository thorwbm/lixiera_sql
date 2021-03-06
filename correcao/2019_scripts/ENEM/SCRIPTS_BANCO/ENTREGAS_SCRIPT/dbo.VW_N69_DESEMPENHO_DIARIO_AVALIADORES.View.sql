/****** Object:  View [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES]
GO
/****** Object:  View [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   VIEW [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES] AS 
select  
   ID                   = 0,
   LOTE_ID              = 0,
   PROJETO_ID           = PRO.ID, 
   USUARIO_ID           = PES.USUARIO_ID, 
   CRIADO_EM            = DBO.GETLOCALDATE(),
   CO_PROJETO           = PRO.codigo,
   TP_ORIGEM            = 'F',
   NU_CPF               = pes.cpf,
   DT_AVALIACAO         = IND.DATA_CALCULO,
   NU_INDICE_DESEMPENHO = IND.DSP,
   LOTE                 = NULL
from correcoes_corretor_indicadores ind JOIN projeto_projeto    PRO ON (PRO.ID = IND.projeto_id) 
                                        JOIN usuarios_pessoa    pes on (ind.usuario_id = pes.usuario_id)
GO
