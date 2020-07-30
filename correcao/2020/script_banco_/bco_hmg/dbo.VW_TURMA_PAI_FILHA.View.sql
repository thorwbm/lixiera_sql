USE [erp_hmg]
GO
/****** Object:  View [dbo].[VW_TURMA_PAI_FILHA]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_TURMA_PAI_FILHA] AS 
select TUR.ID AS TURMA_ID, TUR.nome AS TURMA_NOME, ISnULL(PAI.ID, TUR.ID) AS TURMA_PAI_ID, ISNULL(PAI.NOME,TUR.NOME) AS TURMA_PAI_NOME, 
    TIPO = CASE WHEN PAI.ID IS NULL THEN 'PAI' ELSE 'FILHA' END 
 from academico_turma TUR LEFT JOIN academico_turma PAI ON (TUR.turma_pai_id = PAI.ID)
GO
