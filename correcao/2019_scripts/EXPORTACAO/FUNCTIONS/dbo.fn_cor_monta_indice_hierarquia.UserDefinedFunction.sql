/****** Object:  UserDefinedFunction [dbo].[fn_cor_monta_indice_hierarquia]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_cor_monta_indice_hierarquia]
	(@id int)
RETURNS VARCHAR(1000)
BEGIN

declare	@indice varchar(1000)  
   

declare @id_pai int
set @id_pai = 1000

set @indice = '.' + convert(varchar(50),@id) + '.'
while (@id_pai > 0) 
	begin 
		select @id_pai = isnull(id_hierarquia_usuario_pai,0) from usuarios_hierarquia where id = @id
		if (@id_pai > 0 and 
		    @id_pai <> 1000) 
			begin 
				set @indice = '.' + convert(varchar(50),@id_pai) + @indice
				set @id = @id_pai
			end 
		else 
			begin 
				set @id_pai = 0
			end 
	end
	
return (@indice)

END
GO
