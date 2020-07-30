exec sp_MSforeachtable @command1="DISABLE TRIGGER ALL On ?"
update projeto_projeto set codigo = '1810401'
go 

create or ALTER VIEW [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES] AS 
select  
   codigo_projeto  = PRO.codigo,
   origem          = 'F',
   CPF             = pes.cpf,
   DATA_AVALIACAO  = IND.DATA_CALCULO,
   DSP             = IND.DSP,
   LOTE            = NULL
from correcoes_corretor_indicadores ind with (nolock) JOIN projeto_projeto    PRO WITH (NOLOCK) ON (PRO.ID = IND.projeto_id) 
                                                      join usuarios_pessoa    pes with (nolock) on (ind.usuario_id = pes.usuario_id)
where data_calculo > '2018-12-20'
GO
-------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO
-------------------------------------------------------------------------------------------------------------------------
/* VALIDACAO NOTAS E COMPETENCIAS */




-------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-------------------------------------------------------------------------------------------------------------------------
/* ONDE DSP DIFERENTE DE NULO E DIFERENTE DE ZERO */
SELECT * 
 -- INTO entregas_regular.DBO.N69_29122018_001
 FROM VW_N69_DESEMPENHO_DIARIO_AVALIADORES vw
WHERE DSP IS NOT NULL  and 
      not exists (select top 1 1 from entregas_regular.DBO.N69_19122018_001 tmp
	               where tmp.cpf            = vw.cpf and 
				         tmp.DATA_AVALIACAO = vw.DATA_AVALIACAO and 
						 tmp.dsp            = vw.dsp)
						 and 
      not exists (select top 1 1 from entregas_regular.DBO.N69_20122018_001 tmp
	               where tmp.cpf            = vw.cpf and 
				         tmp.DATA_AVALIACAO = vw.DATA_AVALIACAO and 
						 tmp.dsp            = vw.dsp)
						 and 
      not exists (select top 1 1 from entregas_regular.DBO.N69_21122018_001 tmp
	               where tmp.cpf            = vw.cpf and 
				         tmp.DATA_AVALIACAO = vw.DATA_AVALIACAO and 
						 tmp.dsp            = vw.dsp)




select * from correcoes_corretor_indicadores where data calculo = 20