/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao_por_id]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_cor_corretor_redacao_por_id](@redacao_id int)
RETURNS VARCHAR(1000)
BEGIN
	DECLARE @RETORNO varchar(1000)
	declare @id_corretor int

	set @retorno = ''

declare abc cursor for
	select id_corretor from correcoes_correcao
	 where redacao_id = @redacao_id
	open abc
		fetch next from abc into @id_corretor
		while @@FETCH_STATUS = 0
			BEGIN

				set @retorno = @retorno + ',' + convert(varchar(20), @id_corretor) + ','

			fetch next from abc into @id_corretor
			END
	close abc
deallocate abc

return (@retorno)

END

GO
