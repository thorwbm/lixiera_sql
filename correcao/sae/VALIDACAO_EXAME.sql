/****************************************************************************************************
*                              SP_CONSISTENCIA_EXAME_ITEM_ALTERNATIVA                               *
*                                                                                                   *
*  Procedure que checa a quantidade de itens cadastrados para um exame e se este possui a mesma     *
*  quantidade de respostas para cada questao. tambem valida se existe apenas uma resposta correta   *
*  para cada questao.                                                                               *
*                                                                                                   *
* BANCO_SISTEMA : exams                                                                             *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:20/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:20/07/2020 *
****************************************************************************************************/

CREATE or alter PROCEDURE SP_CONSISTENCIA_EXAME_ITEM_ALTERNATIVA @EXAME_ID INT  AS

SET NOCOUNT ON

---------------------------------------------
DECLARE @EXAME_NOME            VARCHAR(200)
DECLARE @NRO_ITENS             INT
DECLARE @NRO_ALTERNATIVAS      INT 
DECLARE @CHECK_ALTERNATIVA     BIT = 0
DECLARE @CHECK_ALTERNATIVA_GAB BIT = 0

DECLARE @POSICAO               VARCHAR(10) 
DECLARE @QTD_ALTERNATIVA       VARCHAR(10)
DECLARE @ITEM_ID               VARCHAR(10)
---------------------------------------------

SELECT 
       @EXAME_NOME = EXAM_NOME, 
       @NRO_ITENS = max(qtd_itens), 
	   @NRO_ALTERNATIVAS = max(qtd_alternativa) 
  FROM 
       vw_analise_exame_item_alternativa
 WHERE 
       EXAM_ID = @EXAME_ID
 GROUP BY 
       EXAM_NOME

PRINT ('***********************************************************************')
PRINT ('*                  PROCEDURE DE CONSISTENCIA DE EXAME                 *')
PRINT ('***********************************************************************')
PRINT ('')

PRINT ('EXAME ID: ' + CONVERT(VARCHAR(10),@EXAME_ID))
PRINT ('EXAME: ' + @EXAME_NOME)
PRINT (REPLICATE('*',LEN('EXAME: ' + @EXAME_NOME) + 1))
PRINT ('')

PRINT ('Quantidade de itens cadastrados: ' + CONVERT(VARCHAR(10),@NRO_ITENS))
PRINT ('Maior quantidade de alternativa cadastrada por item: ' + CONVERT(VARCHAR(10),@NRO_ALTERNATIVAS))
PRINT ('***********************************************************************')
PRINT ('')

if(exists(SELECT 1 
            FROM vw_analise_exame_item_alternativa 
		   WHERE exam_id = @EXAME_ID AND qtd_alternativa <> (@NRO_ALTERNATIVAS)))
	BEGIN	
		PRINT ('Divergência na quantidade de alternativas cadastradas.')
		PRINT (REPLICATE('*',LEN('Divergência na quantidade de alternativas cadastradas.')))
		SET @CHECK_ALTERNATIVA = 1
	END
else
	BEGIN
		PRINT('Quantidade de alternativas: OK')
    END

if(exists(SELECT 1 
            FROM vw_analise_exame_item_alternativa 
		   WHERE exam_id = @EXAME_ID AND qtd_alternativa_gab <> 1))
	BEGIN	
		PRINT ('Divergência na quantidade de alternativa certa por item (gabarito).')
		PRINT (REPLICATE('*',LEN('Divergência na quantidade de alternativa certa por item (gabarito).')))
		SET @CHECK_ALTERNATIVA_GAB = 1
	END
else
	BEGIN
		PRINT('Quantidade de alternativa certa por item (gabarito): OK')
    END


PRINT ('***********************************************************************')
PRINT ('')

-- **** LISTAR DIVERGENCIA DE QUANTIDADE DE ALTERNATIVAS 

IF(@CHECK_ALTERNATIVA = 1)
	BEGIN
		PRINT('DIVERGÊNCIA DE QUANTIDADE DE ALTERNATIVAS')
		PRINT(REPLICATE('*',LEN('DIVERGÊNCIA DE QUANTIDADE DE ALTERNATIVAS')))

		declare CUR_ALT cursor for 
		    SELECT * FROM (
			SELECT DISTINCT
			       POSICAO = CONVERT(VARCHAR(10),POSITION), 
			       ITEM_ID = CONVERT(VARCHAR(10),ITEM_ID), 
			       QTD_ALTERNATIVA = CONVERT(VARCHAR(10),QTD_ALTERNATIVA)
			  FROM 
			       vw_analise_exame_item_alternativa 
		     WHERE 
			       exam_id = @EXAME_ID AND qtd_alternativa <> @NRO_ALTERNATIVAS) AS TAB
			 ORDER BY CAST(POSICAO AS INT)

			open CUR_ALT 
				fetch next from CUR_ALT into @POSICAO, @ITEM_ID, @QTD_ALTERNATIVA
				while @@FETCH_STATUS = 0
					BEGIN
						PRINT ('EXAME ID: ' + CONVERT(VARCHAR(10),@EXAME_ID) + ' - EXAME: ' + @EXAME_NOME + 
						       '  - POSIÇÃO: ' + @POSICAO + ' - ITEM_ID: ' + @ITEM_ID + 
							   ' - QUANTIDADE ALTERNATIVA: ' + @QTD_ALTERNATIVA)

					fetch next from CUR_ALT into @POSICAO, @ITEM_ID, @QTD_ALTERNATIVA
					END
			close CUR_ALT 
		deallocate CUR_ALT 
	END

-- **** LISTAR QUESTOES QUE POSSUAM NENHUMA OU MAIS DE UMA ALTERNATIVA COMO CORRETA
IF(@CHECK_ALTERNATIVA_GAB = 1)
	BEGIN
		PRINT('DIVERGÊNCIA DO NUMERO DE RESPOSTA CORRETA (GABARITO)')
		PRINT(REPLICATE('*',LEN('DIVERGÊNCIA DO NUMERO DE RESPOSTA CORRETA (GABARITO)')))

		declare CUR_GAB cursor for 
		    SELECT * FROM (
			SELECT DISTINCT
			       POSICAO = CONVERT(VARCHAR(10),POSITION), 
			       ITEM_ID = CONVERT(VARCHAR(10),ITEM_ID), 
			       qtd_alternativa_GAB = CONVERT(VARCHAR(10),qtd_alternativa_GAB)
			  FROM 
			       vw_analise_exame_item_alternativa 
		     WHERE 
			       exam_id = @EXAME_ID AND qtd_alternativa_GAB <> 1) AS TAB
			 ORDER BY CAST(POSICAO AS INT)

			open CUR_GAB 
				fetch next from CUR_GAB into @POSICAO, @ITEM_ID, @QTD_ALTERNATIVA
				while @@FETCH_STATUS = 0
					BEGIN
						PRINT ('EXAME ID: ' + CONVERT(VARCHAR(10),@EXAME_ID) + ' - EXAME: ' + @EXAME_NOME + 
						       '  - POSIÇÃO: ' + @POSICAO + ' - ITEM_ID: ' + @ITEM_ID + 
							   ' - QUANTIDADE ALTERNATIVA GABARITO: ' + @QTD_ALTERNATIVA)

					fetch next from CUR_GAB into @POSICAO, @ITEM_ID, @QTD_ALTERNATIVA
					END
			close CUR_GAB 
		deallocate CUR_GAB 
	END

SET NOCOUNT OFF




