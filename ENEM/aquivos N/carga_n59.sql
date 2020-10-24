--   select cor.* 
--     from correcoes_correcao cor join correcoes_redacao red on (red.id = cor.redacao_id)
--   where cast(red.data_termino as date) = dateadd(day,-1,cast('2019-11-28' as date))
--   -- dateadd(day,-1,cast(dbo.getlocaldate() as date))
--   
--   select red.id, 1 as lote_id, red.id_projeto, dbo.getlocaldate() as criado_em, 'F'as tp_origem, red.co_inscricao, 2 as co_etapa, 'MG' AS SG_UF_PROVA, 
--          nu_conceito_max_competencia1 = pro.peso_competencia * 5, nu_conceito_max_competencia2 = pro.peso_competencia * 5, nu_conceito_max_competencia3 = pro.peso_competencia * 5,
--   	   nu_conceito_max_competencia4 = pro.peso_competencia * 5, nu_conceito_max_competencia5 = pro.peso_competencia * 5, co_tipo_avaliacao = 1, red.link_imagem_recortada, 
--   
--   	   nu_cpf_av1 = null, dt_inicio_av1 = null, dt_fim_av1 = null, nu_tempo_av1 = null, id_lote_av1 = null, co_situacao_redacao_av1 = null, sg_situacao_redacao_av1 = null, 
--   	   nu_nota_av1 = null, nu_nota_comp1_av1 = null, nu_nota_comp2_av1 = null, nu_nota_comp3_av1 = null, nu_nota_comp4_av1 = null, nu_nota_comp5_av1 = null, in_fere_dh_av1 = null, 
--   
--   	   nu_cpf_av1 = null, dt_inicio_av1 = null, dt_fim_av1 = null, nu_tempo_av1 = null, id_lote_av1 = null, co_situacao_redacao_av1 = null, sg_situacao_redacao_av1 = null, 
--   	   nu_nota_av1 = null, nu_nota_comp1_av1 = null, nu_nota_comp2_av1 = null, nu_nota_comp3_av1 = null, nu_nota_comp4_av1 = null, nu_nota_comp5_av1 = null, in_fere_dh_av1 = null
--   from correcoes_redacao red join projeto_projeto pro on (red.id_projeto = pro.id)
--   where cast(red.data_termino as date) = '2019-11-27'
--   and red.id = 307613
--   
--   
--   select top 10 * from correcoes_redacao  where ID  = 307776

--SELECT * FROM status
drop table #temp_n59;

WITH CTE_REDACAO AS (
			SELECT red.id, red.co_barra_redacao, red.co_inscricao, red.link_imagem_recortada, red.link_imagem_original,
			       red.nota_final, red.co_formulario, red.id_prova, red.id_correcao_situacao, red.id_redacao_situacao,
			       red.id_projeto, red.nota_competencia1, red.nota_competencia2, red.nota_competencia3, red.nota_competencia4, 
				   red.nota_competencia5, red.data_inicio, red.data_termino,
				     CONCEITO_MAX_COMPETENCIA1 =  pro.peso_competencia * 5
                   , CONCEITO_MAX_COMPETENCIA2 =  pro.peso_competencia * 5
                   , CONCEITO_MAX_COMPETENCIA3 =  pro.peso_competencia * 5
                   , CONCEITO_MAX_COMPETENCIA4 =  pro.peso_competencia * 5
                   , CONCEITO_MAX_COMPETENCIA5 =  pro.peso_competencia * 5,
				   N02.SG_UF_PROVA
			-- select  count(red.id)
			--INTO #temp_maior
			  FROM CORRECOES_REDACAO RED join projeto_projeto pro on (red.id_projeto = pro.id)
			                             JOIN INEP_N02 N02 ON (N02.CO_INSCRICAO = RED.co_inscricao)
                     
			 WHERE cast(red.data_termino as date) = dateadd(day,-1,cast('2019-12-10' as date)) AND
			       red. cancelado = 0 AND RED.id_STATUS = 4 AND 
				   red.id_redacaoouro IS NULL 
				   --AND   datepart (hour, red.data_termino) <= 11
				 --  GROUP BY datepart (hour, red.data_termino)
) 

	,	CTE_USUARIO AS (
			SELECT ID, USERNAME
			  FROM AUTH_USER USU 
)
	,	CTE_CORRECAO AS (
			SELECT cor.id, cor.data_inicio, cor.data_termino, cor.correcao, cor.nota_final,
                   cor.nota_competencia1, cor.nota_competencia2, cor.nota_competencia3, cor.nota_competencia4, cor.nota_competencia5, 
                   cor.tempo_em_correcao, cor.id_correcao_situacao,
                   cor.id_corretor, cor.id_status, cor.tipo_auditoria_id, cor.id_tipo_correcao, cor.redacao_id, USU.USERNAME AS CPF_CORRETOR, 
				   case when cor.competencia5 = -1 then 1 else 0 end infere_dh
			  FROM correcoes_correcao cor JOIN cte_redacao red ON (red.id = cor.redacao_id AND 
			                                                       red.id_projeto = cor.id_projeto)
									left	  JOIN CTE_USUARIO USU ON (USU.ID = COR.id_corretor)
) 

