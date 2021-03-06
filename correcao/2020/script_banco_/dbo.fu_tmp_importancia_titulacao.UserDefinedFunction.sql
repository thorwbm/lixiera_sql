USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_tmp_importancia_titulacao]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[fu_tmp_importancia_titulacao] (@titulacao varchar(50)) 
returns int as
begin

if @titulacao = 'PÓS-DOUTORADO' begin return 10 end
if @titulacao = 'PÓS-DOUTORA' begin return 10 end
if @titulacao = 'DOUTOR' begin return 20 end
if @titulacao = 'DOUTORA' begin return 20 end
if @titulacao = 'MESTRE' begin return 30 end
if @titulacao = 'MESTRADO' begin return 30 end
if @titulacao = 'MBA' begin return 40 end
if @titulacao = 'ESPECIALIZAÇÃO' begin return 50 end

  return null
end
GO
