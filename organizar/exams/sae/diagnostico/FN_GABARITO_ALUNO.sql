CREATE OR ALTER FUNCTION [dbo].[FN_GABARITO_ALUNO] (@application_id int)
RETURNS VARCHAR(1000)
BEGIN
	declare @letra varchar(1)
	declare @linha varchar(250) =''

	declare CUR_ cursor for 
		 SELECT alt.letter 
		 FROM application_answer ans with(nolock)  left join item_alternative alt with(nolock)  on (alt.id = ans.alternative_id)
		  WHERE application_id =   @application_id
		  order by ans.position
		open CUR_ 
			fetch next from CUR_ into @letra
			while @@FETCH_STATUS = 0
				BEGIN
					set @linha = @linha + isnull(@letra, 'X')

				fetch next from CUR_ into @letra
				END
		close CUR_ 
	deallocate CUR_ 

	RETURN @linha

end
GO
