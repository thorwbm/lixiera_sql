declare @data date = dateadd(day,-1,cast('2019-12-10 10:32:00' as date));

select * , data_carga = dbo.getlocaldate()
into bkp_correcoes_redacao
from EXT_CORRECOES_REDACAO 
where data_termino = @data



select * from inep_loteinterface


DECLARE @ARQUIVO_N VARCHAR(3) = 'N59'
DECLARE @CONTADOR INT = 0
DECLARE @INTERFACE_ID INT 
DECLARE @DATANOME VARCHAR (8) 

--SELECT @INTERFACE_ID = ID, @DATANOME = FORMAT(DBO.getlocaldate(),'yyyyMMdd') FROM INEP_LOTEINTERFACE  ITF WHERE ITF.nome = @ARQUIVO_N

SELECT @INTERFACE_ID = ITF.ID, @DATANOME = FORMAT(DBO.getlocaldate(),'yyyyMMdd'),  REVERSE(LOT.NOME)
  FROM inep_loteinterface ITF LEFT JOIN INEP_LOTE LOT ON (ITF.ID = LOT.interface_id AND 
                                                          CAST(LOT.criado_em AS DATE) = CAST(DBO.getlocaldate() AS DATE))
WHERE ITF.NOME = @ARQUIVO_N 

PRINT @INTERFACE_ID
PRINT @DATANOME



SELECT REVERSE(NOME) FROM INEP_LOTE

select nome = 'LOTE_' + @ARQUIVO_N + '_' + @DATANOME + '_' 