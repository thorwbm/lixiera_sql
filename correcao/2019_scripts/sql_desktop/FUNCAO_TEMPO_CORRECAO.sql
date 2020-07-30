
-- alter function [dbo].[fn_duracao_correcao] (@id_correcao int)
returns int
begin
declare @segundos int 

select  @segundos = case when diferenca > 1200 then 1200 else diferenca end  from (
select  id, data_inicio, data_termino , diferenca = datediff(second, data_inicio, data_termino)
from correcoes_correcao 
where id = @id_correcao) as tab 

	return @segundos

end