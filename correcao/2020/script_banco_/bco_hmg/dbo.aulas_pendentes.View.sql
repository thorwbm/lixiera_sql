USE [erp_hmg]
GO
/****** Object:  View [dbo].[aulas_pendentes]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[aulas_pendentes] AS select * from academico_aula where data_termino < GETDATE() - 1 and status_id = 1
GO
