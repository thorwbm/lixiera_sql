/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito_preteste]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito_preteste]
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito_preteste]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito_preteste] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)
DECLARE @REDACAO_ID       INT

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, erro, id_correcao, co_barra_redacao,id_tipo_correcao, id_projeto, redacao_id
      FROM CORRECOES_PENDENTEANALISE PEN
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.REDACAO_ID = PEN.REDACAO_ID)
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO,  @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
        while @@FETCH_STATUS = 0
            BEGIN
                IF(@ID_TIPO_CORRECAO IN (1,2))
                    BEGIN
                        EXEC  sp_inserir_analise_gabarito_preteste @ID_CORRECAO, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END


            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
            END
    close CRS_ANALISE
deallocate CRS_ANALISE
GO
