/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_inserir_analise_gabarito_preteste_enem]
GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    procedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]
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
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE 
                            WHERE CO_BARRA_REDACAO = @CODBARRA AND
                                id_corretor_A = @ID_CORRETOR1  AND
                                id_projeto = @ID_PROJETO)) BEGIN
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
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
                                                   diferenca_nota_final,id_projeto,
                                                   conclusao_analise,fila,
                                                   nota_final_b,
                                                   competencia1_b,        
                                                   competencia2_b,
                                                   competencia3_b,
                                                   competencia4_b,
                                                   competencia5_b,
                                                   nota_competencia1_b,
                                                   nota_competencia2_b,
                                                   nota_competencia3_b,
                                                   nota_competencia4_b,
                                                   nota_competencia5_b,
                                                   id_correcao_situacao_b, redacao_id
                                                    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
                           cor.link_imagem_recortada, cor.link_imagem_original,
                           nota_final_correcao,
                           id_competencia1_correcao,
                           id_competencia2_correcao,
                           id_competencia3_correcao,
                           id_competencia4_correcao,
                           id_competencia5_correcao,
                           nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
                           nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
                           nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
                           nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
                           nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
                           id_corretor, id_status, id_tipo_correcao,
                           case when nota_final_diferenca >= @LIMITE_NOTA_FINAL then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
                           case when divergencia_situacao = 'SIM' then 2 else 0 end,
                           nota_final_diferenca,id_projeto,
                           0 as conclusao_analise,
                           0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
                      FROM [vw_cor_batimento_gabarito] COR
                     WHERE cor.id_corretor = @ID_CORRETOR1 and
                           cor.redacao_id = @REDACAO_ID and
                           cor.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    set @ID_ANALISE = @@IDENTITY
					
				    -- CRIACAO LOG 
				    EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '+'
				    -- CRIACAO LOG - FIM

                    --ATUALIZA A CONCLUSAO DA ANALISE
                    update ana set ana.conclusao_analise = 
                           case when diferenca_situacao > 0 then 5
                         when situacao_nota_final = 2  then 4
                         when (situacao_competencia1 = 2 or
                               situacao_competencia2 = 2 or
                               situacao_competencia3 = 2 or
                               situacao_competencia4 = 2 or
                               situacao_competencia5 = 2 )then 3
                         when  situacao_nota_final = 1 then 2
                         when (situacao_competencia1 = 1 or
                               situacao_competencia2 = 1 or
                               situacao_competencia3 = 1 or
                               situacao_competencia4 = 1 or
                               situacao_competencia5 = 1 )then 1 else 0 end
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update ana
                           set ana.nota_corretor = dbo.fn_calcula_nota_desempenho_ouro_moda_preteste_enem(@ID_ANALISE),
                               ana.nota_desempenho = dbo.fn_calcula_nota_desempenho_ouro_moda_preteste_enem(@ID_ANALISE)
                          from correcoes_analise ana
                         where id = @ID_ANALISE
						 	 
						-- CRIACAO LOG 
						EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '~'
						-- CRIACAO LOG - FIM

                        update correcoes_corretor set 
                            nota_corretor =  (select avg(nota_corretor)                        
                                                            from correcoes_analise anax
                                                           where id_corretor_A = @ID_CORRETOR1)
                        where id = @ID_CORRETOR1

						-- CIRACAO LOG 
						EXEC SP_INSERE_LOG_CORRETOR @ID_CORRETOR1, @ID_PROJETO, NULL, '~'
						-- CRIACAO LOG - FIM

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN

GO
