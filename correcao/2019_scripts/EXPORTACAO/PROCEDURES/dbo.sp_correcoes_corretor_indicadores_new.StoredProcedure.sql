/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores_new]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_correcoes_corretor_indicadores_new] 
	@DATA_CARGA date,
	@ID_PROJETO INT AS

	DECLARE @DATA_INICIO DATE
	SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto WITH (NOLOCK) where id = @id_projeto)

	 INSERT correcoes_corretor_indicadores 
	        (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, MODAS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)

	--declare @DATA_CARGA date
	--declare @ID_PROJETO INT 
	--set @DATA_CARGA = '2018-11-09'
	--set @ID_PROJETO = 4

select distinct usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice,
	   TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
	   OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
	   MODAS_CORRIGIDAS             = sum(MODAS_CORRIGIDAS), 
	   DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
	   APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
	   APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
	   TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),	  
	   DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
	   DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_a and 
       				                                                                                                       corx.id_projeto = anax.id_projeto)
       				              where corx.id_corretor = vw.usuario_id                  and 
       						            corx.id_status   = 3                              and 
       				                    @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 5 then 1 else 0 end),
	   MODAS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 6 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
	   DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)), 
	   DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)) 

  from  vw_usuario_hierarquia vw WITH (NOLOCK) left join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
																cast(ana.data_termino_A as date) = @DATA_CARGA) 
	    where VW.PROJETO_ID = 4  --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_b and 
       				                                                                                               corx.id_projeto = anax.id_projeto)
       				  where corx.id_corretor                = vw.usuario_id and 
       						corx.id_status                  = 3             and 
       				        cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       MODAS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
	   DESEMPENHO_OURO          = 0.0, 
	   DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw WITH (NOLOCK) join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_b      and 
                                                                                           vw.projeto_id = ana.id_projeto         and 
																                           cast(ana.data_termino_b as date) = @DATA_CARGA) 
	   where VW.PROJETO_ID = @ID_PROJETO --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
--where usuario_id = 1278
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************
UPDATE CCI SET 
       CCI.DSP = CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO
	                                     WHEN (CCI.OUROS_CORRIGIDAS = 0 OR CCI.MODAS_CORRIGIDAS = 0 ) THEN (CASE WHEN CCI.OUROS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_OURO
	                                                                                                             WHEN CCI.MODAS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_MODA 
																								                 ELSE NULL
	                                                                                                        END) *  0.7 + 
																			                            (SELECT ISNULL(CCIX.DSP,0) * 0.3 
																			                               FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
																			                              WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
																			                                    CCIX.projeto_id = CCI.PROJETO_ID AND 
																			                            		 CCIX.FLG_DADO_ATUAL = 1 AND
																			                            		CCIX.DATA_CALCULO =
																			                            		/*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
																			                            		                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
																			                                                                 WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
																			                                                                       CCIXX.projeto_id = CCI.PROJETO_ID AND 
																			                            		                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
																			                            											CCIXX.DSP IS NOT NULL  AND 
																			                            											CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/)
                                                                         ELSE 
																			 (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
																			 isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
																			    FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
																			   WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
																			         CCIX.projeto_id = CCI.PROJETO_ID AND 
																					 CCIX.FLG_DADO_ATUAL = 1 AND
																			 		CCIX.DATA_CALCULO =
																					/*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
																					                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
																			                                      WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
																			                                            CCIXX.projeto_id = CCI.PROJETO_ID AND 
																					                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
																														CCIXX.DSP IS NOT NULL  AND 
																														CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/),0) 														
								    END),2) AS FLOAT),																			
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
											 	                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
														       FROM correcoes_corretor_indicadores ccix
													          WHERE ccix.indice = cci.indice AND 
													                ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
													                  THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
																													                   FROM correcoes_corretor_indicadores ccix WITH (NOLOCK)
																												                      WHERE ccix.indice = cci.indice AND 
																												                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
	  CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
	   projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
	   projeto_id = @ID_PROJETO
GO
