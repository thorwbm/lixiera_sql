
-- create or ALTER VIEW [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES] AS 
select  
   CO_PROJETO           = PRO.codigo,
   TP_ORIGEM            = 'F',
   NU_CPF               = pes.cpf,
   DT_AVALIACAO         = IND.DATA_CALCULO,
   NU_INDICE_DESEMPENHO = IND.DSP,
   NU_LOTE              = NULL
from correcoes_corretor_indicadores ind JOIN projeto_projeto    PRO ON (PRO.ID = IND.projeto_id) 
                                        join usuarios_pessoa    pes on (ind.usuario_id = pes.usuario_id)

-------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO
-------------------------------------------------------------------------------------------------------------------------
/* VALIDACAO NOTAS E COMPETENCIAS */




-------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-------------------------------------------------------------------------------------------------------------------------
/* ONDE DSP DIFERENTE DE NULO E DIFERENTE DE ZERO */
