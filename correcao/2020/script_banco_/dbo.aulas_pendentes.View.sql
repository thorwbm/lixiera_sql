USE [erp_hmg]
GO
/****** Object:  View [dbo].[aulas_pendentes]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[aulas_pendentes] AS select * from academico_aula where data_termino < GETDATE() - 1 and status_id = 1
GO
