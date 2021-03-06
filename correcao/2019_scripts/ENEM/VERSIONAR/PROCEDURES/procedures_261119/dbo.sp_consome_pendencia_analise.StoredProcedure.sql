/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_consome_pendencia_analise]
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_consome_pendencia_analise] as
DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @RETORNO_AUX      VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)

 SET NOCOUNT ON;

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, id_correcao, id_tipo_correcao, id_projeto FROM CORRECOES_PENDENTEANALISE PEN 
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX 
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.redacao_id = PEN.redacao_id) AND
			                 PEN.criado_em <= DATEADD(second, -10, dbo.getlocaldate())
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @id, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
        while @@FETCH_STATUS = 0
            BEGIN

                /****************************************************************************************/
                /* CONFORME O TIPO DE CORRECAO E DIRECIONADO PARA UMA COMPARACAO                        */
                /* GRAVACAO 1-(COMPARACAO 1,2) 2-(COMPARACAO 1,3) 3-(COMPARACAO 2-3) 4-(COMPARACAO 3-4) */
                /* GRAVACAO 5-(COMPARACAO 5,gabarito)                                                   */
                /* CASO TIPO GRAVACAO SEJA 1 OU 2 SERA EXECUTADO APENAS A GRVACAO 1                     */
                /* CASO TIPO GRAVACAO SEJA 3 SERA EXECUTADO A GRVACAO 2 E A 3                           */
                /* CASO TIPO GRAVACAO SEJA 4 SERA EXECUTADO A GRVACAO 3 E A 4                           */
                /* CASO TIPO GRAVACAO SEJA 5 SERA EXECUTADO A GRVACAO 5 E A GABARITO                    */
                /* PARA DEMAIS TIPOS AINDA TEMOS QUE TRATAR FUTURAMENTE                                 */
                /****************************************************************************************/
                IF(@ID_TIPO_CORRECAO IN (1,2))
                    BEGIN
                        EXEC  sp_inserir_analise @ID_CORRECAO,1, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END
                ELSE IF(@ID_TIPO_CORRECAO =3 )
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise @ID_CORRECAO,2, @ID_PROJETO, @retorno output
                            IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                                END

                            EXEC  sp_inserir_analise @ID_CORRECAO,3, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                ELSE IF(@ID_TIPO_CORRECAO =4 )
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise @ID_CORRECAO,4, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                -- OURO
                ELSE IF(@ID_TIPO_CORRECAO = 5)
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                -- MODA
                ELSE IF(@ID_TIPO_CORRECAO = 6)
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                --- AUDITORIA
                ELSE IF(@ID_TIPO_CORRECAO = 7)
                    BEGIN
--                      BEGIN TRY
--                          BEGIN TRAN TIPO7

                            EXEC  sp_inserir_analise_auditoria @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN

                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT TRAN TIPO7
--                      END TRY
--                      BEGIN CATCH
--                          ROLLBACK TRAN TIPO7
--                      END CATCH
                    END

            fetch next from CRS_ANALISE into @ID, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
            END
    close CRS_ANALISE
deallocate CRS_ANALISE

 SET NOCOUNT OFF;
GO
