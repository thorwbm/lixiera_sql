/****** Object:  View [dbo].[vw_todas_as_filas]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_todas_as_filas]
AS

select co_barra_redacao from correcoes_fila1 union all 
select co_barra_redacao from correcoes_fila2 union all
select co_barra_redacao from correcoes_fila3 union all 
select co_barra_redacao from correcoes_fila4 union all 
select co_barra_redacao from correcoes_filapessoal union all 
select co_barra_redacao from correcoes_filaauditoria  
GO
