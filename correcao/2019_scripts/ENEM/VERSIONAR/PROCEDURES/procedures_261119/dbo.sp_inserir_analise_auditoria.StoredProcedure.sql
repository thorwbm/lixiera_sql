/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_auditoria]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_inserir_analise_auditoria]
GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_auditoria]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_inserir_analise_auditoria]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @LIMITE_NOTA_FINAL FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT
DECLARE @REDACAO_ID INT 

DECLARE @RETORNOU_REGISTRO INT


SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

 SELECT @NOTA         = NOTA_FINAL,           @COMP1          = COMPETENCIA1,
        @COMP2        = COMPETENCIA2,         @COMP3          = COMPETENCIA3,
        @COMP4        = COMPETENCIA4,         @COMP5          = COMPETENCIA5,
        @SITUACAO     = ID_CORRECAO_SITUACAO, @ID_PROJETO     = ID_PROJETO,
        @ID_CORRECAO1 = ID,                   @ID_CORRETOR1   = ID_CORRETOR,
        @ID_TIPO_CORRECAO = ID_TIPO_CORRECAO
   FROM CORRECOES_CORRECAO COR
  WHERE REDACAO_ID = @REDACAO_ID     AND
        CO_BARRA_REDACAO = @CODBARRA AND
        id_projeto = @ID_PROJETO     AND
        ID_TIPO_CORRECAO = 7
IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE
                            WHERE REDACAO_ID = @REDACAO_ID     AND
							      CO_BARRA_REDACAO = @CODBARRA AND
                                  id_corretor_A      = @ID_CORRETOR1  AND
                                  id_projeto         = @ID_PROJETO    AND
                                  id_tipo_correcao_A = @ID_TIPO_CORRECAO))
                BEGIN
                    SET @ERRO = 'JÁ EXISTE'
                END



            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/

                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, nota_competencia2_A, nota_competencia3_A,  nota_competencia4_A, nota_competencia5_A,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A, id_corretor_A, id_status_A, id_tipo_correcao_A,
                                                   id_projeto, conclusao_analise,fila, redacao_id)
                    SELECT co_barra_redacao, data_inicio,data_termino, id,
                           link_imagem_recortada, link_imagem_original,
                           nota_final, competencia1, competencia2, competencia3, competencia4, competencia5,
                           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao, id_projeto, 0,0, redacao_id
                      FROM CORRECOES_CORRECAO
                     WHERE REDACAO_ID = @REDACAO_ID     AND
					       id_corretor = @ID_CORRETOR1  and
                           co_barra_redacao = @CODBARRA and
                           id_projeto = @ID_PROJETO     and
                           id_tipo_correcao = @ID_TIPO_CORRECAO
            /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    select @ID_ANALISE = ANA.ID
                    FROM CORRECOES_ANALISE ANA
                     WHERE ANA.REDACAO_ID = @REDACAO_ID     AND 
					       ANA.CO_BARRA_REDACAO = @CODBARRA AND
                           ana.id_tipo_correcao_A = 7

					
						-- CRIACAO LOG 
						EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '+'
						-- CRIACAO LOG - FIM

            /****************************************************************************************************************/

             UPDATE RED SET RED.nota_final =  ANA.nota_final_A, red.id_correcao_situacao = ana.id_correcao_situacao_A,
			                                  red.id_status = 4, red.data_termino = ana.data_termino_a 
             FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id       = RED.id               AND
			                                                           ANA.co_barra_redacao = RED.co_barra_redacao AND
                                                                       ANA.id_projeto       = RED.id_projeto)
              WHERE ANA.ID = @ID_ANALISE

			  -- CRIACAO LOG
					EXEC INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
			 -- CRIACAO LOG - FIM

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'AUDITORIA - O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN

GO
