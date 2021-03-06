USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_tabela_coluna]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_tabela_coluna] as   
SELECT table_name as tabela, column_name as coluna FROM INFORMATION_SCHEMA.COLUMNS  
WHERE (TABLE_NAME NOT LIKE 'LOG_%' AND    
    TABLE_NAME NOT LIKE 'TMP%' AND   
    TABLE_NAME NOT LIKE 'BKP%' AND   
    TABLE_NAME NOT LIKE 'VW_%' ) 
GO
