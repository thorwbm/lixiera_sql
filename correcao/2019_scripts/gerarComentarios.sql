/*****************************************************************************************************************
*                                               CRIAR COMENTARIOS                                                *
*                                                                                                                *
* SELECT QUE GERA UM CABEÇALHO DE COMENTARIO MONTADO APARTIR DOS PARAMETROS PASSADOS.                            *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA: GENERICO                                                                                        *
* AUTOR: WEMERSON BITTORI MADURO                                                                 DATA:09/11/2015 *
******************************************************************************************************************/

DECLARE @TEXTO varchar(8000), @largura int, @titulo varchar(500),  @AUTOR VARCHAR(100),@AUX varchar(8000),@AUX1 varchar(8000),@FIM INT,
        @bancoSistema varchar(800)

set @titulo  = 'SP_PRO_INSERT_INTEGRACAO_CURRICULAR'
SET @TEXTO   = ' PROCEDURE QUE FAZ A INSERCAO DO UMA DISCIPLINA DO TIPO INTEGRACAO CURRICULAR PARA UM ALUNO COM BASE NA SUA TURMA PAI '
SET @TEXTO   = @TEXTO + '' 
SET @TEXTO   = @TEXTO + '' 
SET @TEXTO   = @TEXTO + '' 
SET @TEXTO   = @TEXTO + '' 
SET @TEXTO   = @TEXTO + '' 

set @largura = 113
SET @bancoSistema = 'GENERICO'
SET @AUTOR   = 'WEMERSON BITTORI MADURO'


SET @FIM     = 0
SET @TEXTO   = REPLACE(@TEXTO,CHAR(13) + Char(10) ,' ')
SET @TEXTO   = REPLACE(@TEXTO,REPLICATE(' ',10) ,' ')
SET @TEXTO   = REPLACE(@TEXTO,REPLICATE(' ',8),' ')
SET @TEXTO   = REPLACE(@TEXTO,REPLICATE(' ',6) ,' ')
SET @TEXTO   = REPLACE(@TEXTO,REPLICATE(' ',4) ,' ')
SET @TEXTO   = REPLACE(@TEXTO,REPLICATE(' ',2) ,' ')
SET @TEXTO   = REPLACE(@TEXTO,REPLICATE(' ',3) ,' ')
SET @AUX     = LEFT (@TEXTO,@LARGURA - 3)
IF (LEN(@TEXTO) > @LARGURA)
	BEGIN
		SET @AUX1    = RIGHT(@TEXTO,LEN(@TEXTO)-(@LARGURA - 3))
	END 
ELSE
	BEGIN
		SET @AUX1 =''
	END

print'/'+replicate('*',@largura)
print '* ' + replicate(' ',(@largura - len(@titulo))/2 - 2) + upper(@titulo) + replicate(' ',(@largura - len('* ' + replicate(' ',(@largura - len(@titulo))/2 - 2) + upper(@titulo)))-1) + ' *'
print '*' + replicate(' ',@largura - 1)+'*'

WHILE (@FIM = 0)
	BEGIN 
		PRINT '* ' + @AUX + REPLICATE(' ',@LARGURA - LEN('* ' + @AUX + '*') ) +' *'
		IF(LEN(@AUX1) <= @LARGURA)
			BEGIN
				SET @FIM  = 1
				PRINT '* ' + @AUX1 + REPLICATE(' ',@LARGURA - LEN('* ' + @AUX1 + '*') ) +' *'
			END
		ELSE 
		    BEGIN
				SET @AUX  = LEFT(@AUX1,@LARGURA - 3)
				SET @AUX1 = RIGHT(@AUX1,LEN(@AUX1)-(@LARGURA - 3))
		    END
	END
	
print '*' + replicate(' ',@largura - 1)+'*'
print '* BANCO_SISTEMA : ' + @BANCOSISTEMA + REPLICATE(' ',@LARGURA - LEN('* BANCO_SISTEMA :' + @BANCOSISTEMA + ' *'))+ ' *'
print '* CRIADO POR    : ' + @AUTOR + REPLICATE(' ',@LARGURA - LEN( '* CRIADO POR    : ' + @AUTOR + 'DATA:' +CONVERT(VARCHAR(10),GETDATE(),103) + ' *')) +' DATA:' +CONVERT(VARCHAR(10),GETDATE(),103) + ' *'
print '* ALTERADO POR  : ' + @AUTOR + REPLICATE(' ',@LARGURA - LEN( '* ALTERADO POR  : ' + @AUTOR + 'DATA:' +CONVERT(VARCHAR(10),GETDATE(),103) + ' *')) +' DATA:' +CONVERT(VARCHAR(10),GETDATE(),103) + ' *'
print replicate('*',@largura +1)+'/'

