 ALTER VIEW VW_PROTOCOLO_ALUNOS AS 
SELECT DISTINCT 
       ALU.nome, ALU.ra, ptc.criado_em AS ABERTO_EM, ptc.mensagem AS SOLICITACAO,
       PRS.atualizado_em AS RESPONDIDO_EM, PRS.mensagem AS PARECER, USRR.last_name AS RESPONSAVEL_ATENDIMENTO, 
       PCT.id AS CATEGORIA_ID, PCT.nome AS CATEGORIA_PROTOCOLO, 
	   CUR.id AS CURSO_ID, CUR.nome AS CURSO_NOME, 
	   TUR.id AS TURMA_ID, TUR.nome AS TURMA_NOME,
	   DIS.id AS DISCIPLINA_ID, DIS.nome AS DISCIPLINA_NOME
FROM protocolos_protocolo PTC WITH(NOLOCK) JOIN auth_user                      USR  WITH(NOLOCK) ON (USR.id  = PTC.requerido_por )
                                           JOIN academico_aluno                ALU  WITH(NOLOCK) ON (USR.ID  = ALU.user_id       )
										   JOIN academico_turmadisciplinaaluno TDA  WITH(NOLOCK) ON (ALU.ID  = TDA.aluno_id)
										   JOIN academico_turmadisciplina      TRD  WITH(NOLOCK) ON (TRD.id  = TDA.turma_disciplina_id)
										   JOIN academico_turma                TUR  WITH(NOLOCK) ON (TUR.id  = TRD.turma_id)
										   JOIN academico_disciplina           DIS  WITH(NOLOCK) ON (DIS.id  = TRD.disciplina_id)
										   JOIN academico_curso                CUR  WITH(NOLOCK) ON (CUR.id  = TUR.curso_id)
										   JOIN protocolos_categoria           PCT  WITH(NOLOCK) ON (PCT.id  = PTC.category_id)
									  LEFT JOIN protocolos_resolucao           PRS  WITH(NOLOCK) ON (PTC.ID  = PRS.PROTOCOLO_ID  )
									  LEFT JOIN auth_user                      USRR WITH(NOLOCK) ON (USRR.id = PRS.atualizado_por)
		
		
	  