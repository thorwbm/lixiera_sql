/****** Object:  StoredProcedure [dbo].[sp_copia_tabela]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_copia_tabela]
GO
/****** Object:  StoredProcedure [dbo].[sp_copia_tabela]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--PROCEDURES
--------------------------------------------------------------------------------------------------------------------
create   procedure [dbo].[sp_copia_tabela] @tabela varchar(255), @campos nvarchar(max) as
begin
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	declare @tabela_completa varchar(255) = '[' + @data_char + '].' + @tabela

	if not exists(select top 1 1 from information_schema.schemata where schema_name = @data_char) begin
		exec('create schema [' + @data_char + ']')
	end

	if object_id(@tabela_completa) is not null begin
		exec('drop table ' + @tabela_completa)
	end

	exec('select ' + @campos + ' into ' + @tabela_completa + ' from ' + @tabela)

end
GO
