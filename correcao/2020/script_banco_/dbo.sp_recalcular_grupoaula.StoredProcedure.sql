USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_recalcular_grupoaula]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_recalcular_grupoaula] @grupoaula_id int as 

select * from log_academico_grupoaula where id = @grupoaula_id
GO
