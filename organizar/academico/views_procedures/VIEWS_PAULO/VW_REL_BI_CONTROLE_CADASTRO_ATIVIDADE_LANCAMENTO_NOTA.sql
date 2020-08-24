--select * 
--  from vw_acd_rel_criterio_atividade 
-- where ano = 2020 
-- 
-- order by curso_nome, curriculo_nome, turma_nome, disciplina_nome, criterio_nome

/*****************************************************************************************************************
*                             VW_REL_BI_CONTROLE_CADASTRO_ATIVIDADE_LANCAMENTO_NOTA                              *
*                                                                                                                *
*  VIEW QUE RELACIONA CRITERIOS, ATIVIDADES E NOTAS LANCADAS                                                     *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : ERP_PRD                                                                                        *
* CRIADO POR    : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
* ALTERADO POR  : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
******************************************************************************************************************/

 create OR ALTER   view VW_REL_BI_CONTROLE_CADASTRO_ATIVIDADE_LANCAMENTO_NOTA as  
 WITH   CTE_ATIVIDADE_NAO_ENVIADA AS (
 SELECT AAU.atividade_id, count(aal.id) as NOTAS_LANCADAS,                    
        SUM(DISTINCT CASE WHEN AAL.divulgada_em IS NULL THEN 0 ELSE 1 END) AS NOTA_DIVULGADA   
  FROM  atividades_atividade_aula AAU LEFT JOIN atividades_atividade_aluno AAL ON (AAL.atividade_id = AAU.atividade_id)
  GROUP BY AAU.ATIVIDADE_ID )  
  
  SELECT DISTINCT  
         TDP.CURSO_ID, TDP.CURSO_NOME, TDP.CURRICULO_ID, TDP.CURRICULO_NOME, 
		 TDP.PROFESSOR_ID, TDP.PROFESSOR_NOME,
         TDP.TURMA_ID, TDP.TURMA_NOME, TDP.TURMA_CATEGORIA_ID, TDP.TURMA_CATEGORIA_NOME, 
		 TDP.DISCIPLINA_ID, TDP.DISCIPLINA_NOME,          
         CRI.ID AS CRITERIO_ID, CRI.NOME AS CRITERIO_NOME, CRI.VALOR AS CRITERIO_VALOR,ATI.NOME AS ATIVIDADE_NOME,ATI.VALOR AS ATIVIDADE_VALOR,        
         CASE WHEN ATI.ID IS NULL         THEN 'SEM ATIVIDADE' ELSE 'TEM ATIVIDADE' END AS ATIVIDADE,       
         CASE WHEN ANE.NOTAS_LANCADAS = 0 THEN 'NAO LANCADO'   ELSE CASE WHEN ATI.ID IS NULL THEN 'NAO LANCADO'   ELSE 'LANCADO'   END END AS LANCAMENTO_NOTA,        
         CASE WHEN ANE.NOTA_DIVULGADA = 0 THEN 'NAO DIVULGADO' ELSE CASE WHEN ATI.ID IS NULL THEN 'NAO DIVULGADO' ELSE 'DIVULGADO' END END AS DIVULGACAO_NOTA, 
         YEAR(TDP.INICIO_VIGENCIA) AS ANO   
    FROM vw_acd_curriculo_curso_turma_disciplina_professor TDP 
                  JOIN atividades_criterio_turmadisciplina ACT ON (TDP.turmadisciplina_id = ACT.turma_disciplina_id AND       
                                                                   TDP.professor_id = ACT.professor_id)   
			      JOIN ATIVIDADES_CRITERIO                 CRI ON (CRI.ID = ACT.criterio_id)      
			      LEFT JOIN ATIVIDADES_ATIVIDADE           ATI ON (ACT.ID = ATI.criterio_turma_disciplina_id) 
			      LEFT JOIN CTE_ATIVIDADE_NAO_ENVIADA      ANE ON (ATI.ID = ANE.atividade_id)   
