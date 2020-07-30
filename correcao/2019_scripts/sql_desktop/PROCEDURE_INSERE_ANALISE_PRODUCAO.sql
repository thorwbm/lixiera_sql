USE [correcao_redacao_regular]
GO

/****** Object:  StoredProcedure [dbo].[sp_inserir_analise]    Script Date: 10/12/2018 21:31:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************************
*                         PROCEDURE PARA FAZER A ANALISE (COMPARACAO) DE DUAS CORRECOES                          *
*                                                                                                                *
*  PROCEDURE QUE RECEBE O ID DE UMA CORRECAO E O ID DO PROJETO E ANALISA SE ESTA CORRECAO JA TEM PAR PARA        *
* COMPARACAO E GRAVA O RESULTADO NA TABELA CORRECOES_ANALISE -***- SENDO COMPARACAO ENTRE 1 E 2 E ANALISADO SE   *
* EXISTE DISCREPANCIA E CASO EXISTA E CRIADO UM NOVO REGISTRO NA FILA3                                           *
*                                                                                                                *
* BANCO_SISTEMA : ENCCEJA                                                                                        *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:30/08/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:30/08/2018 *
******************************************************************************************************************/
/*************************************************************
			SITUACAO COMPETENCIAS, SITUACAO E NOTAFINAL
			0 -> NORMAL
			1 -> DIVERGENCIA
			2 -> DISCREPANCIA
**************************************************************/

/*************************************************************
	VALORES PREDEFINIDOS APARA A CONCLUSAO DA ANALISE
		0 - SITUACAO NORMAL
		1 - DIVERGENCIA HORIZONTAL
		2 - DIVERGENCIA VERTICAL
		3 - DISCREPANCIA HORIZONTAL
		4 - DISCREPANCIA VERTICAL
		5 - DISCREPANCIA DE SITUACAO
*************************************************************/


ALTER procedure [dbo].[sp_inserir_analise] 
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


DECLARE @VAI_PARA_AUDITORIA INT
DECLARE @CODIGO_PD INT

DECLARE @LIMITE_NOTA_FINAL       FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT

DECLARE @NOTA_FINAL FLOAT                
DECLARE @RETORNOU_REGISTRO INT

DECLARE @SOBERANA INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0
SET @VAI_PARA_AUDITORIA = 0 

SELECT @CODIGO_PD  = ID FROM CORRECOES_SITUACAO WHERE SIGLA = 'PD'

SELECT @SOBERANA = ID FROM CORRECOES_TIPO WHERE flag_soberano = 1 -- ***** SETO QUAL A CORRECAO E SOBERANA *****

