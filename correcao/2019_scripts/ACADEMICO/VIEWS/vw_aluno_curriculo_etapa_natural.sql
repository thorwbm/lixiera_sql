
CREATE VIEW vw_aluno_curriculo_etapa_natural AS 
SELECT ALU.id AS ALUNO_ID, ALU.user_id AS USUARIO_ID, ALU.nome AS ALUNO_NOME, 
       curriculo_id, CRC.nome AS CURRICULO_NOME, CRA.status_id AS STATUS_CURRICULO_ALUNO_ID, CSTA.nome AS STATUS_CURRICULO_ALUNO_NOME, 
	   ETPN.id AS ETAPA_NATURAL_ID, ETPA.ano AS ANO_ETAPA, ETA.id AS ETAPA_ID, ETA.nome AS ETAPA_NOME, 
	   CUR.id AS CURSO_ID, CUR.nome AS CURSO_NOME, 
	   TRN.id AS TURNO_ID, TRN.nome AS TURNO_NOME


  FROM curriculos_etapanatural ETPN WITH(NOLOCK) JOIN curriculos_aluno   CRA  WITH(NOLOCK) ON (CRA.id  = ETPN.curriculo_aluno_id)
                                                 JOIN curriculos_statusaluno CSTA WITH(NOLOCK) ON (CSTA.id = CRA.status_id)
                                                 JOIN academico_etapaano ETPA WITH(NOLOCK) ON (ETPA.id = ETPN.etapa_ano_id) 
												 JOIN academico_etapa    ETA  WITH(NOLOCK) ON (ETA.id  = ETPA.etapa_id)
												 JOIN academico_aluno    ALU  WITH(NOLOCK) ON (ALU.id  = CRA.aluno_id)
												 JOIN curriculos_curriculo CRC  WITH(NOLOCK) ON (CRC.id = CRA.curriculo_id)
												 JOIN academico_curso      CUR  WITH(NOLOCK) ON (CUR.id = CRC.curso_id)
												 JOIN academico_turno      TRN  WITH(NOLOCK) ON (TRN.id = CRC.turno_id)


