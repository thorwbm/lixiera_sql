/*****************************************************************************************************************************
*                                                 FN_CHECAR_ALUNO_TEM_CURRICULO                                              *
*                                                                                                                            *
*  FUNCAO QUE RECEBE COMO PARAMETRO O ID DO ALUNO [ALUNO_ID] E RETORNA [0] SE NAO HOUVER REGISTRO NA CURRUICLOS_ALUNO, CASO  *
*  CONTRARIO RETORNA [1]                                                                                                     *
*                                                                                                                            *
* BANCO_SISTEMA : EDUCAT                                                                                                     *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                    DATA:04/03/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                    DATA:04/03/2020 *
*****************************************************************************************************************************/
CREATE OR ALTER FUNCTION FN_CHECAR_ALUNO_TEM_CURRICULO (@ALUNO_ID INT) 
	RETURNS INT AS 

	BEGIN
		DECLARE @RETORNO INT 
		SET @RETORNO = 0
		SELECT @RETORNO = 1 FROM CURRICULOS_ALUNO WHERE ALUNO_ID = @ALUNO_ID
		IF (@RETORNO > 0)
			BEGIN
				SET @RETORNO = 1 
			END
		RETURN @RETORNO
	END

	---###### CONSTRAINTS ######

	SELECT * FROM ACADEMICO_TURMADISCIPLINAALUNO

	ALTER TABLE ACADEMICO_TURMADISCIPLINAALUNO ADD CONSTRAINT CHECK_ALUNO_CURRICULO CHECK (DBO.FN_CHECAR_ALUNO_TEM_CURRICULO(ALUNO_ID) = 1 )
