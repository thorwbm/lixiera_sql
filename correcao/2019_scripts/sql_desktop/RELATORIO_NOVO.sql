

SELECT TOP 100 
       CO_PROJETO = RED.id_projeto,
	   CO_INSCRICAO = RED.co_inscricao,
	   CO_TIPO_AVALIACAO = 1, 
	   NU_CPF_AVA1 = PES1.cpf,  
	   DT_INICIO_AVA1 = COR1.data_inicio,
	   DATA_TERMINO_AVA1 = COR1.data_termino,
	   NU_TEMPO_AVA1 = COR1.tempo_em_correcao,
	   ID_LOTE_AVA1  = 0,

*
  FROM CORRECOES_REDACAO RED LEFT JOIN CORRECOES_CORRECAO COR1 ON (RED.co_barra_redacao = COR1.co_barra_redacao AND 
                                                                   RED.id_projeto       = COR1.id_projeto         )
				             LEFT JOIN USUARIOS_PESSOA    PES1 ON (COR1.id_corretor      = PES1.usuario_id)
