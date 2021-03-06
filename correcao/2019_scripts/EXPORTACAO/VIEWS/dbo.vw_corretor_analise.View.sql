/****** Object:  View [dbo].[vw_corretor_analise]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_corretor_analise] as
select id_corretor_A as id_corretor, sum(nota) as nota,
 QTD_CORRECOES = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
			       WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A),
 QTD_DISCREPANCIA = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
			       WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
				         (diferenca_situacao    = 2 OR
						  situacao_nota_final   = 2 OR
						  situacao_competencia1 = 2 OR
						  situacao_competencia2 = 2 OR
						  situacao_competencia3 = 2 OR
						  situacao_competencia4 = 2 OR
						  situacao_competencia5 = 2
						  )) ,
 QTD_DIVERGENCIA = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
			       WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
				         (diferenca_situacao    = 1 OR
						  situacao_nota_final   = 1 OR
						  situacao_competencia1 = 1 OR
						  situacao_competencia2 = 1 OR
						  situacao_competencia3 = 1 OR
						  situacao_competencia4 = 1 OR
						  situacao_competencia5 = 1
						  )) ,
 QTD_DISC_SITUACAO = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
			       WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
				         (diferenca_situacao    = 2))
  from (select id_corretor_A,
         	   nota = case when diferenca_situacao     = 0 and situacao_nota_final   = 0 and
         		          	    (situacao_competencia1 = 0 and situacao_competencia2 = 0 and
         		          	     situacao_competencia3 = 0 and situacao_competencia4 = 0 and
         		          	     situacao_competencia5 = 0 ) then 1.4
         	               when diferenca_situacao > 0 then 0
         		           when (situacao_nota_final   = 2 or
						        (situacao_competencia1 = 2 or situacao_competencia2 = 2 or
         		          	     situacao_competencia3 = 2 or situacao_competencia4 = 2 or
         		          	     situacao_competencia5 = 2 )) then 0 else 1.1 end
         from correcoes_analise) as tblbase
group by id_corretor_A

GO