select TOP 1000000
 red.id as redacao_id, 
 CO_PROJETO = left(co_inscricao, 5) + '01'
 , TP_ORIGEM = 'V'
 , CO_INSCRICAO
 , SG_UF_PROVA = RED.SG_UF_PROVA
 , NU_CONCEITO_MAX_COMPETENCIA1 =  red.CONCEITO_MAX_COMPETENCIA1
 , NU_CONCEITO_MAX_COMPETENCIA2 =  red.CONCEITO_MAX_COMPETENCIA2
 , NU_CONCEITO_MAX_COMPETENCIA3 =  red.CONCEITO_MAX_COMPETENCIA3
 , NU_CONCEITO_MAX_COMPETENCIA4 =  red.CONCEITO_MAX_COMPETENCIA4
 , NU_CONCEITO_MAX_COMPETENCIA5 =  red.CONCEITO_MAX_COMPETENCIA5
 , CO_TIPO_AVALIACAO = 1
 , NU_CPF_AV1              = COR1.CPF_CORRETOR 
 , DT_INICIO_AV1		   = COR1.DATA_INICIO 
 , DT_FIM_AV1			   = COR1.DATA_TERMINO 
 , NU_TEMPO_AV1			   = COR1.TEMPO_EM_CORRECAO 
 , ID_LOTE_AV1			   = 1 
 , CO_SITUACAO_REDACAO_AV1 = COR1.ID_CORRECAO_SITUACAO 
 , IN_FERE_DH_AV1		   = COR1.INFERE_DH 
 , NU_NOTA_AV1			   = COR1.NOTA_FINAL 
 , NU_NOTA_COMP1_AV1	   = COR1.NOTA_COMPETENCIA1 
 , NU_NOTA_COMP2_AV1	   = COR1.NOTA_COMPETENCIA2 
 , NU_NOTA_COMP3_AV1	   = COR1.NOTA_COMPETENCIA3 
 , NU_NOTA_COMP4_AV1	   = COR1.NOTA_COMPETENCIA4 
 , NU_NOTA_COMP5_AV1	   = COR1.NOTA_COMPETENCIA5 
 , NU_CPF_AV2			   = COR2.CPF_CORRETOR  
 , DT_INICIO_AV2		   = COR2.DATA_INICIO  
 , DT_FIM_AV2			   = COR2.DATA_TERMINO  
 , NU_TEMPO_AV2			   = COR2.TEMPO_EM_CORRECAO  
 , ID_LOTE_AV2			   = 1  
 , CO_SITUACAO_REDACAO_AV2 = COR2.ID_CORRECAO_SITUACAO 
 , IN_FERE_DH_AV2		   = COR2.INFERE_DH 
 , NU_NOTA_AV2			   = COR2.NOTA_FINAL  
 , NU_NOTA_COMP1_AV2	   = COR2.NOTA_COMPETENCIA1  
 , NU_NOTA_COMP2_AV2	   = COR2.NOTA_COMPETENCIA2  
 , NU_NOTA_COMP3_AV2	   = COR2.NOTA_COMPETENCIA3  
 , NU_NOTA_COMP4_AV2	   = COR2.NOTA_COMPETENCIA4  
 , NU_NOTA_COMP5_AV2	   = COR2.NOTA_COMPETENCIA5  
 , NU_CPF_AV3              = COR3.CPF_CORRETOR  
 , DT_INICIO_AV3		   = COR3.DATA_INICIO  
 , DT_FIM_AV3			   = COR3.DATA_TERMINO  
 , NU_TEMPO_AV3			   = COR3.TEMPO_EM_CORRECAO  
 , ID_LOTE_AV3			   = 1  
 , CO_SITUACAO_REDACAO_AV3 = COR3.ID_CORRECAO_SITUACAO 
 , IN_FERE_DH_AV3		   = COR3.INFERE_DH  
 , NU_NOTA_AV3			   = COR3.NOTA_FINAL  
 , NU_NOTA_COMP1_AV3	   = COR3.NOTA_COMPETENCIA1  
 , NU_NOTA_COMP2_AV3	   = COR3.NOTA_COMPETENCIA2  
 , NU_NOTA_COMP3_AV3	   = COR3.NOTA_COMPETENCIA3  
 , NU_NOTA_COMP4_AV3	   = COR3.NOTA_COMPETENCIA4  
 , NU_NOTA_COMP5_AV3	   = COR3.NOTA_COMPETENCIA5  
 , NU_CPF_AV4              = COR4.CPF_CORRETOR     
 , DT_INICIO_AV4		   = COR4.DATA_INICIO   
 , DT_FIM_AV4			   = COR4.DATA_TERMINO   
 , NU_TEMPO_AV4			   = COR4.TEMPO_EM_CORRECAO   
 , ID_LOTE_AV4			   = 1   
 , CO_SITUACAO_REDACAO_AV4 = COR4.ID_CORRECAO_SITUACAO  
 , IN_FERE_DH_AV4		   = COR4.INFERE_DH   
 , NU_NOTA_AV4			   = COR4.NOTA_FINAL   
 , NU_NOTA_COMP1_AV4	   = COR4.NOTA_COMPETENCIA1   
 , NU_NOTA_COMP2_AV4	   = COR4.NOTA_COMPETENCIA2   
 , NU_NOTA_COMP3_AV4	   = COR4.NOTA_COMPETENCIA3   
 , NU_NOTA_COMP4_AV4	   = COR4.NOTA_COMPETENCIA4   
 , NU_NOTA_COMP5_AV4	   = COR4.NOTA_COMPETENCIA5   
 , NU_NOTA_MEDIA_COMP1	     = RED.NOTA_COMPETENCIA1 
 , NU_NOTA_MEDIA_COMP2	  	 = RED.NOTA_COMPETENCIA2 
 , NU_NOTA_MEDIA_COMP3	  	 = RED.NOTA_COMPETENCIA3 
 , NU_NOTA_MEDIA_COMP4	  	 = RED.NOTA_COMPETENCIA4 
 , NU_NOTA_MEDIA_COMP5	  	 = RED.NOTA_COMPETENCIA5 
 , CO_SITUACAO_REDACAO_FINAL = RED.ID_REDACAO_SITUACAO 
 , IN_FERE_DH_FINAL			 = COR5.INFERE_DH
 , NU_NOTA_FINAL			 = RED.NOTA_FINAL  
 , CO_JUSTIFICATIVA			 = NULL 
 , NU_CPF_AUDITOR			 = COR5.CPF_CORRETOR 
 , IN_DIVULGACAO			 = 0 
 INTO #temp_n59
