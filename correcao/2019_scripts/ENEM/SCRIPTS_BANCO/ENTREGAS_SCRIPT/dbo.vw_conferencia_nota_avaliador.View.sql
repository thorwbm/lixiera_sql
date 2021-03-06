/****** Object:  View [dbo].[vw_conferencia_nota_avaliador]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[vw_conferencia_nota_avaliador]
GO
/****** Object:  View [dbo].[vw_conferencia_nota_avaliador]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_conferencia_nota_avaliador] as 
WITH CTE_AVALIADOR_1 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 1 
		  FROM INEP_N59 INE 
		  WHERE (nu_cpf_av1           IS NULL AND 
					(nu_nota_comp1_av1       IS NOT NULL OR 
					 nu_nota_comp2_av1       IS NOT NULL OR 
					 nu_nota_comp3_av1       IS NOT NULL OR 
					 nu_nota_comp4_av1       IS NOT NULL OR 
					 nu_nota_comp5_av1       IS NOT NULL OR 
					 dt_inicio_av1           IS NOT NULL OR 
					 dt_fim_av1              IS NOT NULL OR
					 nu_tempo_av1            IS NOT NULL OR 
					 co_situacao_redacao_av1 IS NOT NULL) 
				) OR 
				(nu_cpf_av1           IS NOT NULL AND 
					(nu_nota_comp1_av1       IS NULL OR 
					 nu_nota_comp2_av1       IS NULL OR 
					 nu_nota_comp3_av1       IS NULL OR 
					 nu_nota_comp4_av1       IS NULL OR 
					 nu_nota_comp5_av1       IS NULL OR 
					 dt_inicio_av1           IS NULL OR 
					 dt_fim_av1              IS NULL OR
					 nu_tempo_av1            IS NULL OR 
					 co_situacao_redacao_av1 IS NULL)
				)
)

	,CTE_AVALIADOR_2 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 2  
		  FROM INEP_N59 INE  
		  WHERE (           nu_cpf_av2 IS NULL AND 
					(nu_nota_comp1_av2 IS NOT NULL OR 
					 nu_nota_comp2_av2 IS NOT NULL OR 
					 nu_nota_comp3_av2 IS NOT NULL OR 
					 nu_nota_comp4_av2 IS NOT NULL OR 
					 nu_nota_comp5_av2 IS NOT NULL OR 
					     dt_inicio_av2 IS NOT NULL OR 
					        dt_fim_av2 IS NOT NULL OR
					      nu_tempo_av2 IS NOT NULL OR 
			   co_situacao_redacao_av2 IS NOT NULL) 
				) OR 
				(           nu_cpf_av2 IS NOT NULL AND 
					(nu_nota_comp1_av2 IS NULL OR 
					 nu_nota_comp2_av2 IS NULL OR 
					 nu_nota_comp3_av2 IS NULL OR 
					 nu_nota_comp4_av2 IS NULL OR 
					 nu_nota_comp5_av2 IS NULL OR 
					     dt_inicio_av2 IS NULL OR 
					        dt_fim_av2 IS NULL OR
					      nu_tempo_av2 IS NULL OR 
			   co_situacao_redacao_av2 IS NULL)
				)
)

	,CTE_AVALIADOR_3 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 3  
		  FROM INEP_N59 INE 
		  WHERE (           nu_cpf_av3 IS NULL AND 
					(nu_nota_comp1_av3 IS NOT NULL OR 
					 nu_nota_comp2_av3 IS NOT NULL OR 
					 nu_nota_comp3_av3 IS NOT NULL OR 
					 nu_nota_comp4_av3 IS NOT NULL OR 
					 nu_nota_comp5_av3 IS NOT NULL OR 
					     dt_inicio_av3 IS NOT NULL OR 
					        dt_fim_av3 IS NOT NULL OR
					      nu_tempo_av3 IS NOT NULL OR 
			   co_situacao_redacao_av3 IS NOT NULL) 
				) OR 
				(           nu_cpf_av3 IS NOT NULL AND 
					(nu_nota_comp1_av3 IS NULL OR 
					 nu_nota_comp2_av3 IS NULL OR 
					 nu_nota_comp3_av3 IS NULL OR 
					 nu_nota_comp4_av3 IS NULL OR 
					 nu_nota_comp5_av3 IS NULL OR 
					     dt_inicio_av3 IS NULL OR 
					        dt_fim_av3 IS NULL OR
					      nu_tempo_av3 IS NULL OR 
			   co_situacao_redacao_av3 IS NULL)
				)
)

	,CTE_AVALIADOR_4 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 4  
		  FROM INEP_N59 INE 
		  WHERE (           nu_cpf_av4 IS NULL AND 
					(nu_nota_comp1_av4 IS NOT NULL OR 
					 nu_nota_comp2_av4 IS NOT NULL OR 
					 nu_nota_comp3_av4 IS NOT NULL OR 
					 nu_nota_comp4_av4 IS NOT NULL OR 
					 nu_nota_comp5_av4 IS NOT NULL OR 
					     dt_inicio_av4 IS NOT NULL OR 
					        dt_fim_av4 IS NOT NULL OR
					      nu_tempo_av4 IS NOT NULL OR 
			   co_situacao_redacao_av4 IS NOT NULL) 
				) OR 
				(           nu_cpf_av4 IS NOT NULL AND 
					(nu_nota_comp1_av4 IS NULL OR 
					 nu_nota_comp2_av4 IS NULL OR 
					 nu_nota_comp3_av4 IS NULL OR 
					 nu_nota_comp4_av4 IS NULL OR 
					 nu_nota_comp5_av4 IS NULL OR 
					     dt_inicio_av4 IS NULL OR 
					        dt_fim_av4 IS NULL OR
					      nu_tempo_av4 IS NULL OR 
			   co_situacao_redacao_av4 IS NULL)
				)
)

	SELECT * FROM CTE_AVALIADOR_1
	UNION 
	SELECT * FROM CTE_AVALIADOR_2
	UNION 
	SELECT * FROM CTE_AVALIADOR_3
	UNION 
	SELECT * FROM CTE_AVALIADOR_4



	
GO