SELECT @CODBARRA = COR.CO_BARRA_REDACAO,
       @LIMITE_NOTA_FINAL = PRO.limite_nota_final,
	   @LIMITE_NOTA_COMPETENCIA = PRO.limite_nota_competencia
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
					IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
								 WHERE CO_BARRA_REDACAO   = @CODBARRA AND 
									   id_tipo_correcao_A = 1 AND 
									   id_tipo_correcao_B = 2 AND 
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END  
					ELSE
						BEGIN			
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3, 
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,	        
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,        
								   @ID_CORRETOR2 = ID_CORRETOR2
					  	     FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_2 WITH (NOLOCK)
							WHERE CO_BARRA_REDACAO = @CODBARRA AND 
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
								 WHERE CO_BARRA_REDACAO = @CODBARRA AND 
									   id_tipo_correcao_A = 1 AND 
									   id_tipo_correcao_B = 3 AND 
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END  
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3, 
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,	        
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,        
								   @ID_CORRETOR2 = ID_CORRETOR2
							 FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_3 WITH (NOLOCK)
							WHERE CO_BARRA_REDACAO = @CODBARRA AND 
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
								 WHERE CO_BARRA_REDACAO = @CODBARRA AND 
									   id_tipo_correcao_A = 2 AND 
									   id_tipo_correcao_B = 3 AND 
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END  
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3, 
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,	        
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,        
								   @ID_CORRETOR2 = ID_CORRETOR2
						  	  FROM vw_cor_avalia_discrepancia_divergencia_correcao_2_3 WITH (NOLOCK)
							WHERE CO_BARRA_REDACAO = @CODBARRA AND 
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
								 WHERE CO_BARRA_REDACAO = @CODBARRA AND 
									   id_tipo_correcao_A = 3 AND 
									   id_tipo_correcao_B = 4 AND 
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END  
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3, 
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,	        
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,        
								   @ID_CORRETOR2 = ID_CORRETOR2
						  	  FROM vw_cor_avalia_discrepancia_divergencia_correcao_3_4 WITH (NOLOCK)
							WHERE CO_BARRA_REDACAO = @CODBARRA AND 
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
												   conclusao_analise,fila)
					SELECT ID, co_barra_redacao, data_inicio,data_termino, 
						   link_imagem_recortada, link_imagem_original,
						   nota_final, competencia1, competencia2, competencia3, competencia4, competencia5,
						   nota_competencia1, DIFERENCA_COMPETENCIA1 = @COMP1, 
						   SITUACAO_COMPETENCIA1 = CASE WHEN @COMP1 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP1 = 0 THEN 0 ELSE 1 END,
						   nota_competencia2, DIFERENCA_COMPETENCIA2 = @COMP2,
						   SITUACAO_COMPETENCIA2 = CASE WHEN @COMP2 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP2 = 0 THEN 0 ELSE 1 END,
						   nota_competencia3, DIFERENCA_COMPETENCIA3 = @COMP3,
						   SITUACAO_COMPETENCIA3 = CASE WHEN @COMP3 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP3 = 0 THEN 0 ELSE 1 END,
						   nota_competencia4, DIFERENCA_COMPETENCIA4 = @COMP4, 
						   SITUACAO_COMPETENCIA4 = CASE WHEN @COMP4 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP4 = 0 THEN 0 ELSE 1 END,
						   nota_competencia5, DIFERENCA_COMPETENCIA5 = @COMP5, 
						   SITUACAO_COMPETENCIA5 = CASE WHEN @COMP5 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP5 = 0 THEN 0 ELSE 1 END,
						   id_auxiliar1, id_auxiliar2, id_correcao_situacao, 
						   id_corretor, id_status, id_tipo_correcao, 
						   SITUACAO_NOTA_FINAL   = CASE WHEN @NOTA    >= @LIMITE_NOTA_FINAL   THEN 2 WHEN @NOTA = 0 THEN 0 ELSE 1 END,
						   DIFERENCA_SITUACAO    = CASE WHEN @SITUACAO = 'SIM' THEN 2 ELSE 0 END, id_projeto,
						   @NOTA, @CONCLUSAO, 0
					  FROM CORRECOES_CORRECAO WITH (NOLOCK) 
					 WHERE ID = @ID_CORRECAO1 AND 
					       id_projeto = @ID_PROJETO 

					/***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
					select @ID_ANALISE = ANA.ID 
					  FROM CORRECOES_ANALISE ANA 
					 WHERE ANA.CO_BARRA_REDACAO = @CODBARRA AND 
	  					   ANA.ID_CORRECAO_A = @ID_CORRECAO1 AND 
						   ANA.ID_PROJETO = @ID_PROJETO


					/***** ATUALIZAR A LINHA DA TABELA ANALISE COM O SEGUNDO CORRETOR ******/
					UPDATE ANA SET ANA.ID_CORRECAO_B          = COR.ID,
							ANA.DATA_INICIO_B          = COR.data_inicio,
							ANA.DATA_TERMINO_B         = COR.data_termino,
							ANA.NOTA_FINAL_B           = COR.NOTA_FINAL,
							ANA.COMPETENCIA1_B         = COR.competencia1,
							ANA.COMPETENCIA2_B         = COR.competencia2,
							ANA.COMPETENCIA3_B         = COR.competencia3,
							ANA.COMPETENCIA4_B         = COR.competencia4,
							ANA.COMPETENCIA5_B         = COR.competencia5,
							ANA.NOTA_COMPETENCIA1_B    = COR.NOTA_COMPETENCIA1,
							ANA.NOTA_COMPETENCIA2_B    = COR.NOTA_COMPETENCIA2,
							ANA.NOTA_COMPETENCIA3_B    = COR.NOTA_COMPETENCIA3,
							ANA.NOTA_COMPETENCIA4_B    = COR.NOTA_COMPETENCIA4,
							ANA.NOTA_COMPETENCIA5_B    = COR.NOTA_COMPETENCIA5,
							ANA.ID_AUXILIAR1_B         = COR.id_auxiliar1,
							ANA.ID_AUXILIAR2_B         = COR.id_auxiliar2,
							ANA.ID_CORRECAO_SITUACAO_B = COR.id_correcao_situacao,
							ANA.ID_CORRETOR_B          = COR.id_corretor,
							ANA.ID_STATUS_B            = COR.id_status,
							ANA.ID_TIPO_CORRECAO_B     = COR.id_tipo_correcao 
					   FROM CORRECOES_CORRECAO COR WITH (NOLOCK) JOIN CORRECOES_ANALISE ANA WITH (NOLOCK) ON (COR.CO_BARRA_REDACAO = ANA.CO_BARRA_REDACAO AND
					                                                                                          COR.ID_PROJETO       = ANA.ID_PROJETO) 
					  WHERE ANA.ID = @ID_ANALISE AND 
							cor.id = @id_correcao2 AND
							ANA.ID_PROJETO = @ID_PROJETO
				END 
       
			/****************************************************************************************************************/				
				select distinct ID_PROJETO, CO_BARRA_REDACAO, id_correcao = null, corrigido_por = NULL, pendente = 0,
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
					                where audx.co_barra_redacao = ana.co_barra_redacao and
									      audx.id_projeto       = ana.id_projeto       and
										  audx.tipo_id = (case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
										                       when (id_correcao_situacao_A = @CODIGO_PD or 
															         id_correcao_situacao_B = @CODIGO_PD) 
																	 then 2
										                       when (competencia5_A = -1 or competencia5_B = -1)  
															        then 3
										                       else null end)) and
				     
					id = @ID_ANALISE

					insert correcoes_filaauditoria (id_projeto, CO_BARRA_REDACAO, id_correcao, corrigido_por, pendente, tipo_id, id_corretor)
					select * from #temp_auditoria tem
					where not exists(select top 1 1 from correcoes_correcao corx join correcoes_analise anax on (corx.co_barra_redacao = anax.co_barra_redacao)
					             where anax.id = @ID_ANALISE and 
								       corx.id_tipo_correcao = 7)
					set @VAI_PARA_AUDITORIA = @@rowcount

					if(exists(select top 1 1 from correcoes_correcao corx join correcoes_analise anax on (corx.co_barra_redacao = anax.co_barra_redacao)
					             where anax.co_barra_redacao = @CODBARRA and 
								       corx.id_tipo_correcao = 7))
						begin
							set @VAI_PARA_AUDITORIA = 1
						end

           /*****************************************************************************************************************/		   			
				IF(@VAI_PARA_AUDITORIA = 0)
					begin
						IF(EXISTS(SELECT 1 FROM CORE_FEATURE
								   WHERE CODIGO = 'INSERE_NA_FILA_3_AUTOMATICO' AND FLAG_LIGADO = 1) AND
							             @CONCLUSAO > 2  and @TIPO_GRAVACAO = 1) 
							BEGIN
								EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @ID_ANALISE, 3 
							END
						ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE
								        WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND FLAG_LIGADO = 1)AND
							                  @CONCLUSAO > 2 and	@TIPO_GRAVACAO = 3)  
							BEGIN
							    IF ((select count(id) from correcoes_analise 
								      where co_barra_redacao = @CODBARRA  and 
									        id_tipo_correcao_B = 3        and 
                                            conclusao_analise > 2) = 2)
									BEGIN
										EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @ID_ANALISE, 4 
									END
							END
						-- ****** CALCULO DA NOTA FINAL DA REDACAO 
					    -- ***** se for comparacao de primeira com segunda e nao houver discrepancia
						IF(@TIPO_GRAVACAO = 1 and @CONCLUSAO <= 2)
							BEGIN
								  UPDATE RED SET RED.nota_final = (ABS(ISNULL(ANA.nota_final_A,0) + ISNULL(ANA.nota_final_B,0))/2.0) , 
								                 red.id_correcao_situacao = ana.id_correcao_situacao_B
								   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao) 
								   WHERE ANA.ID = @ID_ANALISE
							END
						-- ***** se for comparacao com terceira 
						ELSE IF(@TIPO_GRAVACAO IN (2,3))  
							BEGIN
								IF(@SOBERANA <> 3)
									BEGIN

									if((select count(id) from correcoes_analise 
								      where co_barra_redacao =@CODBARRA and 
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
										 where co_barra_redacao = @CODBARRA and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 1

										select @NOTA2     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END, 
										       @SITUACAO2 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
										  from correcoes_analise 
										 where co_barra_redacao = @CODBARRA and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 2

										SET @NOTA_AUX = (CASE WHEN (@NOTA2 < 0 AND @NOTA1 <0) THEN -1 
													          WHEN (@NOTA2 < 0) THEN @NOTA1 
													          WHEN (@NOTA1 < 0) THEN @NOTA2 
													          WHEN (@NOTA3 - @NOTA2) >= (@NOTA3-@NOTA1) THEN @NOTA1 ELSE @NOTA2 END) 

										SET @SITUACAO_AUX = (CASE WHEN @SITUACAO1 > 0 THEN @SITUACAO1
										                          WHEN @SITUACAO2 > 0 THEN @SITUACAO2
										                     END)

                                        IF(@NOTA_AUX > 0)
											BEGIN
												UPDATE RED SET RED.nota_final =  (ABS(ISNULL(@NOTA_AUX,0) + ISNULL(@NOTA3,0))/2.0), RED.id_correcao_situacao = @SITUACAO_AUX						
												   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao) 
												   WHERE ANA.ID = @ID_ANALISE
											END
										ELSE
											BEGIN
												UPDATE RED SET RED.nota_final =  0.0 , RED.id_correcao_situacao = @SITUACAO_AUX					
												   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao) 
												   WHERE ANA.ID = @ID_ANALISE
												  
											END
								  
									end
									end -------
								ELSE  
									BEGIN
										UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B						
										   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao) 
										   WHERE ANA.ID = @ID_ANALISE
									END
							end
						-- ***** se comparacao for com a quarta 
						ELSE IF(@TIPO_GRAVACAO IN (4) AND @SOBERANA = 4)  
							BEGIN
								
								UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B						
								   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao) 
								   WHERE ANA.ID = @ID_ANALISE
							END


						IF (@TIPO_GRAVACAO = 3 and @erro = '')
							BEGIN
								exec SP_AVALIA_APROVEITAMENTO @codbarra, @id_projeto
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

