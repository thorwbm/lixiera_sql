
create OR ALTER view vw_analise_terceira_finalizadas as 
SELECT RED.ID, RED.id_projeto, red.nota_final as nota_final_red, red.id_correcao_situacao as id_redacao_situacao_red, 
       COR1.ID_CORRECAO_SITUACAO AS SITUACAO1, COR2.ID_CORRECAO_SITUACAO AS SITUACAO2, COR3.ID_CORRECAO_SITUACAO AS SITUACAO3, 
       COR1.id AS CORRECAO1_ID, COR2.id AS CORRECAO2_ID, COR3.id AS CORRECAO3_ID, 
       ANA13.conclusao_analise as conclusao_analise13, ANA23.conclusao_analise as conclusao_analise23, 	   
	   
	   COR1.NOTA_FINAL as nota_final_cor1, COR1.ID_CORRECAO_SITUACAO as situacao_cor1, COR1.competencia1 as comp11, COR1.competencia2 as comp12, COR1.competencia3 as comp13, COR1.competencia4 as comp14, COR1.competencia5 as comp15,
	   COR2.NOTA_FINAL as nota_final_cor2, COR2.ID_CORRECAO_SITUACAO as situacao_cor2, COR2.competencia1 as comp21, COR2.competencia2 as comp22, COR2.competencia3 as comp23, COR2.competencia4 as comp24, COR2.competencia5 as comp25,
	   COR3.NOTA_FINAL as nota_final_cor3, COR3.ID_CORRECAO_SITUACAO as situacao_cor3, COR3.competencia1 as comp31, COR3.competencia2 as comp32, COR3.competencia3 as comp33, COR3.competencia4 as comp34, COR3.competencia5 as comp35,

	   COR1.nota_competencia1 AS nota_COMP11, COR1.nota_competencia2 AS nota_COMP12, COR1.nota_competencia3 AS nota_COMP13, COR1.nota_competencia4 AS nota_COMP14, COR1.nota_COMPETENCIA5 AS nota_COMP15,
	   COR2.nota_competencia1 AS nota_COMP21, COR2.nota_competencia2 AS nota_COMP22, COR2.nota_competencia3 AS nota_COMP23, COR2.nota_competencia4 AS nota_COMP24, COR1.nota_COMPETENCIA5 AS nota_COMP25,
	   COR3.nota_competencia1 AS nota_COMP31, COR3.nota_competencia2 AS nota_COMP32, COR3.nota_competencia3 AS nota_COMP33, COR3.nota_competencia4 AS nota_COMP34, COR1.nota_COMPETENCIA5 AS nota_COMP35,

	   SOBERANA3 = CRT.flag_soberano 
  FROM CORRECOES_REDACAO RED JOIN correcoes_correcao COR1  ON (RED.ID = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.ID_TIPO_CORRECAO = 1)
                             JOIN correcoes_correcao COR2  ON (RED.ID = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.ID_TIPO_CORRECAO = 2)
							 JOIN correcoes_correcao COR3  ON (RED.ID = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.ID_TIPO_CORRECAO = 3)
							 JOIN CORRECOES_TIPO     CRT   ON (CRT.id = COR3.id_tipo_correcao)
							 JOIN correcoes_analise  ANA13 ON (RED.id = ANA13.REDACAO_ID AND ANA13.id_correcao_A = COR1.ID AND ANA13.ID_CORRECAO_B = COR3.ID)
							 JOIN correcoes_analise  ANA23 ON (RED.ID = ANA23.REDACAO_ID AND ANA23.id_correcao_A = COR2.ID AND ANA23.ID_CORRECAO_B = COR3.ID)
						LEFT JOIN correcoes_correcao COR4  ON (RED.ID = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.ID_TIPO_CORRECAO = 4)
						LEFT JOIN correcoes_correcao COR5  ON (RED.ID = COR5.redacao_id AND RED.id_projeto = COR5.id_projeto AND COR5.ID_TIPO_CORRECAO = 7)
WHERE COR4.id IS NULL AND  COR5.id IS NULL 