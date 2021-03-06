/****** Object:  View [dbo].[vw_lotes]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[vw_lotes]
GO
/****** Object:  View [dbo].[vw_lotes]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_lotes] as 
select lote.id as lote_id, lote.nome as lote, interface.nome as interface, data_liberacao
  from inep_lote lote join inep_loteinterface interface on interface.id = lote.interface_id
 where lote.status_id = 2
GO