from CTE_REDACAO red left  JOIN CTE_CORRECAO COR1 ON (COR1.redacao_id = RED.ID AND COR1.ID_TIPO_CORRECAO = 1) 
                     LEFT  JOIN CTE_CORRECAO COR2 ON (COR2.redacao_id = RED.ID AND COR2.ID_TIPO_CORRECAO = 2) 
                     LEFT JOIN CTE_CORRECAO COR3 ON (COR3.redacao_id = RED.ID AND COR3.ID_TIPO_CORRECAO = 3) 
                     LEFT JOIN CTE_CORRECAO COR4 ON (COR4.redacao_id = RED.ID AND COR4.ID_TIPO_CORRECAO = 4) 
                     LEFT JOIN CTE_CORRECAO COR5 ON (COR5.redacao_id = RED.ID AND COR5.ID_TIPO_CORRECAO = 7) 

--SELECT * FROM #temp_maior
--WHERE id NOT IN (
--SELECT id FROM #tmp_menor)


--SELECT * FROM correcoes_correcao WHERE id In (3026038)
--SELECT * FROM correcoes_correcao WHERE redacao_id In (3026038) , 3026040, 3026041, 3026042, 3026043, 3026044, 3026045, 3026046, 3026047, 3026048)


--SELECT cast(red.data_termino AS date), count(id) AS qtd
--  FROM correcoes_redacao red
--  WHERE id_status = 4 and id_redacaoouro IS NULL 
--  GROUP BY cast(red.data_termino AS date)
--  ORDER BY 2 desc

select * from #temp_n59  
where IN_FERE_DH_FINAL is NOT null 



SELECT * FROM vw_entregas_n59


select * from INEP_N02