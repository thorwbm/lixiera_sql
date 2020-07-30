USE [erp_hmg]
GO
/****** Object:  View [dbo].[VW_AULA_GRUPO_DIVERGENCIA_DATA_INICIO_OU_TERMINO]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****** PRIMEIRO CASO - DATA INICIO OU DATA FIM DO GRUPO NAO BATE

CREATE view [dbo].[VW_AULA_GRUPO_DIVERGENCIA_DATA_INICIO_OU_TERMINO] AS 

  SELECT ID, DATA_INICIO, INICIO, DATA_TERMINO, TERMINO, 
         DIFERENCA_INICIO  = CASE WHEN data_inicio <> INICIO   THEN 'DIFERENTE' ELSE '' END , 
         DIFERENCA_TERMINO = CASE WHEN data_termino <> TERMINO THEN 'DIFERENTE' ELSE '' END 
   FROM VW_ACAD_AULA_GRUPO_DIVERGENCIA
  WHERE  (data_inicio <> INICIO OR 
         data_termino <> TERMINO) AND 
		 TIPO = 'DIVERGENCIA_DATAS'

GO
