/****** Object:  StoredProcedure [dbo].[sp_inserir_analise]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                             [SP_INSERIR_ANALISE]                                               *
*                                                                                                                *
*  PROCEDURE QUE EFETUA TODA A ANALISE DAS CORRECOES E COM BASE NESTAS ANALISES DESCIDE O FLUXO DA REDACAO NO PR *
* OCESSO DE CORRECAO.                                                                                            *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/
CREATE   procedure [dbo].[sp_inserir_analise]
    @ID_CORRECAO   INT,
    @TIPO_GRAVACAO INT,
    @ID_PROJETO    INT,
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
DECLARE @CONCLUSAO INT
DECLARE @REDACAO_ID INT

DECLARE @VAI_PARA_AUDITORIA INT
DECLARE @CODIGO_PD INT

DECLARE @LIMITE_NOTA_FINAL       FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT

DECLARE @NOTA_FINAL FLOAT
DECLARE @RETORNOU_REGISTRO INT

DECLARE @SOBERANA INT

DECLARE @EQUIDISTANTE INT
SET @EQUIDISTANTE = 0

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0
SET @VAI_PARA_AUDITORIA = 0


SELECT @CODIGO_PD  = ID FROM CORRECOES_SITUACAO WHERE SIGLA = 'PD'

-- ***** VERIFICA QUA O PRIMEIRO TIPO DE CORREÇÃO É SOBERANO *****
SELECT TOP 1 @SOBERANA = ID FROM CORRECOES_TIPO WHERE flag_soberano = 1 ORDER BY ID

SELECT @CODBARRA = COR.CO_BARRA_REDACAO,
       @LIMITE_NOTA_FINAL = PRO.limite_nota_final,
       @LIMITE_NOTA_COMPETENCIA = PRO.limite_nota_competencia,
       @REDACAO_ID = COR.REDACAO_ID
  FROM CORRECOES_CORRECAO COR WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (COR.id_projeto = PRO.id)
 WHERE COR.ID = @ID_CORRECAO AND
       COR.id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            /************** TESTAR O TIPO DE GRAVACAO 1-(COMPARACAO 1,2) 2-(COMPARACAO 1,3) 3-(COMPARACAO 2-3) 4-(COMPARACAO 3-4)
                                                      5-(COMPARACAO 5 E OURO) 6-(COMPARACAO 6-MODA) 7-(COMPAFRACAO 7-ABSOLUTA)*******/
            IF (@TIPO_GRAVACAO = 1)
                BEGIN
                    IF (EXISTS (SELECT TOP 1 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id   = @REDACAO_ID AND
                                       id_tipo_correcao_A = 1 AND
                                       id_tipo_correcao_B = 2 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                             FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_2 WITH (NOLOCK)
                            WHERE id = @REDACAO_ID AND
                                  id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END
                        END
                END
            ELSE IF (@TIPO_GRAVACAO = 2)
                BEGIN
                    IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id   = @REDACAO_ID AND
                                       id_tipo_correcao_A = 1 AND
                                       id_tipo_correcao_B = 3 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                             FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_3 
                            WHERE id = @REDACAO_ID AND
                                  id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END
                        END
                END
            ELSE IF (@TIPO_GRAVACAO = 3)
                BEGIN
                    IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id = @REDACAO_ID AND
                                       id_tipo_correcao_A = 2 AND
                                       id_tipo_correcao_B = 3 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                              FROM vw_cor_avalia_discrepancia_divergencia_correcao_2_3 
                            WHERE id = @REDACAO_ID AND
                                       id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END

                            SET @RETORNOU_REGISTRO = @@ROWCOUNT
                        END
                END
            ELSE IF (@TIPO_GRAVACAO = 4)
                BEGIN
                    IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id = @REDACAO_ID AND
                                       id_tipo_correcao_A = 3 AND
                                       id_tipo_correcao_B = 4 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                              FROM vw_cor_avalia_discrepancia_divergencia_correcao_3_4 
                            WHERE id = @REDACAO_ID AND
                                       id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END

                            SET @RETORNOU_REGISTRO = @@ROWCOUNT
                        END
                END

            IF (@ERRO = '')
                BEGIN
                    /******* SE FOR COMPARACAO ENTRE 1 E 2 E HOUVER DISCREPANCIA GRAVAR UM REGISTRO NA FILA3 *********/
                    /*************************************************************************************************
                                                   ENCCEJA
                                                       NOTA MAIOR OU IGUAL 400
                                                       SITUACOES DIFERENTES
                                                   ENEM
                                                       NOTAFINAL MAIOR  100
                                                       NOTACOMPETENCIA MAIOR  80
                                                       SITUACAO DIFERENTE
                    *************************************************************************************************/

                    IF((@SITUACAO = 'SIM') )
                        BEGIN
                            SET @CONCLUSAO = 5
                        END
                    ELSE IF ((@NOTA >= @LIMITE_NOTA_FINAL))
                        BEGIN
                            print @nota
                            print @LIMITE_NOTA_FINAL
                            SET @CONCLUSAO = 4
                        END
                    ELSE IF ((@COMP1 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP2 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP3 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP4 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP5 >= @LIMITE_NOTA_COMPETENCIA ) )
                        BEGIN
                            SET @CONCLUSAO = 3
                        END
                    ELSE IF ((@NOTA > 0) )
                        BEGIN
                            SET @CONCLUSAO = 2
                        END
                    ELSE IF ((@COMP1 > 0 OR
                              @COMP2 > 0 OR
                              @COMP3 > 0 OR
                              @COMP4 > 0 OR
                              @COMP5 > 0 )  )
                        BEGIN
                            SET @CONCLUSAO = 1
                        END
                    ELSE
                        BEGIN
                            SET @CONCLUSAO = 0
                        END

                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/

                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (id_correcao_A, co_barra_redacao, data_inicio_A, data_termino_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO, id_projeto,
                                                   diferenca_nota_final,
                                                   conclusao_analise,fila,redacao_id,
                                                   ID_CORRECAO_B,
                                                   DATA_INICIO_B,         
                                                   DATA_TERMINO_B,        
                                                   NOTA_FINAL_B,          
                                                   COMPETENCIA1_B,        
                                                   COMPETENCIA2_B,        
                                                   COMPETENCIA3_B,        
                                                   COMPETENCIA4_B,        
                                                   COMPETENCIA5_B,        
                                                   NOTA_COMPETENCIA1_B,   
                                                   NOTA_COMPETENCIA2_B,   
                                                   NOTA_COMPETENCIA3_B,   
                                                   NOTA_COMPETENCIA4_B,   
                                                   NOTA_COMPETENCIA5_B,   
                                                   ID_AUXILIAR1_B,        
                                                   ID_AUXILIAR2_B ,       
                                                   ID_CORRECAO_SITUACAO_B,
                                                   ID_CORRETOR_B,         
                                                   ID_STATUS_B,           
                                                   ID_TIPO_CORRECAO_B)
                    SELECT COR1.ID, COR1.co_barra_redacao, COR1.data_inicio, COR1.data_termino,
                           COR1.link_imagem_recortada, COR1.link_imagem_original,
                           COR1.nota_final, COR1.competencia1, COR1.competencia2, COR1.competencia3, COR1.competencia4, COR1.competencia5,
                           COR1.nota_competencia1, DIFERENCA_COMPETENCIA1 = @COMP1,
                           SITUACAO_COMPETENCIA1 = CASE WHEN @COMP1 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP1 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia2, DIFERENCA_COMPETENCIA2 = @COMP2,
                           SITUACAO_COMPETENCIA2 = CASE WHEN @COMP2 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP2 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia3, DIFERENCA_COMPETENCIA3 = @COMP3,
                           SITUACAO_COMPETENCIA3 = CASE WHEN @COMP3 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP3 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia4, DIFERENCA_COMPETENCIA4 = @COMP4,
                           SITUACAO_COMPETENCIA4 = CASE WHEN @COMP4 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP4 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia5, DIFERENCA_COMPETENCIA5 = @COMP5,
                           SITUACAO_COMPETENCIA5 = CASE WHEN @COMP5 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP5 = 0 THEN 0 ELSE 1 END,
                           COR1.id_auxiliar1, COR1.id_auxiliar2, COR1.id_correcao_situacao,
                           COR1.id_corretor, COR1.id_status, COR1.id_tipo_correcao,
                           SITUACAO_NOTA_FINAL   = CASE WHEN @NOTA    >= @LIMITE_NOTA_FINAL   THEN 2 WHEN @NOTA = 0 THEN 0 ELSE 1 END,
                           DIFERENCA_SITUACAO    = CASE WHEN @SITUACAO = 'SIM' THEN 2 ELSE 0 END, COR1.id_projeto,
                           @NOTA, @CONCLUSAO, 0, @REDACAO_ID,
                           COR2.ID,
                           COR2.data_inicio,
                           COR2.data_termino,
                           COR2.NOTA_FINAL,
                           COR2.competencia1,
                           COR2.competencia2,
                           COR2.competencia3,
                           COR2.competencia4,
                           COR2.competencia5,
                           COR2.NOTA_COMPETENCIA1,
                           COR2.NOTA_COMPETENCIA2,
                           COR2.NOTA_COMPETENCIA3,
                           COR2.NOTA_COMPETENCIA4,
                           COR2.NOTA_COMPETENCIA5,
                           COR2.id_auxiliar1,
                           COR2.id_auxiliar2,
                           COR2.id_correcao_situacao,
                           COR2.id_corretor,
                           COR2.id_status,
                           COR2.id_tipo_correcao
                      FROM CORRECOES_CORRECAO COR1 JOIN CORRECOES_CORRECAO COR2 ON COR2.redacao_id = COR1.REDACAO_ID
                     WHERE COR1.ID = @ID_CORRECAO1
                       AND COR2.ID = @ID_CORRECAO2
                       AND COR1.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    SET @ID_ANALISE = SCOPE_IDENTITY()
						
						-- CRIACAO LOG 
						EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '+'
						-- CRIACAO LOG - FIM

                END

            /****************************************************************************************************************/
           -- print 'passou 1'
            if exists(select top 1 1 from core_feature where codigo = 'auditoria' and ativo = 1) begin
          --  print 'passou 2'
                select distinct ID_PROJETO, redacao_id, CO_BARRA_REDACAO, id_correcao = null, corrigido_por = NULL, pendente = 0,
                        tipo_id = case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
                                                  when (id_correcao_situacao_A = @CODIGO_PD or id_correcao_situacao_B = @CODIGO_PD) then 2
                                                  when (competencia5_A = -1 or competencia5_B = -1)  then 3
                                                  else null end, id_corretor = null
                into #temp_auditoria
                 from correcoes_analise ana
                where (((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) or
                       (competencia5_A = -1 or competencia5_B = -1) or
                       (id_correcao_situacao_A = @CODIGO_PD or id_correcao_situacao_B = @CODIGO_PD)) and
                       not exists (select 1 from correcoes_filaauditoria audx
                                    where audx.redacao_id = ana.redacao_id and
                                          audx.id_projeto       = ana.id_projeto       and
                                          audx.tipo_id = (case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
                                                               when (id_correcao_situacao_A = @CODIGO_PD or
                                                                     id_correcao_situacao_B = @CODIGO_PD)
                                                                     then 2
                                                               when (competencia5_A = -1 or competencia5_B = -1)
                                                                    then 3
                                                               else null end)) and

                    id = @ID_ANALISE

					DECLARE @AUDITORIA_ID INT -- CRIACAO LOG

                    insert correcoes_filaauditoria (id_projeto, redacao_id, CO_BARRA_REDACAO, id_correcao, corrigido_por, pendente, tipo_id, id_corretor)
                    select * from #temp_auditoria tem
                    where not exists(select top 1 1 from correcoes_filaauditoria AUD WITH (NOLOCK) WHERE AUD.redacao_id = TEM.redacao_id)
                    SET @AUDITORIA_ID = SCOPE_IDENTITY()

					-- CRIACAO LOG
					EXEC SP_INSERE_LOG_FILAAUDITORIA @AUDITORIA_ID, @ID_PROJETO, NULL, '+'
					-- CRIACAO LOG - FIM 

                    set @VAI_PARA_AUDITORIA = 0

                    select @VAI_PARA_AUDITORIA = 1 from correcoes_filaauditoria aud WHERE AUD.redacao_id = @REDACAO_ID


                    if(exists(select top 1 1 from correcoes_correcao corx join correcoes_analise anax on (corx.redacao_id = anax.redacao_id)
                                 where anax.redacao_id = @REDACAO_ID and
                                       corx.id_tipo_correcao = 7))
                        begin
                            set @VAI_PARA_AUDITORIA = 1
                        end
            end
            /******************************************************************************************************************/
            /* EQUIDISTANCIA */

                /*select que busca todos equidistantes que nao possuem nenhuma discrepancia de competencia */
                IF ((SELECT COUNT(COR1.ID)
                                    FROM CORRECOES_CORRECAO COR1 JOIN CORRECOES_CORRECAO COR2 ON (COR1.redacao_id = COR2.redacao_id AND
                                                                                                                              COR1.id_tipo_correcao = 1 AND COR2.id_tipo_correcao = 2)
                                                                JOIN CORRECOES_CORRECAO COR3 ON (COR3.redacao_id = COR2.redacao_id AND
                                                                                                               COR3.id_tipo_correcao = 3)
                                     WHERE ((COR3.nota_final = (COR1.nota_final + COR2.nota_final)/2.0) OR
                                            (COR1.nota_final = COR2.nota_final AND
                                             COR1.id_correcao_situacao =1     AND
                                             COR2.id_correcao_situacao =1     AND
                                             COR3.id_correcao_situacao =1 ))  AND
                                             COR1.redacao_id = @REDACAO_ID and
                                            ((abs(cor3.competencia1 - cor2.competencia1)<=2) and
                                             (abs(cor3.competencia2 - cor2.competencia2)<=2) and
                                             (abs(cor3.competencia3 - cor2.competencia3)<=2) and
                                             (abs(cor3.competencia4 - cor2.competencia4)<=2) and
                                             (abs(cor3.competencia5 - cor2.competencia5)<=2)) and
                                            ((abs(cor3.competencia1 - cor1.competencia1)<=2) and
                                             (abs(cor3.competencia2 - cor1.competencia2)<=2) and
                                             (abs(cor3.competencia3 - cor1.competencia3)<=2) and
                                             (abs(cor3.competencia4 - cor1.competencia4)<=2) and
                                             (abs(cor3.competencia5 - cor1.competencia5)<=2))
                                             )> 0) and EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)
                        BEGIN

                            SET @EQUIDISTANTE = 1
                            SET @CONCLUSAO = 4
                            EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4
                        UPDATE correcoes_analise SET CONCLUSAO_ANALISE = 4 WHERE ID = @ID_ANALISE
						
						-- CRIACAO LOG 
						EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '~'
						-- CRIACAO LOG - FIM

                        END

           /*****************************************************************************************************************/
           /*****************************************************************************************************************/
                IF(@VAI_PARA_AUDITORIA = 0)
                    BEGIN
                        IF(EXISTS(SELECT 1 FROM CORE_FEATURE
                                   WHERE CODIGO = 'INSERE_NA_FILA_3_AUTOMATICO' AND ativo = 1) AND
                                         @CONCLUSAO > 2  and @TIPO_GRAVACAO = 1)
                            BEGIN
                                EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 3
                            END
                        ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)AND
                                 @CONCLUSAO > 2 and
                                 @TIPO_GRAVACAO = 3)
                            BEGIN
                               /* se houver discrepancia na analise da terceira nas duas comparacoes 1 e 2 */
                                IF ((select count(id) from correcoes_analise
                                      where redacao_id = @REDACAO_ID  and
                                            id_tipo_correcao_B = 3        and
                                            conclusao_analise > 2) = 2 )
                                    BEGIN
                                        EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4

                                    END
                            END
                          ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)AND
                                @EQUIDISTANTE = 1 and
                                 @TIPO_GRAVACAO = 3)
                            BEGIN
                                EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4

                            END
                        -- ****** CALCULO DA NOTA FINAL DA REDACAO
                        -- ***** se for comparacao de primeira com segunda e nao houver discrepancia
                        IF(@TIPO_GRAVACAO = 1 and @CONCLUSAO <= 2)
                            BEGIN
                                  UPDATE RED SET RED.nota_final = (ABS(ISNULL(ANA.nota_final_A,0) + ISNULL(ANA.nota_final_B,0))/2.0) ,
                                                 red.id_correcao_situacao = ana.id_correcao_situacao_B, 
												 red.id_status = 4 ,
												 red.data_termino = case when ana.data_termino_a > ana.data_termino_b then ana.data_termino_a else ana.data_termino_b end 
                                   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                   WHERE ANA.ID = @ID_ANALISE
								   -- CRIACAO LOG
										EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
								   -- CRIACAO LOG - FIM
								   -- ***** copia notas e valida a finalizacao
								   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                            END
                        -- ***** se for comparacao com terceira
                        ELSE IF(@TIPO_GRAVACAO IN (2,3) AND @EQUIDISTANTE = 0)  -- SE FOR EQUIDISTANTE NAO GRAVA NOTA
                            BEGIN
                                IF(@SOBERANA <> 3 )
                                    BEGIN

                                        if((select count(id) from correcoes_analise
                                          where redacao_id = @REDACAO_ID and
                                                id_tipo_correcao_B = 3        and
                                                conclusao_analise < 3) > 0)
                                        begin
                                            DECLARE @NOTA_AUX  FLOAT
                                            DECLARE @NOTA1 FLOAT
                                            DECLARE @NOTA2 FLOAT
                                            DECLARE @NOTA3 FLOAT
                                            DECLARE @SITUACAO1 INT
                                            DECLARE @SITUACAO2 INT
                                            DECLARE @SITUACAO_AUX INT

                                            select @NOTA1     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END,
                                                   @NOTA3     = nota_final_B,
                                                   @SITUACAO1 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
                                              from correcoes_analise
                                             where redacao_id = @REDACAO_ID and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 1

                                            select @NOTA2     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END,
                                                   @SITUACAO2 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
                                              from correcoes_analise
                                             where redacao_id = @REDACAO_ID and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 2

                                            SET @NOTA_AUX = (CASE WHEN (@NOTA2 < 0 AND @NOTA1 <0) THEN -1
                                                                  WHEN (@NOTA2 < 0) THEN @NOTA1
                                                                  WHEN (@NOTA1 < 0) THEN @NOTA2
                                                                  WHEN ABS(@NOTA3 - @NOTA2) >= ABS(@NOTA3-@NOTA1) THEN @NOTA1 ELSE @NOTA2 END)

                                            SET @SITUACAO_AUX = (CASE WHEN @SITUACAO1 > 0 THEN @SITUACAO1
                                                                      WHEN @SITUACAO2 > 0 THEN @SITUACAO2
                                                                 END)

                                            IF(@NOTA_AUX > 0)
                                                BEGIN
                                                    UPDATE RED SET RED.nota_final =  (ABS(ISNULL(@NOTA_AUX,0) + ISNULL(@NOTA3,0))/2.0), 
													               RED.id_correcao_situacao = @SITUACAO_AUX, 
												                   red.id_status = 4 , red.data_termino = ana.data_termino_b
                                                       FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                                       WHERE ANA.ID = @ID_ANALISE
													   
													   -- CRIACAO LOG
															EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
													   -- CRIACAO LOG - FIM

													   -- ***** copia notas e valida a finalizacao
													   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                                                END
                                            ELSE
                                                BEGIN
                                                    UPDATE RED SET RED.nota_final =  0.0 , RED.id_correcao_situacao = @SITUACAO_AUX, 
												                   red.id_status = 4 , red.data_termino = ana.data_termino_b
                                                       FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                                       WHERE ANA.ID = @ID_ANALISE
													   
													   -- CRIACAO LOG
															EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
													   -- CRIACAO LOG - FIM
													   -- ***** copia notas e valida a finalizacao
													   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                                                END

                                        end
                                    END -------
                                ELSE
                                    BEGIN
                                        UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B, 
												       red.id_status = 4 , red.data_termino = ana.data_termino_b
                                           FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                           WHERE ANA.ID = @ID_ANALISE
										   
										   -- CRIACAO LOG
												EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
										   -- CRIACAO LOG - FIM
										   -- ***** copia notas e valida a finalizacao
										   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                                    END
                            END
                        -- ***** se comparacao for com a quarta
                        ELSE IF(@TIPO_GRAVACAO IN (4) AND @SOBERANA = 4)
                            BEGIN

                                UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B, 
											   red.id_status = 4 , red.data_termino = ana.data_termino_b
                                   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                   WHERE ANA.ID = @ID_ANALISE
								   
								   -- CRIACAO LOG
										EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
								   -- CRIACAO LOG - FIM
								   -- ***** copia notas e valida a finalizacao
								   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                            END


                        IF (@TIPO_GRAVACAO = 3 and @erro = '' AND @EQUIDISTANTE = 0)
                            BEGIN
                                exec SP_AVALIA_APROVEITAMENTO @REDACAO_ID, @id_projeto
                            END
                    end
            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE()
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN
GO
