
 -- select id,datediff(minute, data_inicio,data_termino), datediff(minute, data_inicio,data_termino) - isnull(vw.DIFERENCA,0), minutos_em_correcao
 -update cor set cor.minutos_em_correcao = datediff(minute, data_inicio,data_termino) - isnull(vw.DIFERENCA,0) 
 from correcoes_correcao cor left join VW_TEMPO_TOTAL_OCORRENCIA_POR_CORRECAO_ID vw on (cor.id = vw.correcao_id and cor.id_projeto = vw.id_projeto)
 where  minutos_em_correcao <> datediff(minute, data_inicio,data_termino) - isnull(vw.DIFERENCA,0) 
