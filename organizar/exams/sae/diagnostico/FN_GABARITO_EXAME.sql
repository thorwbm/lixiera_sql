
CREATE OR ALTER FUNCTION [dbo].[FN_GABARITO_EXAME] (@EXAME_ID int)
RETURNS VARCHAR(1000)
BEGIN
	declare @letra varchar(1)
	declare @linha varchar(250) =''

	declare CUR_ cursor for 
		 select  alt.letter 
		  from exam_exam exa join exam_collection col on (col.id = exa.collection_id)
							 join exam_examitem   ite on (exa.id = ite.exam_id)
							 join item_alternative alt on (ite.id = alt.item_id and alt.is_answer = 1)
		  WHERE EXA.ID = @EXAME_ID
		 ORDER BY ite.position

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