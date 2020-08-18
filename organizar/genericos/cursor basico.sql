/*****************************************************************************************************************
*                                          IMPORTACAO DA CARGA HORARIA                                           *
*                                                                                                                *
* CURSOR QUE CORRE A TABELA TMP_CARGA_HORARIA E INSERE OS VALORES NA TABELA PFSALCMP.                            *
* OS ERROS IRAM SER INSERIDOS EM UMA TABELA DE LOG COM AS INFORMACOES SEPRADAS POR VIRGULA                       *
*                                                                                                                *
* AUTOR: WEMERSON BITTORI MADURO                                                                 DATA:14/01/2014 *
******************************************************************************************************************/

declare CUR_ cursor for 
	SELECT * FROM 
	open CUR_ 
		fetch next from CUR_ into CAMPOS NA ORDEM DO SELECT
		while @@FETCH_STATUS = 0
			BEGIN
				ACOES A SEREM TOMADAS


			fetch next from CUR_ into CAMPOS NA ORDEM DO SELECT
			END
	close CUR_ 
deallocate CUR_ 