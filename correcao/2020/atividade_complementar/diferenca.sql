WITH CTE_HORAS_ATIVIDADE AS (
			select ALUNO_CPF = CPFALUNO COLLATE DATABASE_DEFAULT, ROUND(SUM(HORACOMPUTADA)/60.0,2) AS CARGA_HORARIA, COUNT(1) AS QTD
			from atividade_complementar..VW_INTEGRACAO_EDUCAT
			GROUP BY CPFALUNO
)

	,	CTE_HORAS_EDUCAT AS (
			SELECT ALUNO_CPF =CRA.aluno_cpf COLLATE DATABASE_DEFAULT, ROUND(SUM(ACA.CARGA_HORARIA),2) AS CARGA_HORARIA, COUNT(1) AS QTD 
			  FROM atividades_complementares_atividade ACA JOIN vw_Curriculo_aluno_pessoa CRA ON (CRA.curriculo_aluno_id = ACA.curriculo_aluno_id AND 
			                                                                                      CRA.curriculo_aluno_status_id = 13)
			 GROUP BY CRA.aluno_cpf
) 

			SELECT CRA.aluno_cpf, CRA.aluno_id, CRA.aluno_nome, CRA.aluno_ra, 
			       EDU.CARGA_HORARIA AS CARGA_HORARIA_EDUCAT, EDU.QTD AS QTD_EDUCAT,
				   ATI.CARGA_HORARIA AS CARGA_HORARIA_ATIVIDADE, ATI.QTD AS QTD_ATIVIDADE, CRA.curriculo_aluno_id

				   
			  FROM CTE_HORAS_EDUCAT EDU JOIN vw_Curriculo_aluno_pessoa CRA ON (CRA.aluno_cpf = EDU.ALUNO_CPF AND 
			                                                                   CRA.curriculo_aluno_status_id = 13)
			                       LEFT JOIN CTE_HORAS_ATIVIDADE ATI ON (EDU.ALUNO_CPF = ATI.ALUNO_CPF )			                             
			 WHERE-- EDU.CARGA_HORARIA > ATI.CARGA_HORARIA AND 
			 CRA.aluno_nome = 'DANIEL LOPES MADEIRA'

			 ORDER BY EDU.CARGA_HORARIA - ATI.CARGA_HORARIA desc

