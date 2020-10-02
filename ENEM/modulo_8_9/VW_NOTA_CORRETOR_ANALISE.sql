create view VW_NOTA_CORRETOR_ANALISE as 	
SELECT DISTINCT 
       ANA.co_barra_redacao, ANA.id_corretor_A AS ID_CORRETOR, ANA.id_projeto,
       CASE WHEN (DIFERENCA_SITUACAO > 0 OR diferenca_nota_final >= PRO.limite_nota_final or
                  diferenca_competencia1 >= PRO.limite_nota_competencia OR diferenca_competencia2 >= PRO.limite_nota_competencia  OR
			      diferenca_competencia3 >= PRO.limite_nota_competencia OR diferenca_competencia4 >= PRO.limite_nota_competencia  OR
			      diferenca_competencia5 >= PRO.limite_nota_competencia ) THEN 0 
            when diferenca_competencia1 > 0 OR diferenca_competencia2 > 0  OR
			      diferenca_competencia3 > 0 OR diferenca_competencia4 > 0  OR
			      diferenca_competencia5 > 0  then 1.1
			ELSE 1.4 END AS NOTA_CORRETOR

FROM correcoes_ANALISE ana WITH(NOLOCK) join projeto_projeto PRO  WITH(NOLOCK) ON (ANA.id_projeto = PRO.id)

