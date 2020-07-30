 ALTER VIEW vw_relatorio_geral_por_time AS 
  WITH CTE_APROVEITAMENTO AS (
			SELECT usuario_id, SUM(nr_corrigidas) as nr_corrigidas,  SUM(nr_aproveitadas) as nr_aproveitadas,  
				SUM(nr_discrepantes) as nr_discrepantes, data  
              FROM vw_aproveitamento_notas_time WITH(NOLOCK) 
                                 GROUP BY usuario_id, data
  ),
		CTE_TEMPO_MEDIO AS (
			SELECT  cast(data_termino as date) AS DATA_TERMINO, id_corretor, AVG(tempo_em_correcao) as tempo_medio  
			  FROM correcoes_correcao  WITH(NOLOCK) 
             GROUP BY id_corretor, cast(data_termino as date)
	)

		SELECT   
        HIE.polo_id,  
        HIE.polo_descricao,  
        HIE.time_id,  
        HIE.time_descricao,  
        nome as avaliador,  
        HIE.usuario_id,  
        HIE.TIME_indice AS INDICE,  
        nr_corrigidas,  
        nr_aproveitadas,  
        nr_discrepantes,  
        tempo_medio,  
        cast(COR.dsp as varchar(20)) as dsp,  
        data   
        FROM vw_usuario_hierarquia_completa HIE  WITH(NOLOCK) JOIN      correcoes_corretor   COR WITH(NOLOCK) ON (COR.id          = HIE.usuario_id) 
		                                                        LEFT JOIN CTE_APROVEITAMENTO APR WITH(NOLOCK) ON (APR.usuario_id  = HIE.usuario_id)  
		                                                        LEFT JOIN CTE_TEMPO_MEDIO    TEM WITH(NOLOCK) ON (TEM.id_corretor = HIE.usuario_id AND 
																                                                  APR.data        = TEM.DATA_TERMINO)

  