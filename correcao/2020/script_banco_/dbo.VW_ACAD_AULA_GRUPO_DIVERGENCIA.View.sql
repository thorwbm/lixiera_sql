USE [erp_hmg]
GO
/****** Object:  View [dbo].[VW_ACAD_AULA_GRUPO_DIVERGENCIA]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****** PRIMEIRO CASO - DATA INICIO OU DATA FIM DO GRUPO NAO BATE

create view [dbo].[VW_ACAD_AULA_GRUPO_DIVERGENCIA] AS 
--****** PRIMEIRO CASO - DATA INICIO OU DATA FIM DO GRUPO NAO BATE
WITH CTE_AULA_GRUPO AS (
		select  gru.id, gru.data_inicio, gru.data_termino, INICIO =  MIN(aul.data_inicio), TERMINO = MAX(aul.data_termino)
			from academico_aula aul WITH(NOLOCK) join academico_grupoaula gru WITH(NOLOCK)  on (aul.grupo_id = gru.id)
		GROUP BY gru.id, gru.data_inicio, gru.data_termino
), 
	CTE_DIVERGENCIA_DATA AS (
  SELECT ID, DATA_INICIO, INICIO, DATA_TERMINO, TERMINO, TIPO = 'DIVERGENCIA_DATAS' 
   FROM CTE_AULA_GRUPO
  WHERE  data_inicio <> INICIO OR 
         data_termino <> TERMINO
),

-- ****** SEGUNDO CASO - GRUPOS QUE NAO POSSUEM AULA OU AULAS SEM GRUPO

-- ****** GRUPOS SEM AULA 
	CTE_GRUPO_SEM_AULA AS (
		SELECT GRU.ID, GRU.DATA_INICIO, INICIO = NULL, GRU.DATA_TERMINO, TERMINO = NULL , TIPO = 'GRUPO_SEM_AULA' 
		 FROM academico_grupoaula GRU WITH(NOLOCK) LEFT JOIN academico_aula AUL  WITH(NOLOCK)  ON (GRU.id = AUL.grupo_id)
		WHERE AUL.id IS NULL 
),
-- ****** AULAS SEM GRUPO
	CTE_AULAS_SEM_GRUPO AS(  
		SELECT AUL.ID, AUL.DATA_INICIO, INICIO = NULL, AUL.DATA_TERMINO, TERMINO = NULL, TIPO = 'AULA_SEM_GRUPO' 
		  FROM academico_grupoaula GRU WITH(NOLOCK) RIGHT JOIN academico_aula AUL  WITH(NOLOCK)  ON (GRU.id = AUL.grupo_id)
		 WHERE GRU.id IS NULL 
)

SELECT * FROM CTE_AULAS_SEM_GRUPO 
UNION 

SELECT * FROM CTE_GRUPO_SEM_AULA
UNION 

SELECT * FROM CTE_DIVERGENCIA_DATA
GO
