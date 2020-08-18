/****************************************************************

CREATE TABLE [dbo].[BANCO_PALAVRA](
	[PALAVRA_ORIGINAL] [varchar](50) NULL,
	[PALAVRA_CORRECAO] [varchar](50) NULL,
	[FLAG_aplicar] [bit] NOT NULL
) ON [PRIMARY]
GO
CREATE INDEX IX_BANCO_PALAVRA__PALAVRA_ORIGINAL ON BANCO_PALAVRA (PALAVRA_ORIGINAL);
*****************************************************************/

-- '%[^A-z0-9 ]%'
-- '%cao%'

--declare @tabela table (palavra varchar(100))
declare @busca varchar(100)
declare @string varchar(max)
declare @CORRECAO VARCHAR(100)
DECLARE @TEXTO VARCHAR(100)

SET @TEXTO    ='COLEGIO'  -- PARTE A SER PORCURADA 
SET @CORRECAO ='COLÉGIO'  -- PARTE A SUBSTITUIR -- MAS SE NAO SOUBER PODE PASSAR NULO
set @busca = '%' + @TEXTO + '%'

declare CUR_ cursor for 
-----------------------------------------------------------
        select distinct nome 
        from bkp_avaliacao_conquista 
        where nome like @busca
-----------------------------------------------------------
	open CUR_ 
		fetch next from CUR_ into @string
		while @@FETCH_STATUS = 0
			BEGIN

                INSERT INTO BANCO_PALAVRA (PALAVRA_ORIGINAL, PALAVRA_CORRECAO, FLAG_APLICAR)
				select distinct 
                       value AS PALAVRA_ORIGINAL, 
                       REPLACE(VALUE, @TEXTO, @CORRECAO), FLG_APLICAR = CASE WHEN @CORRECAO IS NULL THEN 0 ELSE 1 END
                  from string_split(@string, ' ') AS SPLT
                 where value like @busca AND 
                       NOT EXISTS (SELECT TOP 1 1 FROM BANCO_PALAVRA BCP  WHERE BCP.PALAVRA_ORIGINAL = SPLT.VALUE)

			fetch next from CUR_ into @string
			END
	close CUR_ 
deallocate CUR_ 


SELECT * FROM BANCO_PALAVRA

SELECT * FROM BKP_ESCOLAS