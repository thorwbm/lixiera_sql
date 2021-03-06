/****** Object:  UserDefinedFunction [dbo].[fn_duracao_correcao]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[fn_duracao_correcao] (@id_correcao int)
returns int
begin
declare @segundos int 

select  @segundos = case WHEN DIFERENCA < 0 THEN 0 
                         when diferenca >= 1200 then 1200 else diferenca end  from (
select  id, data_inicio, data_termino , diferenca = datediff(second, data_inicio, data_termino)
from correcoes_correcao 
where id = @id_correcao) as tab 

	return @segundos/60.0

end
GO
