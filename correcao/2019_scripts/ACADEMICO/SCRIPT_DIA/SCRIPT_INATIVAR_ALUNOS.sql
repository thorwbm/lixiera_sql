SELECT DISTINCT USU.*
 -- BEGIN TRAN UPDATE USU SET USU.is_active = 0
  FROM curriculos_aluno CRA JOIN curriculos_statusaluno CRS ON (CRS.id = CRA.status_id)
                            JOIN academico_aluno        ALU ON (ALU.id = CRA.aluno_id)
							JOIN auth_user              USU ON (USU.id = ALU.user_id)
   
WHERE CRS.curso_atual <> 1 AND 
      USU.is_active = 1 AND 
      NOT EXISTS ( SELECT TOP 1 1 FROM curriculos_aluno CRAX JOIN curriculos_statusaluno CRSX ON (CRSX.id = CRAX.status_id)
                                                             JOIN academico_aluno        ALUX ON (ALUX.id = CRAX.aluno_id)
							                                 JOIN auth_user              USUX ON (USUX.id = ALUX.user_id)  
					WHERE USUX.ID = USU.ID AND 
					      CRSX.curso_atual = 1 AND 
						  USUX.is_active   = 1)

ORDER BY 1
-- COMMIT 
--SELECT * FROM curriculos_statusaluno

SELECT USU.id, USU.is_active, USU.nome_civil, curriculo_id, CRS.id,CRS.nome, CRS.curso_atual
  FROM curriculos_aluno CRA JOIN curriculos_statusaluno CRS ON (CRS.id = CRA.status_id)
                            JOIN academico_aluno        ALU ON (ALU.id = CRA.aluno_id)
							JOIN auth_user              USU ON (USU.id = ALU.user_id)
WHERE USU.id = 4061
 AND 
      USU.is_active = 1