/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[sp_correcoes_corretor_indicadores] 
    @DATA_CARGA date,
    @ID_PROJETO INT AS

    DECLARE @DATA_INICIO DATE
    SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto WITH (NOLOCK) where id = @id_projeto)

     INSERT correcoes_corretor_indicadores 
            (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, MODAS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)

select distinct usuario_id, nome =ISNULL(nome,''), id_hierarquia, id_usuario_responsavel, projeto_id, indice,
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
        where VW.PROJETO_ID = @ID_PROJETO  --AND VW.USUARIO_ID = 5312
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
       where VW.PROJETO_ID = @ID_PROJETO 
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************

UPDATE CCI SET 
       CCI.DSP =  CASE WHEN ouros_corrigidas = 0 AND modas_corrigidas = 0 THEN ISNULL((SELECT ci.DSP FROM correcoes_corretor_indicadores CI
                                                                                 WHERE CI.usuario_id = CCI.usuario_id
                                                                                   AND CI.projeto_id = CCI.projeto_id
                                                                                   AND DATA_CALCULO =
                                                                    /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                    FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                    WHERE CCIXX.usuario_id = CI.USUARIO_ID AND 
                                                                                                        CCIXX.projeto_id = CI.PROJETO_ID AND 
                                                                                                        CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                        CCIXX.DSP IS NOT NULL  AND 
                                                                                                        CCIXX.DATA_CALCULO < @DATA_CARGA)), 0)
                     ELSE ISNULL(CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO
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
                                    END),2) AS FLOAT), 0)
                    END,                                                                          
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
-- #######################################################
-- ESTES LOGS DEVERAO SER FEITOS DESSA FORMA PELO VOLUME
-- AS INSERCOES SAO FEITAS EM MASSA NESTE CASO
-- MAS FOI CRIADO TAMBEM UMA PROCEDURE PARA ESTE 
-- SP_INSERE_LOG_INDICADORES
-- #######################################################
DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
       projeto_id = @ID_PROJETO


-- CRIACAO LOG 
INSERT INTO LOG_correcoes_corretor_indicadores
	(history_date, history_change_reason, history_type, history_user_id, observacao,
	 id, id_hierarquia, dsp, data_calculo, nome, indice, tempo_correcao, ouros_corrigidas, modas_corrigidas, 
	 discrepancias_ouro, aproveitamentos_com_disc, aproveitamentos_sem_disc, total_correcoes, tempo_medio_correcao, 
	 taxa_discrepancia_ouro, taxa_aproveitamento, taxa_aproveitamento_coletivo, flg_dado_atual, desempenho_ouro, 
	 desempenho_moda, projeto_id, usuario_id, id_usuario_responsavel)
SELECT dbo.getlocaldate(), null, '-', usuario_id, null,
	   id, id_hierarquia, dsp, data_calculo, nome, indice, tempo_correcao, ouros_corrigidas, modas_corrigidas, 
	   discrepancias_ouro, aproveitamentos_com_disc, aproveitamentos_sem_disc, total_correcoes, tempo_medio_correcao, 
	   taxa_discrepancia_ouro, taxa_aproveitamento, taxa_aproveitamento_coletivo, flg_dado_atual, desempenho_ouro, 
	   desempenho_moda, projeto_id, usuario_id, id_usuario_responsavel					       
	FROM correcoes_corretor_indicadores 
	WHERE DATA_CALCULO = @DATA_CARGA AND 
          FLG_DADO_ATUAL = 1 AND 
          projeto_id = @ID_PROJETO
-- CRIACAO LOG - FIM 

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
       projeto_id = @ID_PROJETO

-- CRIACAO LOG 
INSERT INTO LOG_correcoes_corretor_indicadores
	(history_date, history_change_reason, history_type, history_user_id, observacao,
	 id, id_hierarquia, dsp, data_calculo, nome, indice, tempo_correcao, ouros_corrigidas, modas_corrigidas, 
	 discrepancias_ouro, aproveitamentos_com_disc, aproveitamentos_sem_disc, total_correcoes, tempo_medio_correcao, 
	 taxa_discrepancia_ouro, taxa_aproveitamento, taxa_aproveitamento_coletivo, flg_dado_atual, desempenho_ouro, 
	 desempenho_moda, projeto_id, usuario_id, id_usuario_responsavel)
SELECT dbo.getlocaldate(), null, '+', usuario_id, null,
	   id, id_hierarquia, dsp, data_calculo, nome, indice, tempo_correcao, ouros_corrigidas, modas_corrigidas, 
	   discrepancias_ouro, aproveitamentos_com_disc, aproveitamentos_sem_disc, total_correcoes, tempo_medio_correcao, 
	   taxa_discrepancia_ouro, taxa_aproveitamento, taxa_aproveitamento_coletivo, flg_dado_atual, desempenho_ouro, 
	   desempenho_moda, projeto_id, usuario_id, id_usuario_responsavel					       
	FROM correcoes_corretor_indicadores 
	WHERE DATA_CALCULO = @DATA_CARGA AND 
          FLG_DADO_ATUAL = 0 AND 
          projeto_id = @ID_PROJETO
-- CRIACAO LOG - FIM 

--Atualiza no corretor o valor mais recente de alguns indicadores
UPDATE cor
   SET cor.dsp = case when cci.desempenho_moda is null and cci.desempenho_ouro is null and cci.dsp = 0 then null else cci.dsp end,
       cor.tempo_medio_correcao = cci.tempo_medio_correcao
  FROM correcoes_corretor AS cor
       INNER JOIN correcoes_corretor_indicadores cci ON cci.usuario_id = cor.id
 WHERE cci.id = (SELECT max(cci2.id) FROM correcoes_corretor_indicadores cci2 WHERE cci2.usuario_id = cci.usuario_id)

 
-- CRIACAO LOG 
INSERT INTO LOG_correcoes_corretor
	(history_date, history_change_reason, history_type, history_user_id, observacao,
	 id, max_correcoes_dia, pode_corrigir_1, pode_corrigir_2, pode_corrigir_3, nota_corretor, tipo_cota, 
atualizado_por, id_grupo, status_id, dsp, tempo_medio_correcao, supervisor_em_banca, pode_corrigir_4)
SELECT dbo.getlocaldate(), null, '~', NULL, null,
	   id, max_correcoes_dia, pode_corrigir_1, pode_corrigir_2, pode_corrigir_3, nota_corretor, tipo_cota, 
       atualizado_por, id_grupo, status_id, dsp, tempo_medio_correcao, supervisor_em_banca, pode_corrigir_4				       
	FROM correcoes_corretor
	WHERE id IN (SELECT DISTINCT COR.id 
	               FROM correcoes_corretor AS cor INNER JOIN correcoes_corretor_indicadores cci ON cci.usuario_id = cor.id
                   WHERE cci.id = (SELECT max(cci2.id) FROM correcoes_corretor_indicadores cci2 WHERE cci2.usuario_id = cci.usuario_id))

-- CRIACAO LOG - FIM 
GO
