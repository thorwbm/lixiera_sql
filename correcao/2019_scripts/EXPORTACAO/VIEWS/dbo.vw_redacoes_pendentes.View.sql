/****** Object:  View [dbo].[vw_redacoes_pendentes]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_redacoes_pendentes] as
select co_barra_redacao from (
select co_barra_redacao from correcoes_fila1 union
select co_barra_redacao from correcoes_fila2 union
select co_barra_redacao from correcoes_fila3 union
select co_barra_redacao from correcoes_fila4 union
select co_barra_redacao from correcoes_filaauditoria union
select co_barra_redacao from correcoes_correcao where data_termino is null and id_tipo_correcao in (1,2,3,4,7)
) tab
GO
